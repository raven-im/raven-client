/*
* 消息类实体
*/
import 'package:flutter/material.dart';

class MessageEntity {
  static const String MSG_ID = "id";
  static const String CONVERSATION_TYPE = "conversation_type"; //消息类型，不可以为空
  static const String IS_UNREAD = "is_unread"; //0未读,1已读
  static const String FROM_UID = "from_uid"; //不发送方，可以为空
  static const String TARGET_UID = "target_uid"; //不发送方，可以为空
  static const String TITLE_NAME = "title_name"; //标题或者名字，不可以为空
  static const String CONTENT = "content"; //内容，不可以为空
  static const String CONTENT_TYPE = "content_type"; //内容类型，可以为空
  static const String CONVERSATION_ID = "conversation_id"; //会话id
  static const String TIME = "time"; //消息发送时间，不可以为空
  static const String MESSAGE_OWNER = "message_owner"; //消息发送方，0自己,1对方
  static const String STATUS = "status"; //状态

  String 
      msgId,
      fromUid,
      targetUid,
      convId,
      titleName,
      content,
      contentType,
      time;
  int convType, status;
  int isUnread, messageOwner, isUnreadCount;

  MessageEntity(
      {
      this.msgId,
      @required this.convType,
      @required this.fromUid,
      @required this.targetUid,
      @required this.convId,
      @required this.titleName,
      @required this.content,
      @required this.time,
      this.status = 0,
      this.contentType,
      this.isUnread = 0,
      this.messageOwner = 1,
      this.isUnreadCount = 0
      });

  MessageEntity.fromMap(Map<String, dynamic> map)
      : this(
          msgId: map[MSG_ID],
          convId: map[CONVERSATION_ID],
          convType: map[CONVERSATION_TYPE],
          fromUid: map[FROM_UID],
          targetUid: map[TARGET_UID],
          titleName: map[TITLE_NAME],
          content: map[CONTENT],
          contentType: map[CONTENT_TYPE],
          time: map[TIME],
          isUnread: map[IS_UNREAD],
          messageOwner: map[MESSAGE_OWNER],
          status: map[STATUS],
        );

  // Currently not used
  Map<String, dynamic> toMap() {
    return {
      MSG_ID: msgId,
      CONVERSATION_ID: convId,
      CONVERSATION_TYPE: convType,
      FROM_UID: fromUid,
      TARGET_UID: targetUid,
      TITLE_NAME: titleName,
      CONTENT: content,
      CONTENT_TYPE: contentType,
      TIME: time,
      IS_UNREAD: isUnread,
      MESSAGE_OWNER: messageOwner,
      STATUS: status,
    };
  }
}

