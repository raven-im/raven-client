import 'package:flutter/material.dart';

class NotificationEntity {
  static const String TYPE = "type";
  static const String NOTIFICATION = "notification";
  static const String MEMBERS = "members";

  int type;
  String notification;
  List members;

  NotificationEntity({
    @required this.type,
    this.notification,
    this.members
  });

  NotificationEntity.fromMap(Map<String, dynamic> map)
      : this(
          type: map[TYPE],
          notification: map[NOTIFICATION],
          members: map[MEMBERS],
        );

  Map<String, dynamic> toMap() {
    return {
      TYPE: type,
      NOTIFICATION: notification,
      MEMBERS: members,
    };
  }
}
