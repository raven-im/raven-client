import 'dart:async';
import 'package:rxdart/rxdart.dart';

class InteractNative {
  static BehaviorSubject<Object> _appEvent = BehaviorSubject<Object>();

  static const int PULL_MESSAGE = 1;
  static const int PULL_CONVERSATION = 2;
  static const int CHANGE_PAGE_TO_MAIN = 3;
  static const int CHANGE_PAGE_TO_LOGIN = 4;
  static const int PULL_GROUP_INFO = 5;
  static const int GROUP_KICKED = 6;

  /*
  * 自定义通信
  */
  static BehaviorSubject<Object> initAppEvent() {
    if (null == _appEvent || _appEvent.isClosed) {
      _appEvent = BehaviorSubject<Object>();
    }
    return _appEvent;
  }

  /*发送*/
  static Sink<Object> getAppEventSink() {
    initAppEvent();
    return _appEvent.sink;
  }

  /*接收*/
  static Stream<Object> getAppEventStream() {
    initAppEvent();
    return _appEvent.stream;
  }

  /*
  *  退出登录时，需要关闭
  */
  static void closeStream() {
    if (null != _appEvent) {
      _appEvent.close();
    }
  }
}
