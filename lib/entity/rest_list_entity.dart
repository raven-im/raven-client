import 'package:flutter/material.dart';

class RestListEntity {
  static const String RSP_CODE = "code";
  static const String RSP_MSG = "msg";
  static const String RSP_BODY = "data";

  int code;
  String message;
  List data;

  RestListEntity({
    @required this.code,
    this.message,
    this.data,
  });

  RestListEntity.fromMap(Map<String, dynamic> map)
      : this(
          code: map[RSP_CODE],
          message: map[RSP_MSG],
          data: map[RSP_BODY],
        );

  // Currently not used
  Map<String, dynamic> toMap() {
    return {
      RSP_CODE: code,
      RSP_MSG: message,
      RSP_BODY: data,
    };
  }
}
