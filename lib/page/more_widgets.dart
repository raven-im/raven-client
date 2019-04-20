import 'package:flutter/material.dart';
import 'package:myapp/utils/dialog_util.dart';
import 'package:myapp/utils/functions.dart';
import 'package:myapp/utils/object_util.dart';

class MoreWidgets {
  /*
  *  生成常用的AppBar
  */
  static Widget buildAppBar(BuildContext context, String text,
      {
        double fontSize: 18.0,
      double height: 50.0,
      double elevation: 0.5,
      Widget leading,
      bool centerTitle: false,
      List<Widget> actions,
      OnItemDoubleClick onItemDoubleClick}) {
    return PreferredSize(
        child: GestureDetector(
            onDoubleTap: () {
              if (null != onItemDoubleClick) {
                onItemDoubleClick(null);
              }
            },
            child: AppBar(
              elevation: elevation, //阴影
              centerTitle: centerTitle,
              title: Text(text, style: TextStyle(fontSize: fontSize)),
              leading: leading,
              actions: actions,
            )),
        preferredSize: Size.fromHeight(height));
  }

  /*
  *  生成朋友-ListView的item
  */
  static Widget buildListViewItem(String fileName, String text,
      {String dir = 'icon',
      String format = 'png',
      double padding = 8.0,
      double imageSize = 38.0}) {
    return Container(
        padding:
            EdgeInsets.only(left: 16.0, right: 16, top: padding, bottom: 0),
        child: Column(children: <Widget>[
          Row(
            children: <Widget>[
              SizedBox(
                height: 15.0,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(6.0),
                child: new Icon(Icons.favorite_border,
                    color: Colors.grey,
                ),
              ),
              SizedBox(
                width: 15.0,
              ),
              Expanded(
                //文本过长，打点
                flex: 1,
                child: Text(
                  text,
                  maxLines: 1,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 17.0, color: Colors.black),
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.only(left: 55.0, top: padding),
            child: Divider(height: 1.5),
          )
        ]));
  }

  /*
  *  生成消息-ListView的item
  */
  static Widget conversationListViewItem(
    String text, int contentType,
      {
      int unread = 0,
      String content = '',
      String time = '',
      OnItemClick onItemClick,
      OnItemLongClick onItemLongClick}) {
    return InkWell(
        onTap: () {
          if (null != onItemClick) {
            onItemClick(text);
          }
        },
        onLongPress: () {
          onItemLongClick(text);
        },
        child: Container(
            padding: EdgeInsets.only(left: 16.0, right: 16, top: 5, bottom: 0),
            child: Column(children: <Widget>[
              //1列n行
              Row(
                children: <Widget>[
                  //1行3列
                  Stack(
                      alignment: AlignmentDirectional.topEnd,
                      children: <Widget>[
                        Stack(
                            alignment: AlignmentDirectional.bottomStart,
                            children: <Widget>[
                              SizedBox(
                                width: 25,
                                height: 25,
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Icon(Icons.mobile_screen_share,
                                  size: 30.0)
                              ),
                            ]),
                        unread > 0
                            ? CircleAvatar(
                                backgroundColor: Colors.red,
                                radius: 7.0,
                                child: Text(
                                  unread.toString(),
                                  style: TextStyle(
                                      fontSize: unread > 99 ? 10.0 : 12.5,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            : Text(''),
                      ]),
                  SizedBox(
                    width: 8.0,
                  ),
                  Expanded(
                    //文本过长，打点
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          text,
                          maxLines: 1,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 20.0, color: Colors.black87),
                        ),
                        SizedBox(
                          height: 3.0,
                        ),
                        Text(
                          content,
                          maxLines: 1,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 16.0, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 15.0,
                  ),
                  Container(
                    height: 40,
                    alignment: Alignment.topRight,
                    child: Text(
                      time,
                      maxLines: 1,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 16.0, color: Colors.grey),
                    ),
                  )
                ],
              ),
              Container(
                padding: EdgeInsets.only(left: 10.0, top: 10),
                child: Divider(height: 1.5),
              )
            ])));
  }

  /*
  *  生成一个分割线
  */
  static Widget buildDivider({
    double height = 10,
    Color bgColor = Colors.green,
    double dividerHeight = 0.5,
    Color dividerColor = Colors.yellow,
  }) {
    BorderSide side = BorderSide(
        color: dividerColor, width: dividerHeight, style: BorderStyle.solid);
    return new Container(
        padding: EdgeInsets.all(height / 2),
        decoration: new BoxDecoration(
          color: bgColor,
          border: Border(top: side, bottom: side),
        ));
  }

  /*
  *  生成我的-ListView的item
  */
  static Widget defaultListViewItem(IconData iconData, String text,
      {double padding = 12.0,
      double imageSize = 20.0,
      bool isDivider = true,
      Color iconColor = Colors.black,
      Color textColor = Colors.black12,
      OnItemClick onItemClick}) {
    return InkWell(
        onTap: () {
          if (null != onItemClick) {
            onItemClick(null);
          }
        },
        onLongPress: () {},
        child: Container(
            padding:
                EdgeInsets.only(left: 20.0, right: 0, top: padding, bottom: 0),
            child: Column(children: <Widget>[
              Row(
                children: <Widget>[
                  iconData == null
                      ? SizedBox(
                          width: 0.0,
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(6.0),
                          child: Icon(
                            iconData,
                            size: imageSize,
                            color: iconColor,
                          ),
                        ),
                  SizedBox(
                    width: iconData == null ? 0 : 15.0,
                  ),
                  Expanded(
                    //文本过长，打点
                    flex: 1,
                    child: Text(
                      text,
                      maxLines: 1,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 17.0, color: textColor),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(right: 16),
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.grey,
                      size: 18,
                    ),
                  )
                ],
              ),
              isDivider
                  ? Container(
                      padding: EdgeInsets.only(
                          left: iconData == null ? 0 : 40.0, top: padding + 2),
                      child: Divider(
                        height: 1.5,
                      ),
                    )
                  : SizedBox(
                      height: 14,
                    )
            ])));
  }

  /*
  *  生成switch button-ListView的item
  */
  static Widget switchListViewItem(IconData iconData, String text,
      {double padding = 4.0,
      double imageSize = 16.0,
      bool isDivider = true,
      Color iconColor = Colors.black,
      Color textColor = Colors.black38,
      OnItemClick onItemClick,
      OnItemClick onSwitch,
      bool value = true}) {
    return InkWell(
        onTap: () {
          if (null != onItemClick) {
            onItemClick(null);
          }
        },
        onLongPress: () {},
        child: Container(
            padding:
                EdgeInsets.only(left: 20.0, right: 0, top: padding, bottom: 0),
            child: Column(children: <Widget>[
              Row(
                children: <Widget>[
                  iconData == null
                      ? SizedBox(
                          width: 0.0,
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(6.0),
                          child: Icon(
                            iconData,
                            size: imageSize,
                            color: iconColor,
                          ),
                        ),
                  SizedBox(
                    width: iconData == null ? 0 : 15.0,
                  ),
                  Expanded(
                    //文本过长，打点
                    flex: 1,
                    child: Text(
                      text,
                      maxLines: 1,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 17.0, color: textColor),
                    ),
                  ),
                  Switch(
                      value: value,
                      activeColor: Colors.red, //激活时原点的颜色。
                      activeTrackColor:
                          Colors.yellow, //激活时横条的颜色。
                      onChanged: (isCheck) {
                        if (null != onSwitch) {
                          onSwitch(isCheck);
                        }
                      })
                ],
              ),
              isDivider
                  ? Container(
                      padding: EdgeInsets.only(
                          left: iconData == null ? 0 : 40.0, top: padding + 2),
                      child: Divider(
                        height: 1.5,
                      ),
                    )
                  : SizedBox(
                      height: 14,
                    )
            ])));
  }

  /*
  *  生成系统消息列表-ListView的item
  */
  static Widget systemMessageListViewItem(
    String title,
    String content,
    String time, {
    bool showStatusBar = false,
    int status = 0, //0:显示拒绝和同意，1：显示已同意/已拒绝
    String statusText = '已同意',
    OnItemClick left,
    OnItemClick right,
    BuildContext context,
    String note = '',
  }) {
    return InkWell(
        onTap: () {},
        onLongPress: () {},
        child: Container(
            padding: EdgeInsets.only(left: 20.0, right: 20, top: 8, bottom: 0),
            child: Column(children: <Widget>[
              //1列n行
              Row(
                children: <Widget>[
                  Expanded(
                    //文本过长，打点
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          title,
                          maxLines: 1,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 16.0, color: Colors.black26),
                        ),
                        SizedBox(
                          height: 3.0,
                        ),
                        Text(
                          content,
                          maxLines: 1,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 14.0, color: Colors.black38),
                        ),
                        SizedBox(
                          height: ObjectUtil.isEmpty(note) ? 0 : 3.0,
                        ),
                        ObjectUtil.isEmpty(note)
                            ? SizedBox(
                                width: 0,
                                height: 0,
                              )
                            : InkWell(
                                onTap: () {
                                  DialogUtil.showBaseDialog(context, note,
                                      title: '', left: '', right: '');
                                },
                                child: Text(note,
                                    maxLines: 1,
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 13.0,
                                      fontStyle: FontStyle.italic,
                                      decoration: TextDecoration.underline,
                                      color: Colors.red,
                                    ))),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 15.0,
                  ),
                  Container(
                    height: 40,
                    alignment: Alignment.topRight,
                    child: Text(
                      time,
                      maxLines: 1,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 13.0, color: Colors.grey),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: showStatusBar ? 10.0 : 0,
              ),
              showStatusBar
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Expanded(flex: 8, child: Text('')),
                        Expanded(
                            flex: 4,
                            child: status != 0
                                ? SizedBox(
                                    width: 0,
                                  )
                                : InkWell(
                                    onTap: () {
                                      if (null != left) {
                                        left(0);
                                      }
                                    },
                                    child: Container(
                                      padding: EdgeInsets.fromLTRB(0, 4, 0, 4),
                                      decoration: new BoxDecoration(
                                          color:
                                              Colors.white12,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(4.0)),
                                          border: new Border.all(
                                              width: 0.5,
                                              color:
                                                  Colors.white12)),
                                      alignment: Alignment.center,
                                      child: Text(
                                        '拒绝',
                                        maxLines: 1,
                                        softWrap: true,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            letterSpacing: 3,
                                            fontSize: 16.0,
                                            color: Colors.red),
                                      ),
                                    ),
                                  )),
                        Expanded(flex: 1, child: Text('')),
                        Expanded(
                            flex: 4,
                            child: InkWell(
                              onTap: () {
                                if (null != left) {
                                  right(1);
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.fromLTRB(0, 4, 0, 4),
                                decoration: new BoxDecoration(
                                    color: Colors.white12,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4.0)),
                                    border: new Border.all(
                                        width: 0.5,
                                        color: Colors.grey)),
                                alignment: Alignment.center,
                                child: Text(
                                  status != 0 ? statusText : '同意',
                                  maxLines: 1,
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      letterSpacing: 3,
                                      fontSize: 16.0,
                                      color: Colors.green),
                                ),
                              ),
                            )),
                      ],
                    )
                  : SizedBox(
                      height: 0,
                    ),
              Container(
                padding: EdgeInsets.only(left: 0.0, top: 13),
                child: Divider(
                  height: 1.5,
                ),
              )
            ])));
  }

  static Widget buildNoDataPage() {
    return new Align(
      alignment: Alignment.center,
      child: InkWell(
        onTap: () {},
        child: Text('No Data',
            maxLines: 1,
            style: new TextStyle(
                fontSize: 17.0,
                color: Colors.black54,
                letterSpacing: 0.6,
                fontWeight: FontWeight.normal,
                fontStyle: FontStyle.normal,
                decoration: TextDecoration.none)),
      ),
    );
  }

  /*
  * 消息列表，item长按弹出popupWindow
  */
  static Future buildMessagePop(BuildContext context, List<String> texts,
      {OnItemClick onItemClick}) {
    return showMenu(
        context: context,
        position: RelativeRect.fromLTRB(130.0, 210.0, 130.0, 100.0),
        items: <PopupMenuItem<String>>[
          new PopupMenuItem<String>(
            value: 'one',
            child: Text(texts[0],
                style: new TextStyle(fontSize: 16.0, color: Colors.red)),
          ),
          new PopupMenuItem<String>(
            value: 'two',
            child: Text(texts[1],
                style: new TextStyle(fontSize: 16.0, color: Colors.red)),
          ),
          new PopupMenuItem<String>(
            value: 'three',
            child: Text(texts[2],
                maxLines: 1,
                style: new TextStyle(
                    fontSize: 16.0, color: Colors.yellow)),
          ),
        ]).then((res) {
      if (null != onItemClick) {
        onItemClick(res);
      }
    });
  }

  /*
  * 右上角item长按弹出popupWindow
  */
  static Future buildDefaultMessagePop(BuildContext context, List<String> texts,
      {OnItemClick onItemClick}) {
    return showMenu(
        context: context,
        position: RelativeRect.fromLTRB(double.infinity, 76, 0, 0),
        items: <PopupMenuItem<String>>[
          new PopupMenuItem<String>(
            value: 'one',
            child: Text(texts[0],
                style: new TextStyle(fontSize: 16.0, color: Colors.red)),
          ),
          new PopupMenuItem<String>(
            value: 'two',
            child: Text(texts[1],
                style: new TextStyle(fontSize: 16.0, color: Colors.yellow)),
          ),
          new PopupMenuItem<String>(
            value: 'three',
            child: Text(texts[2],
                maxLines: 1,
                style: new TextStyle(
                    fontSize: 16.0, color: Colors.green)),
          ),
        ]).then((res) {
      if (null != onItemClick) {
        onItemClick(res);
      }
    });
  }

  /*
  *  聊天页面-工具栏item
  */
  static Widget buildIcon(IconData icon, String text, {OnItemClick o}) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 8,
        ),
        InkWell(
            onTap: () {
              if (null != o) {
                o(null);
              }
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Container(
                width: 54,
                height: 54,
                color: Colors.red,
                child: Icon(icon, size: 28),
              ),
            )),
        SizedBox(
          height: 5,
        ),
        Text(
          text,
          style: TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}
