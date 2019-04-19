import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:myapp/entity/message_entity.dart';
import 'package:myapp/page/chat_item_widgets.dart';
import 'package:myapp/page/more_widgets.dart';

/*
*  发送聊天信息
*/
class ChatPage extends StatefulWidget {
  final String title;
  final String senderAccount;

  const ChatPage(
      {Key key,
      @required this.title,
      @required this.senderAccount})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ChatState();
  }
}

class ChatState extends State<ChatPage> {
  bool _isBlackName = false;
  var _popString = List<String>();
  bool _isShowSend = false; //是否显示发送按钮
  bool _isShowVoice = false; //是否显示语音输入栏
  bool _isShowFace = false; //是否显示表情栏
  bool _isShowTools = false; //是否显示工具栏
  TextEditingController _controller = new TextEditingController();
  FocusNode _textFieldNode = FocusNode();
  var voiceText = '按住 说话';
  var voiceBackground = Colors.grey;
  Color _headsetColor = Colors.grey;
  Color _highlightColor = Colors.grey;
  List<Widget> _guideFaceList = new List();
  List<Widget> _guideFigureList = new List();
  List<Widget> _guideToolsList = new List();
  bool _isFaceFirstList = true;
  List<MessageEntity> _messageList = new List();
  bool _isLoadAll = false; //是否已经加载完本地数据
  bool _first = false;
  bool _alive = false;
  ScrollController _scrollController = new ScrollController();
  String _audioIconPath = '';
  String _voiceFilePath = '';
  String _voiceFileName = '';

  @override
  void initState() {
    // TODO: implement initState
    _first = true;
    _alive = true;
    super.initState();
    _getLocalMessage();
    _initData();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _alive = false;
    super.dispose();
    _first = false;
  }

  

  _getLocalMessage() async {
    // await MessageDataBase.get()
    //     .getMessageEntityInTypeLimit(widget.senderAccount,
    //         offset: _messageList.length, count: 20)
    //     .then((listEntity) async {
    //   if (null == listEntity || listEntity.length < 1) {
    //     _isLoadAll = true;
    //   } else {
    //     _isLoadAll = false;
    //   }
    //   for (MessageEntity entity in listEntity) {
    //     //最新的一条消息，在list的index=0
    //     _messageList.add(entity);
    //   }
    //   setState(() {});
    // });
  }

  _initData() {
    _popString.add('清空记录');
    _popString.add('删除好友');
    _popString.add('加入黑名单');
    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) {
        if (visible) {
          _isShowTools = false;
          _isShowFace = false;
          _isShowVoice = false;
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
  }




  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    Widget widgets = MaterialApp(
        theme: ThemeData(
            primaryColor: Colors.red,
            primarySwatch: Colors.grey,
            platform: TargetPlatform.iOS),
        home: Scaffold(
          appBar: _appBar(),
          body: _body(),
        ));
    return widgets;
  }

  _appBar() {
    return MoreWidgets.buildAppBar(
      context,
      _isBlackName ? widget.title + '(黑名单)' : widget.title,
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
              MoreWidgets.buildDefaultMessagePop(context, _popString,
                  onItemClick: (res) {
                
              });
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
            _isShowVoice = false;
            _isShowFace = false;
            _isShowTools = false;
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
                  icon: _isShowVoice
                      ? Icon(Icons.keyboard)
                      : Icon(Icons.play_circle_outline),
                  iconSize: 32,
                  onPressed: () {
                    setState(() {
                      _hideKeyBoard();
                      if (_isShowVoice) {
                        _isShowVoice = false;
                      } else {
                        _isShowVoice = true;
                        _isShowFace = false;
                        _isShowTools = false;
                      }
                    });
                  }),
              new Flexible(child: _enterWidget()),
              IconButton(
                  icon: _isShowFace
                      ? Icon(Icons.keyboard)
                      : Icon(Icons.sentiment_very_satisfied),
                  iconSize: 32,
                  onPressed: () {
                    _hideKeyBoard();
                    setState(() {
                      if (_isShowFace) {
                        _isShowFace = false;
                      } else {
                        _isShowFace = true;
                        _isShowVoice = false;
                        _isShowTools = false;
                      }
                    });
                  }),
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
                        margin: EdgeInsets.only(right: 8),
                        child: new Text(
                          '发送',
                          style: new TextStyle(
                              fontSize: 14.0, color: Colors.white),
                        ),
                        decoration: new BoxDecoration(
                          color: Colors.green,
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
                          if (_isShowTools) {
                            _isShowTools = false;
                          } else {
                            _isShowTools = true;
                            _isShowFace = false;
                            _isShowVoice = false;
                          }
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
      color: Colors.green,
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
        color: Colors.grey,
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
    return ChatItemWidgets.buildChatListItem(_nextEntity, _entity,
        onResend: (reSendEntity) {
      _onResend(reSendEntity); //重发
    }, onItemClick: (onClickEntity) async {
    });
  }


  //重发
  _onResend(MessageEntity entity) {
    if (entity.type == "chat") {
      _sendMessage(entity, isResend: true);
    }
  }

  _buildTextMessage(String content) {
    MessageEntity messageEntity = new MessageEntity(
        type: "chat",
        senderAccount: widget.senderAccount,
        titleName: widget.senderAccount,
        content: content, //如果是assets里的图片，则这里是assets图片的路径
        time: new DateTime.now().millisecondsSinceEpoch.toString());
    messageEntity.imageUrl = ''; //这里可以加上头像的url，不过对方和自己的头像目前都是取assets中固定的
    messageEntity.contentUrl = content;
    messageEntity.messageOwner = 0;
    messageEntity.status = '2';
    messageEntity.contentType = "system";
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
        messageEntity.status = '2';
      });
    }
    // TODO socket send message.
    // InteractNative.goNativeWithValue(InteractNative.methodNames['sendMessage'],
    //         ObjectUtil.buildMessage(messageEntity))
    //     .then((success) {
    //   if (success == true) {
    //     setState(() {
    //       messageEntity.status = '0';
    //     });
    //   } else {
    //     //一般黑名单的情况就发送失败
    //     DialogUtil.buildToast('发送失败');
    //     setState(() {
    //       messageEntity.status = '1';
    //     });
    //   }
    //   //插入数据库
    //   MessageDataBase.get()
    //       .insertMessageEntity(messageEntity.titleName, messageEntity)
    //       .then((res) {
    //     MessageDataBase.get()
    //         .getOneMessageUnreadCount(messageEntity.titleName)
    //         .then((onValue) {
    //       MessageTypeEntity messageTypeEntity = new MessageTypeEntity(
    //           senderAccount: messageEntity.titleName, isUnreadCount: onValue);
    //       MessageDataBase.get().insertMessageTypeEntity(messageTypeEntity);
    //       //刷新消息页面
    //       InteractNative.getMessageEventSink().add(messageEntity);
    //     });
    //   });
    // });
  }
}
