import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/base/messag_state.dart';
import 'package:myapp/entity/conversation_entity.dart';
import 'package:myapp/entity/message_entity.dart';
import 'package:myapp/message/conversation.dart';
import 'package:myapp/page/chat_page.dart';
import 'package:myapp/page/more_widgets.dart';
import 'package:myapp/utils/constants.dart';
import 'package:myapp/utils/date_util.dart';
import 'package:myapp/utils/sp_util.dart';

class MessagePage extends StatefulWidget {
  MessagePage({Key key, this.rootContext}) : super(key: key);
  final BuildContext rootContext;

  @override
  State<StatefulWidget> createState() {
    return new Message();
  }
}

class Message extends MessageState<MessagePage> with WidgetsBindingObserver {
  var map = Map();
  var list = new List();
  bool isShowNoPage = false;
  Timer _refreshTimer;
  AppLifecycleState currentState = AppLifecycleState.resumed;
  GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();//TODO

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _getData();
    _startRefresh();
  }

  @override
  Widget build(BuildContext context) {
    return layout(context);
  }

  Widget layout(BuildContext context) {
    return new Scaffold(
        key: _key,
        appBar: MoreWidgets.buildAppBar(context, 'Messages'),
        body: new Stack(
          children: <Widget>[
            new Offstage(
              offstage: isShowNoPage,
              child: ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    return _itemWidget(index);
                  },
                  itemCount: list.length),
            ),
            new Offstage(
              offstage: !isShowNoPage,
              child: MoreWidgets.buildNoDataPage(), //显示loading，则禁掉返回按钮和右滑关闭
            )
          ],
        ));
  }

  Widget _itemWidget(int index) {
    Widget res;
    ConversationEntity entity = map[list.elementAt(index).toString()];
    String timeTmp = DateUtil.getDateStrByDateTime(DateUtil.getDateTimeByMs(entity.timestamp));
    String time = DateUtil.formatDateTime(timeTmp, DateFormat.YEAR_MONTH_DAY, '/', '');
    res = MoreWidgets.conversationListViewItem(entity.senderAccount, entity.conversationType,
        content: entity.lastMessage,
        time: time,
        unread: entity.isUnreadCount, onItemClick: (res) {
      if (entity.conversationType == Constants.CONVERSATION_SINGLE) {
        //聊天消息，跳转聊天对话页面
        Navigator.push(
            context,
            new CupertinoPageRoute<void>(
                builder: (ctx) => ChatPage(
                      title: entity.senderAccount,
                      senderAccount: entity.senderAccount,
                    )));
      }
    });
    return res;
  }

  _getData() async {
    String myUid = SPUtil.getString(Constants.KEY_LOGIN_ACCOUNT);
    Conversaion.get().getConversationEntity(myUid).then((entities) async {
      if (entities.length > 0) {
        list.clear();
        map.clear();

        entities.forEach((entity) {
            list.insert(0, entity.senderAccount);//TODO  group?
            map[entity.senderAccount] = entity;
        });
        setState(() {
          isShowNoPage = list.length <= 0;
        });
      } else {
        setState(() {
          list.clear();
          map.clear();
          isShowNoPage = true;
        });
      }
    });
  }

  /*
  * 定时刷新
  */
  _startRefresh() {
    _refreshTimer =
        Timer.periodic(const Duration(milliseconds: 1000 * 60), _handleTime);
  }

  _handleTime(Timer timer) {
    //当APP在前台，且当前页是0（即本页），则刷新
    if (null != currentState &&
        currentState != AppLifecycleState.paused) {
      setState(() {
        print('refresh data');
      });
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
    //initState后，未调用，所以初始化为resume，当APP进入后台，则为onPause；APP进入前台，为resume
    currentState = state;
    if (currentState == AppLifecycleState.resumed) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    if (null != _refreshTimer) {
      _refreshTimer.cancel();
    }
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  void updateData(MessageEntity entity) {
    if (null != entity) {
      if (entity.type == Constants.MESSAGE_TYPE_CHAT) {

        if (list.contains(entity.titleName)) {
          //如果已经存在
          list.remove(entity.titleName);
          map.remove(entity.titleName);
        }
        list.insert(0, entity.titleName);
        map[entity.titleName] = entity;
        setState(() {
          isShowNoPage = list.length <= 0;
        });
      }
    }
  }
}
