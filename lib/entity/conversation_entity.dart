import 'package:flutter/material.dart';

/*
* 消息列表类实体
*/
class ConversationEntity {
  static const String CON_ID = "id";
  static const String TARGET_UID = "targetUid";
  static const String LAST_MESSAGE = "last_message";
  static const String IS_UNREAD_COUNT = "is_unread_count";
  static const String LAST_MESSAGE_TIME = "last_message_time";
  static const String CONVERATION_TYPE = "conversation_type";
  

  String targetUid;
  String lastMessage;
  String name;
  int timestamp;
  String id;
  int isUnreadCount;
  int conversationType;

  ConversationEntity({
    @required this.targetUid,
    @required this.id,
    this.isUnreadCount = 0,
    this.name,
    @required this.timestamp,
    @required this.lastMessage,
    @required this.conversationType,
  });

  ConversationEntity.fromMap(Map<String, dynamic> map)
      : this(
          targetUid: map[TARGET_UID],
          isUnreadCount: map[IS_UNREAD_COUNT],
          id: map[CON_ID],
          timestamp: map[LAST_MESSAGE_TIME],
          lastMessage: map[LAST_MESSAGE],
          conversationType: map[CONVERATION_TYPE],
        );

  // Currently not used
  Map<String, dynamic> toMap() {
    return {
      CON_ID: id,
      TARGET_UID: targetUid,
      IS_UNREAD_COUNT: isUnreadCount,
      LAST_MESSAGE: lastMessage,
      LAST_MESSAGE_TIME: timestamp,
      CONVERATION_TYPE: conversationType
    };
  }
}
