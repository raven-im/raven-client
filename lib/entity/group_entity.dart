/*
* 群组实体
*/
import 'package:flutter/material.dart';

class GroupEntity {
  static const String DB_ID = "db_id";
  static const String GROUP_ID = "id";
  static const String CONVERSATION_ID = "conversation_id";
  static const String NAME = "name";
  static const String PORTRAIT = "portrait";
  static const String TIME = "time";
  static const String GROUP_OWNER = "owner";
  static const String STATUS = "status"; //状态:存活，消除
  static const String MEMBERS = "members";

  String groupId, groupOwner, conversationId, name, portrait, time;
  int status;
  List members;

  GroupEntity({
    @required this.groupId,
    this.groupOwner,
    @required this.conversationId,
    this.name,
    this.portrait,
    this.time,
    this.status = 0,
    this.members,
  });

  GroupEntity.fromMap(Map<String, dynamic> map)
      : this(
          groupId: map[GROUP_ID],
          conversationId: map[CONVERSATION_ID],
          name: map[NAME],
          portrait: map[PORTRAIT],
          time: map[TIME],
          groupOwner: map[GROUP_OWNER],
          status: map[STATUS],
          members: map[MEMBERS],
        );

  // Currently not used
  Map<String, dynamic> toMap() {
    return {
      GROUP_ID: groupId,
      CONVERSATION_ID: conversationId,
      NAME: name,
      PORTRAIT: portrait,
      TIME: time,
      GROUP_OWNER: groupOwner,
      STATUS: status,
      MEMBERS: members
    };
  }
}
