import 'dart:async';
import 'package:flutter/material.dart';
import 'package:myapp/utils/interact_vative.dart';

abstract class BaseState<T extends StatefulWidget> extends State<T> {
  StreamSubscription subscription;
  @override
  void initState() {
    super.initState();
    _addListener();
  }

  _addListener() {
    InteractNative.initAppEvent();
    subscription = InteractNative.getAppEventStream().listen((value) {
      notify(value);
    });
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  @protected
  void notify(Object o);
}
