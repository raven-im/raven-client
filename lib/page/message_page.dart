import 'dart:convert';
import 'dart:io';

import 'package:flukit/flukit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:myapp/base/base_state.dart';
import 'package:myapp/database/db_api.dart';
import 'package:myapp/entity/content_entities/file_entity.dart';
import 'package:myapp/entity/content_entities/text_entity.dart';
import 'package:myapp/entity/group_entity.dart';
import 'package:myapp/entity/message_entity.dart';
import 'package:myapp/manager/message_manager.dart';
import 'package:myapp/manager/restful_manager.dart';
// import 'package:myapp/manager/sender_manager.dart';
import 'package:myapp/manager/wssender_manager.dart';
import 'package:myapp/page/message_item_widgets.dart';
import 'package:myapp/page/more_widgets.dart';
import 'package:myapp/page/photo_view_page.dart';
import 'package:myapp/utils/constants.dart';
import 'package:myapp/utils/dialog_util.dart';
import 'package:myapp/utils/image_util.dart';
import 'package:myapp/utils/interact_vative.dart';
import 'package:myapp/utils/popupwindow_widget.dart';
import 'package:myapp/utils/sp_util.dart';

import 'group_setting_page.dart';
import 'single_setting_page copy.dart';

/*
*  发送聊天信息
*/
class MessagePage extends StatefulWidget {
  final String title;
  final String targetUid;
  String convId;
  final String targetUrl;
  final int convType;

  MessagePage({
    Key key,
    @required this.title,
    @required this.targetUid,
    @required this.convId,
    @required this.targetUrl,
    @required this.convType,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MessageState();
  }
}

class MessageState extends BaseState<MessagePage> with WidgetsBindingObserver {
  bool _isShowSend = false; //是否显示发送按钮
  bool _isShowTools = false; //是否显示工具栏
  List<Widget> _guideToolsList = new List();
  TextEditingController _controller = new TextEditingController();
  FocusNode _textFieldNode = FocusNode();
  List<MessageEntity> _messageList = new List();
  ScrollController _scrollController = new ScrollController();
  String myUid = SPUtil.getString(Constants.KEY_LOGIN_UID);
  GroupEntity groupEntity;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  _initData() {
    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) {
        _isShowTools = false;
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

    //according to the db, pull new messages.
    // first time , no conversation id, but select one contact and send message.
    if (widget.convId != null) {
      DataBaseApi.get().getMessagesEntities(widget.convId).then((messages) {
        if (messages.length > 0) {
          DataBaseApi.get().getLatestMessageTime(widget.convId).then((time) {
            MessageManager.get()
                .requestMessageEntities(widget.convId, time + 1);
          });
        } else {
          MessageManager.get().requestMessageEntities(widget.convId, 0);
        }
      });
    }

    if (widget.convType == Constants.CONVERSATION_GROUP) {
      DataBaseApi.get().getGroupEntity(widget.targetUid).then((value) {
        groupEntity = value;
        if (this.mounted) {
          setState(() {});
        }
      });
    }
  }

  void _pullMsgAndDisplay() {
    _messageList.clear();
    DataBaseApi.get().getMessagesEntities(widget.convId).then((messages) {
      DataBaseApi.get().getAllContactsEntities().then((contacts) {
        messages.forEach((messge) {
          // for me.
          contacts.forEach((contact) {
            if (contact.userId == messge.fromUid) {
              messge.senderName = contact.userName;
            }
          });
          _messageList.insert(0, messge);
        });
        if (this.mounted) {
          setState(() {});
        }
      });
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
      widget.title +
          (groupEntity != null
              ? '(' + groupEntity.members.length.toString() + ')'
              : ''),
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
              if (widget.convType == Constants.CONVERSATION_GROUP) {
                Navigator.push(context, new MaterialPageRoute(builder: (ctx) {
                  return GroupSettingPage(groupId: widget.targetUid);
                }));
              } else if (widget.convType == Constants.CONVERSATION_SINGLE) {
                Navigator.push(context, new MaterialPageRoute(builder: (ctx) {
                  return SingleSettingPage(targetUid: widget.targetUid);
                }));
                
              }
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
                  icon: Icon(Icons.keyboard),
                  iconSize: 32,
                  onPressed: () {
                    setState(() {
                      _hideKeyBoard();
                      _isShowTools = false;
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
                          if (_isShowTools) {
                            _isShowTools = false;
                          } else {
                            _isShowTools = true;
                          }
                        });
                      }),
            ],
          ),
        ),
      ),
      (_isShowTools)
          ? Container(
              height: 210,
              child: _bottomWidget(),
            )
          : SizedBox(
              height: 0,
            )
    ]);
  }

  _hideKeyBoard() {
    _textFieldNode.unfocus();
  }

  _bottomWidget() {
    Widget widget;
    if (_isShowTools) {
      widget = _toolsWidget();
      // } else if (_isShowFace) {
      //   widget = _faceWidget();
      // } else if (_isShowVoice) {
      //   widget = _voiceWidget();
    }
    return widget;
  }

  _toolsWidget() {
    if (_guideToolsList.length > 0) {
      _guideToolsList.clear();
    }
    List<Widget> _widgets = new List();
    _widgets.add(MoreWidgets.buildIcon(Icons.insert_photo, 'Album', o: (res) {
      ImageUtil.getGalleryImage().then((imageFile) {
        //相册取图片
        _willBuildImageMessage(imageFile);
      });
    }));

    _widgets.add(MoreWidgets.buildIcon(Icons.camera_alt, 'Camera', o: (res) {
      PopupWindowUtil.showCameraChosen(context, onCallBack: (type, file) {
        if (type == 1) {
          //相机取图片
          _willBuildImageMessage(file);
        } else if (type == 2) {
          //相机拍视频
          _buildVideoMessage(file);
        }
      });
    }));
    _widgets.add(MoreWidgets.buildIcon(Icons.videocam, 'Video Call'));
    _widgets.add(MoreWidgets.buildIcon(Icons.location_on, 'Location'));
    _widgets.add(MoreWidgets.buildIcon(Icons.view_agenda, 'Red Packet'));
    _widgets.add(MoreWidgets.buildIcon(Icons.swap_horiz, 'Tansfer'));
    _widgets.add(MoreWidgets.buildIcon(Icons.mic, 'Voice Input'));
    _widgets.add(MoreWidgets.buildIcon(Icons.favorite, 'Favorites'));
    _guideToolsList.add(GridView.count(
        crossAxisCount: 4, padding: EdgeInsets.all(0.0), children: _widgets));

    return Swiper(
        autoStart: false,
        circular: false,
        indicator: CircleSwiperIndicator(
            radius: 3.0,
            padding: EdgeInsets.only(top: 10.0, bottom: 10),
            itemColor: Colors.grey,
            itemActiveColor: Colors.white),
        children: _guideToolsList);
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

  Future<Null> _onRefresh() async {}

  Widget _messageListViewItem(int index) {
    //list最后一条消息（时间上是最老的），是没有下一条了
    MessageEntity _nextEntity =
        (index == _messageList.length - 1) ? null : _messageList[index + 1];
    MessageEntity _entity = _messageList[index];
    return MessageItemWidgets.buildChatListItem(
        _nextEntity, _entity, widget.targetUrl, onResend: (reSendEntity) {
      _onResend(reSendEntity); //重发
    }, onItemClick: (onClickEntity) async {
      MessageEntity entity = onClickEntity;
      if (entity.contentType == Constants.CONTENT_TYPE_IMAGE) {
        //点击了图片
        var data = json.decode(entity.content);
        FileEntity imgEntity = FileEntity.fromMap(data);
        Navigator.push(
            context,
            new CupertinoPageRoute<void>(
                builder: (ctx) => PhotoViewPage(
                      images: [imgEntity.url],
                    )));
      }
    });
  }

  //重发
  _onResend(MessageEntity entity) {
    if (entity.contentType == Constants.CONTENT_TYPE_TEXT) {
      _sendMessage(entity, isResend: true);
    }
  }

  _buildTextMessage(String content) {
    TextEntity text = new TextEntity(content: content);
    String jsonText = json.encode(text.toMap());
    print(jsonText);
    MessageEntity messageEntity = new MessageEntity(
        contentType: Constants.CONTENT_TYPE_TEXT,
        fromUid: myUid,
        targetUid: widget.targetUid,
        convType: widget.convType,
        content: jsonText,
        convId: widget.convId,
        time: DateTime.now().millisecondsSinceEpoch.toString());
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
    if (widget.convType == Constants.CONVERSATION_SINGLE) {
      SenderMngr.sendSingleMessageReq(messageEntity);
    } else if (widget.convType == Constants.CONVERSATION_GROUP) {
      SenderMngr.sendGroupMessageReq(messageEntity);
    } else {
      print("error conversation type ${widget.convType}");
    }
  }

  _willBuildImageMessage(File imageFile) {
    if (imageFile == null || imageFile.path.isEmpty) {
      return;
    }
    DialogUtil.showBaseDialog(context, 'Full Image？', right: 'Yes', left: 'No',
        rightClick: (res) {
      _buildImageMessage(imageFile, true);
    }, leftClick: (res) {
      _buildImageMessage(imageFile, false);
    });
  }

  _buildImageMessage(File file, bool sendOriginalImage) {
    //TODO Full or compact
    // upload file to File server and then send image message.
    RestManager.get().uploadFile(file).then((image) {
      if (image == null) {
        // TODO set image message state fail.
        return;
      }
      String jsonImg = json.encode(image.toMap());
      MessageEntity messageEntity = new MessageEntity(
          contentType: Constants.CONTENT_TYPE_IMAGE,
          fromUid: myUid,
          targetUid: widget.targetUid,
          convType: Constants.CONVERSATION_SINGLE, // TODO
          content: jsonImg,
          convId: widget.convId,
          time: DateTime.now().millisecondsSinceEpoch.toString());
      messageEntity.messageOwner = 0;
      messageEntity.status = 0;

      setState(() {
        _messageList.insert(0, messageEntity);
        _controller.clear();
      });
      _sendMessage(messageEntity);
    });
  }

  _buildVideoMessage(File file) {
    // upload file to File server and then send image message.
    RestManager.get().uploadFile(file).then((image) {
      if (image == null) {
        // TODO set image message state fail.
        return;
      }
      String jsonImg = json.encode(image.toMap());
      MessageEntity messageEntity = new MessageEntity(
          contentType: Constants.CONTENT_TYPE_IMAGE,
          fromUid: myUid,
          targetUid: widget.targetUid,
          convType: Constants.CONVERSATION_SINGLE, // TODO
          content: jsonImg,
          convId: widget.convId,
          time: DateTime.now().millisecondsSinceEpoch.toString());
      messageEntity.messageOwner = 0;
      messageEntity.status = 0;

      setState(() {
        _messageList.insert(0, messageEntity);
        _controller.clear();
      });
      _sendMessage(messageEntity);
    });
  }

  @override
  void dispose() {
    print("message page dispose");
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void updateData(MessageEntity entity) {
    if (entity.convId != widget.convId) {
      return;
    }
    DataBaseApi.get().getAllContactsEntities().then((contacts) {
      // for me.
      contacts.forEach((contact) {
        if (contact.userId == entity.fromUid) {
          entity.senderName = contact.userName;
        }
      });
      if (widget.convId == null) {
        widget.convId = entity.convId;
      }

      _messageList.insert(0, entity);
      if (this.mounted) {
        setState(() {});
      }
    });
  }

  @override
  void notify(Object type) {
    if (type == InteractNative.PULL_MESSAGE) {
      _pullMsgAndDisplay();
    } else if (type == InteractNative.PULL_GROUP_INFO) {
      if (widget.convType == Constants.CONVERSATION_GROUP) {
        DataBaseApi.get().getGroupEntity(widget.targetUid).then((value) {
          groupEntity = value;
          if (this.mounted) {
            setState(() {});
          }
        });
      }
    } else if (type == InteractNative.GROUP_KICKED) {
      if (widget.convType == Constants.CONVERSATION_GROUP) {
        Navigator.pop(context);
      }
    }
  }
}
