import 'package:flutter/material.dart';
import 'package:myapp/entity/message_entity.dart';
import 'package:myapp/utils/interact_vative.dart';

abstract class BaseState<T extends StatefulWidget> extends State<T> {
  @override
  void initState() {
    super.initState();
    _addListener();
  }

  _addListener() {
    InteractNative.initMessageEvent();
    InteractNative.getMessageEventStream().listen((value) {
      updateData(value);
    });
  }

  @protected
  void updateData(MessageEntity entity);
}
