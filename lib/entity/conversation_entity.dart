import 'package:flutter/material.dart';

/*
* 消息列表类实体
*/
class ConversationEntity {
  static const String CON_ID = "id";
  static const String SENDER_ACCOUNT = "sender_account";
  static const String LAST_MESSAGE = "last_message";
  static const String IS_UNREAD_COUNT = "is_unread_count";
  static const String LAST_MESSAGE_TIME = "last_message_time";
  static const String CONVERATION_TYPE = "conversation_type";

  String senderAccount;
  String lastMessage;
  int timestamp;
  int id;
  int isUnreadCount;
  int conversationType;

  ConversationEntity({
    @required this.senderAccount,
    @required this.id,
    this.isUnreadCount = 0,
    this.timestamp = 0,
    @required this.lastMessage,
    @required this.conversationType,
  });

  ConversationEntity.fromMap(Map<String, dynamic> map)
      : this(
          senderAccount: map[SENDER_ACCOUNT],
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
      SENDER_ACCOUNT: senderAccount,
      IS_UNREAD_COUNT: isUnreadCount,
      LAST_MESSAGE: lastMessage,
      LAST_MESSAGE_TIME: timestamp,
      CONVERATION_TYPE: conversationType
    };
  }
}
