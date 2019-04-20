import 'package:flutter/material.dart';

/*
* 联系人类实体
*/
class ContactEntity {
  static const String USER_ID = "id";
  static const String USER_NAME = "user_name";
  static const String PORTRAIT = "portrait";
  static const String STATUS = "status";

  String userId;
  String userName;
  String portrait;
  int status;

  ContactEntity({
    @required this.userId,
    this.userName,
    this.portrait,
    this.status = 0,
  });

  ContactEntity.fromMap(Map<String, dynamic> map)
      : this(
          userId: map[USER_ID],
          userName: map[USER_NAME],
          portrait: map[PORTRAIT],
          status: map[STATUS],
        );

  // Currently not used
  Map<String, dynamic> toMap() {
    return {
      USER_ID: userId,
      USER_NAME: userName,
      PORTRAIT: portrait,
      STATUS: status,
    };
  }
}
