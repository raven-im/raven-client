import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:myapp/entity/message_entity.dart';
import 'package:myapp/utils/date_util.dart';
import 'package:myapp/utils/dialog_util.dart';
import 'package:myapp/utils/functions.dart';
import 'package:myapp/utils/object_util.dart';

/*
* 对话页面中的widget
*/
class ChatItemWidgets {
  static Widget buildChatListItem(
      MessageEntity nextEntity, MessageEntity entity,
      {OnItemClick onResend, OnItemClick onItemClick}) {
    bool _isShowTime = true;
    var showTime; //最终显示的时间
    if (null == nextEntity) {
      _isShowTime = true;
    } else {
      //如果当前消息的时间和上条消息的时间相差，大于3分钟，则要显示当前消息的时间，否则不显示
      if ((int.parse(entity.time) - int.parse(nextEntity.time)).abs() >
          3 * 60 * 1000) {
        _isShowTime = true;
      } else {
        _isShowTime = false;
      }
    }
    //获取当前的时间,yyyy-MM-dd HH:mm
    String nowTime = DateUtil.getDateStrByMs(
        new DateTime.now().millisecondsSinceEpoch,
        format: DateFormat.YEAR_MONTH_DAY_HOUR_MINUTE);
    //当前消息的时间,yyyy-MM-dd HH:mm
    String indexTime = DateUtil.getDateStrByMs(int.parse(entity.time),
        format: DateFormat.YEAR_MONTH_DAY_HOUR_MINUTE);

    if (DateUtil.formatDateTime1(indexTime, DateFormat.YEAR) !=
        DateUtil.formatDateTime1(nowTime, DateFormat.YEAR)) {
      //对比年份,不同年份，直接显示yyyy-MM-dd HH:mm
      showTime = indexTime;
    } else if (DateUtil.formatDateTime1(indexTime, DateFormat.YEAR_MONTH) !=
        DateUtil.formatDateTime1(nowTime, DateFormat.YEAR_MONTH)) {
      //年份相同，对比年月,不同月或不同日，直接显示MM-dd HH:mm
      showTime =
          DateUtil.formatDateTime1(indexTime, DateFormat.MONTH_DAY_HOUR_MINUTE);
    } else if (DateUtil.formatDateTime1(indexTime, DateFormat.YEAR_MONTH_DAY) !=
        DateUtil.formatDateTime1(nowTime, DateFormat.YEAR_MONTH_DAY)) {
      //年份相同，对比年月,不同月或不同日，直接显示MM-dd HH:mm
      showTime =
          DateUtil.formatDateTime1(indexTime, DateFormat.MONTH_DAY_HOUR_MINUTE);
    } else {
      //否则HH:mm
      showTime = DateUtil.formatDateTime1(indexTime, DateFormat.HOUR_MINUTE);
    }

    return Container(
      child: Column(
        children: <Widget>[
          _isShowTime
              ? Center(
                  heightFactor: 2,
                  child: Text(
                    showTime,
                    style: TextStyle(color: Colors.transparent),
                  ))
              : SizedBox(height: 0),
          _chatItemWidget(entity, onResend, onItemClick)
        ],
      ),
    );
  }

  static Widget _chatItemWidget(
      MessageEntity entity, OnItemClick onResend, OnItemClick onItemClick) {
    if (entity.messageOwner == 1) {
      //对方的消息
      return Container(
        margin: EdgeInsets.only(left: 10, right: 90, bottom: 30, top: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _headPortrait(entity.imageUrl, 1),
            SizedBox(width: 10),
            new Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  entity.senderAccount,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(height: 5),
                GestureDetector(
                  child: _contentWidget(entity),
                  onTap: () {
                    if (null != onItemClick) {
                      onItemClick(entity);
                    }
                  },
                  onLongPress: () {
                    DialogUtil.buildToast('长按了消息');
                  },
                ),
              ],
            )),
          ],
        ),
      );
    } else {
      //自己的消息
      return Container(
        margin: EdgeInsets.only(left: 90, right: 10, bottom: 30, top: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text(
                  '我',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                SizedBox(height: 5),
                GestureDetector(
                  child: _contentWidget(entity),
                  onTap: () {
                    if (null != onItemClick) {
                      onItemClick(entity);
                    }
                  },
                  onLongPress: () {
                    DialogUtil.buildToast('长按了消息');
                  },
                ),
                //显示是否重发1、发送2中按钮，发送成功0或者null不显示
                entity.status == '1'
                    ? IconButton(
                        icon: Icon(Icons.refresh, color: Colors.red, size: 18),
                        onPressed: () {
                          if (null != onResend) {
                            onResend(entity);
                          }
                        })
                    : (entity.status == '2'
                        ? Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.only(top: 20, right: 20),
                            width: 32.0,
                            height: 32.0,
                            child: SizedBox(
                                width: 12.0,
                                height: 12.0,
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation(
                                      Colors.green),
                                  strokeWidth: 2,
                                )),
                          )
                        : SizedBox(
                            width: 0,
                            height: 0,
                          )),
              ],
            )),
            SizedBox(width: 10),
            _headPortrait(entity.imageUrl, 0),
          ],
        ),
      );
    }
  }

  /*
  *  头像
  */
  static Widget _headPortrait(String url, int owner) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(6.0),
        child: url.isEmpty
            ? owner == 1
              ? new Icon(Icons.face)
              : new Icon(Icons.alarm_on)
            : (ObjectUtil.isNetUri(url)
                ? Image.network(
                    url,
                    width: 44,
                    height: 44,
                    fit: BoxFit.fill,
                  )
                : Image.asset(url, width: 44, height: 44)));
  }

  /*
  *  内容
  */
  static Widget _contentWidget(MessageEntity entity) {
    Widget widget;
    if (entity.contentType == "chat") {
      //文本
      widget = buildTextWidget(entity);
    } else {
      widget = ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Container(
          padding: EdgeInsets.all(10),
          color: Colors.grey,
          child: Text(
            '未知消息类型',
            style: TextStyle(fontSize: 16, color: Colors.black),
          ),
        ),
      );
    }
    return widget;
  }

  static Widget buildTextWidget(MessageEntity entity) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: Container(
        padding: EdgeInsets.only(left: 10, right: 10, top: 6, bottom: 6),
        color: entity.messageOwner == 1
            ? Colors.white
            : Color.fromARGB(255, 158, 234, 106),
        child: Text(
          entity.content,
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
      ),
    );
  }
}
