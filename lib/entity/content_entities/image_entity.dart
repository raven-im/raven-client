import 'package:flutter/material.dart';

class ImgEntity {
  static const String CONTENT_NAME = "name";
  static const String CONTENT_SIZE = "size";
  static const String CONTENT_URL = "url";

  String name;
  int size;
  String url;

  ImgEntity({
    this.name,
    this.size,
    @required this.url,
  });

  ImgEntity.fromMap(Map<String, dynamic> map)
      : this(
          name: map[CONTENT_NAME],
          size: map[CONTENT_SIZE],
          url: map[CONTENT_URL],
        );


  Map<String, dynamic> toMap() {
    return {
      CONTENT_NAME: name,
      CONTENT_SIZE: size,
      CONTENT_URL: url,
    };
  }
}
