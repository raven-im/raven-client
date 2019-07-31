/*
* 群组实体
*/
import 'package:flutter/material.dart';

class GroupMemberEntity {
  static const String DB_ID = "db_id";
  static const String GROUP_ID = "id";
  static const String MEMBER_UID = "member_id";
  static const String CONVERSATION_ID = "conversation_id";

  String
      groupId,
      conversationId,
      member
      ;

  GroupMemberEntity(
      {
      @required this.groupId,
      @required this.conversationId,
      @required this.member
      });

  GroupMemberEntity.fromMap(Map<String, dynamic> map)
      : this(
          groupId: map[GROUP_ID],
          conversationId: map[CONVERSATION_ID],
          member: map[MEMBER_UID]
        );

  // Currently not used
  Map<String, dynamic> toMap() {
    return {
      GROUP_ID: groupId,
      CONVERSATION_ID: conversationId,
      MEMBER_UID: member
    };
  }
}

