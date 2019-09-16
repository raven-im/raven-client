/*
* 消息类实体
*/
import 'package:flutter/material.dart';

class MessageEntity {
  static const String DB_ID = "db_id";
  static const String MSG_ID = "id";
  static const String CONVERSATION_TYPE = "conversation_type"; //消息类型，不可以为空
  static const String IS_UNREAD = "is_unread"; //0未读,1已读
  static const String FROM_UID = "from_uid"; //不发送方，可以为空
  static const String TARGET_UID = "target_uid"; //不发送方，可以为空
  static const String CONTENT = "content"; //内容，不可以为空
  static const String CONTENT_TYPE = "content_type"; //内容类型，可以为空
  static const String CONVERSATION_ID = "conversation_id"; //会话id
  static const String TIME = "time"; //消息发送时间，不可以为空
  static const String MESSAGE_OWNER = "message_owner"; //消息发送方，0自己,1对方
  static const String STATUS = "status"; //状态
  static const String TYPE = "type"; //消息类型，0为普通消息，1为通知消息

  String fromUid, targetUid, convId, content, senderName, time;
  int convType, status, msgId, contentType;
  int isUnread, messageOwner, isUnreadCount, type;

  MessageEntity({
    this.msgId,
    @required this.convType,
    @required this.fromUid,
    @required this.targetUid,
    @required this.contentType,
    @required this.content,
    @required this.time,
    this.status = 0,
    this.convId,
    this.isUnread = 0,
    this.messageOwner = 1,
    this.senderName,
    this.isUnreadCount = 0,
    this.type = 0,
  });

  MessageEntity.fromMap(Map<String, dynamic> map)
      : this(
          msgId: int.parse(map[MSG_ID]),
          convId: map[CONVERSATION_ID],
          convType: map[CONVERSATION_TYPE],
          fromUid: map[FROM_UID],
          targetUid: map[TARGET_UID],
          content: map[CONTENT],
          contentType: int.parse(map[CONTENT_TYPE]),
          time: map[TIME],
          isUnread: map[IS_UNREAD],
          messageOwner: map[MESSAGE_OWNER],
          status: map[STATUS],
          type: map[TYPE],
        );

  // Currently not used
  Map<String, dynamic> toMap() {
    return {
      MSG_ID: msgId,
      CONVERSATION_ID: convId,
      CONVERSATION_TYPE: convType,
      FROM_UID: fromUid,
      TARGET_UID: targetUid,
      CONTENT: content,
      CONTENT_TYPE: contentType,
      TIME: time,
      IS_UNREAD: isUnread,
      MESSAGE_OWNER: messageOwner,
      STATUS: status,
      TYPE: type,
    };
  }
}
