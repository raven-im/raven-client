import 'package:flutter/material.dart';

class ImgTokenEntity {
  static const String CONTENT_TOKEN = "token";
  static const String CONTENT_URL = "url";

  String token;
  String url;

  ImgTokenEntity({
    @required this.token,
    @required this.url,
  });

  ImgTokenEntity.fromMap(Map<String, dynamic> map)
      : this(
          token: map[CONTENT_TOKEN],
          url: map[CONTENT_URL],
        );


  Map<String, dynamic> toMap() {
    return {
      CONTENT_TOKEN: token,
      CONTENT_URL: url,
    };
  }
}
