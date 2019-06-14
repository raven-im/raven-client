import 'package:flutter/material.dart';

class TextEntity {
  static const String CONTENT = "content";

  String content;

  TextEntity({
    @required this.content,
  });

  TextEntity.fromMap(Map<String, dynamic> map)
      : this(
          content: map[CONTENT],
        );

  Map<String, dynamic> toMap() {
    return {
      CONTENT: content,
    };
  }
}
