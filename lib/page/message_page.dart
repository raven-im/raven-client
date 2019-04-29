import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:myapp/base/base_state.dart';
import 'package:myapp/database/db_api.dart';
import 'package:myapp/entity/message_entity.dart';
import 'package:myapp/manager/message_manager.dart';
import 'package:myapp/manager/sender_manager.dart';
import 'package:myapp/page/message_item_widgets.dart';
import 'package:myapp/page/more_widgets.dart';
import 'package:myapp/pb/message.pbenum.dart';
import 'package:myapp/utils/constants.dart';
import 'package:myapp/utils/interact_vative.dart';
import 'package:myapp/utils/sp_util.dart';

/*
*  发送聊天信息
*/
class MessagePage extends StatefulWidget {
  final String title;
  final String targetUid;
  final String convId;

  const MessagePage(
      {Key key,
      @required this.title,
      @required this.targetUid,
      @required this.convId,
      })
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MessageState();
  }
}

class MessageState extends BaseState<MessagePage> with WidgetsBindingObserver {
  
  bool _isShowSend = false; //是否显示发送按钮
  TextEditingController _controller = new TextEditingController();
  FocusNode _textFieldNode = FocusNode();
  List<MessageEntity> _messageList = new List();
  ScrollController _scrollController = new ScrollController();
  String myUid = SPUtil.getString(Constants.KEY_LOGIN_UID);

  @override
  void initState() {
    super.initState();
    _getLocalMessage();
    _initData();
  }

  _getLocalMessage() async {
    // await DataBaseApi.get().getMessagesEntities(widget.convId)
    //     .then((listEntity) async {
    //   for (MessageEntity entity in listEntity) {
    //     //最新的一条消息，在list的index=0
    //     _messageList.add(entity);
    //   }
    //   setState(() {});
    // });
  }

  _initData() {
    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) {
        if (visible) {
          try {
            _scrollController.position.jumpTo(0);
          } catch (e) {}
        }
      },
    );
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _onRefresh();
      }
    });
    _pullMsgAndDisplay();

    //according to the db, pull new messages.
    DataBaseApi.get().getMessagesEntities(widget.convId).then((messages) {
      if (messages.length > 0) {
        DataBaseApi.get().getLatestMessageTime(widget.convId).then((time) {
          MessageManager.get().requestMessageEntities(widget.convId, time);
        });
      } else {
        MessageManager.get().requestMessageEntities(widget.convId, 0);
      }
    });
  }

  void _pullMsgAndDisplay() {
    DataBaseApi.get().getMessagesEntities(widget.convId).then((messages) => {
      DataBaseApi.get().getAllContactsEntities().then((contacts) {
        messages.forEach((messge) {
          if (messge.contentType == Constants.MESSAGE_TYPE_CHAT && 
            myUid == messge.targetUid) {
              // for me.
              contacts.forEach((contact) {
                  if (contact.userId == messge.fromUid) {
                    messge.senderName = contact.userName;
                  }
                });
              _messageList.insert(0, messge);
            }
        });
        if (this.mounted) {
          setState(() {
            
          });
        }
    })
    });
  }
  @override
  Widget build(BuildContext context) {
    Widget widgets = MaterialApp(
        theme: ThemeData(
            primaryColor: Colors.blue,
            primarySwatch: Colors.grey,
            platform: TargetPlatform.android),
        home: Scaffold(
          appBar: _appBar(),
          body: _body(),
        ));
    return widgets;
  }

  _appBar() {
    return MoreWidgets.buildAppBar(
      context,
      widget.title,
      centerTitle: true,
      elevation: 2.0,
      leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          }),
      actions: <Widget>[
        InkWell(
            child: Container(
                padding: EdgeInsets.only(right: 15, left: 15),
                child: Icon(
                  Icons.more_horiz,
                  size: 22,
                )),
            onTap: () {
              // MoreWidgets.buildDefaultMessagePop(context, _popString,
              //     onItemClick: (res) {
                
              // });
            })
      ],
    );
  }

  _body() {
    return Column(children: <Widget>[
      Flexible(
          child: InkWell(
        child: _messageListView(),
        onTap: () {
          _hideKeyBoard();
          setState(() {
          });
        },
      )),
      Divider(height: 1.0),
      Container(
        decoration: new BoxDecoration(
          color: Theme.of(context).cardColor,
        ),
        child: Container(
          height: 54,
          child: Row(
            children: <Widget>[
              IconButton(
                  icon: Icon(Icons.keyboard),
                  iconSize: 32,
                  onPressed: () {
                    setState(() {
                      _hideKeyBoard();
                    });
                  }),
              new Flexible(child: _enterWidget()),
              // IconButton(
              //     icon: Icon(Icons.sentiment_very_satisfied),
              //     iconSize: 32,
              //     onPressed: () {
              //       _hideKeyBoard();
              //       setState(() {
                      
              //       });
              //     }),
              _isShowSend
                  ? InkWell(
                      onTap: () {
                        if (_controller.text.isEmpty) {
                          return;
                        }
                        _buildTextMessage(_controller.text);
                      },
                      child: new Container(
                        alignment: Alignment.center,
                        width: 40,
                        height: 32,
                        margin: EdgeInsets.only(right: 8, left: 8),
                        child: new Text(
                          'Send',
                          style: new TextStyle(
                              fontSize: 14.0, color: Colors.white),
                        ),
                        decoration: new BoxDecoration(
                          color: Colors.blueGrey,
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        ),
                      ),
                    )
                  : IconButton(
                      icon: Icon(Icons.add_circle_outline),
                      iconSize: 32,
                      onPressed: () {
                        _hideKeyBoard();
                        setState(() {
                          
                        });
                      }),
            ],
          ),
        ),
      ),
    ]);
  }

  _hideKeyBoard() {
    _textFieldNode.unfocus();
  }

 

  /*输入框*/
  _enterWidget() {
    return new Material(
      
      borderRadius: BorderRadius.circular(8.0),
      shadowColor: Colors.grey,
      color: Colors.blueGrey[100],
      elevation: 0,
      child: new TextField(
          focusNode: _textFieldNode,
          textInputAction: TextInputAction.send,
          controller: _controller,
          inputFormatters: [
            LengthLimitingTextInputFormatter(150), //长度限制11
          ], //只能输入整数
          style: TextStyle(color: Colors.black, fontSize: 18),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(10),
            border: InputBorder.none,
            filled: true,
            fillColor: Colors.transparent,
          ),
          onChanged: (str) {
            setState(() {
              if (str.isNotEmpty) {
                _isShowSend = true;
              } else {
                _isShowSend = false;
              }
            });
          },
          onEditingComplete: () {
            if (_controller.text.isEmpty) {
              return;
            }
            _buildTextMessage(_controller.text);
          }),
    );
  }

  _messageListView() {
    return Container(
        color: Colors.grey[300],
        child: Column(
          //如果只有一条数据，listView的高度由内容决定了，所以要加列，让listView看起来是满屏的
          children: <Widget>[
            Flexible(
                //外层是Column，所以在Column和ListView之间需要有个灵活变动的控件
                child: ListView.builder(
                    itemBuilder: (BuildContext context, int index) {
                      return _messageListViewItem(index);
                    },
                    //倒置过来的ListView，这样数据多的时候也会显示“底部”（其实是顶部），
                    //因为正常的listView数据多的时候，没有办法显示在顶部最后一条
                    reverse: true,
                    //如果只有一条数据，因为倒置了，数据会显示在最下面，上面有一块空白，
                    //所以应该让listView高度由内容决定
                    shrinkWrap: true,
                    controller: _scrollController,
                    itemCount: _messageList.length))
          ],
        ));
  }

  Future<Null> _onRefresh() async {
    await _getLocalMessage();
//    if (_isLoadAll) {
//      if (_messageList.length < 1) {
//        DialogUtil.buildToast('没有历史消息');
//      } else {
//        DialogUtil.buildToast('已加载全部历史消息');
//      }
//    }
  }

  Widget _messageListViewItem(int index) {
    //list最后一条消息（时间上是最老的），是没有下一条了
    MessageEntity _nextEntity =
        (index == _messageList.length - 1) ? null : _messageList[index + 1];
    MessageEntity _entity = _messageList[index];
    return MessageItemWidgets.buildChatListItem(_nextEntity, _entity,
        onResend: (reSendEntity) {
      _onResend(reSendEntity); //重发
    }, onItemClick: (onClickEntity) async {
    });
  }


  //重发
  _onResend(MessageEntity entity) {
    if (entity.contentType == Constants.MESSAGE_TYPE_CHAT) {
      _sendMessage(entity, isResend: true);
    }
  }

  _buildTextMessage(String content) {
    MessageEntity messageEntity = new MessageEntity(
        contentType: Constants.MESSAGE_TYPE_CHAT,
        fromUid: myUid,
        targetUid: widget.targetUid,
        convType: Constants.CONVERSATION_SINGLE,
        content: content,
        convId: widget.convId,
        time: new DateTime.now().millisecondsSinceEpoch.toString());
    messageEntity.messageOwner = 0;
    messageEntity.status = 0;
    setState(() {
      _messageList.insert(0, messageEntity);
      _controller.clear();
      _isShowSend = false;
    });
    _sendMessage(messageEntity);
  }

  _sendMessage(MessageEntity messageEntity, {bool isResend = false}) {
    if (isResend) {
      setState(() {
        messageEntity.status = 1;
      });
    }
    SenderMngr.sendSingleMessageReq(messageEntity.fromUid, messageEntity.targetUid, 
      MessageType.TEXT, messageEntity.content, convId:messageEntity.convId);
  }
  @override
  void dispose() {
    print(" message page dispose");
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void updateData(MessageEntity entity) {

    DataBaseApi.get().getAllContactsEntities().then((contacts) {
      
      if (entity.contentType == Constants.MESSAGE_TYPE_CHAT && 
          myUid==entity.targetUid) {
            // for me.
            contacts.forEach((contact) {
                if (contact.userId == entity.fromUid) {
                  entity.senderName = contact.userName;
                }
              });
            _messageList.insert(0, entity);
          }
      });
      if (this.mounted) {
        setState((){
          //Your state change code goes here
        });
      }
  }

  @override
  void notify(Object type) {
    if (type == InteractNative.PULL_MESSAGE) {
      _pullMsgAndDisplay();
    }
  }
}
