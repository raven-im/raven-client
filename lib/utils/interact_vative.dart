import 'dart:async';
import 'package:myapp/entity/message_entity.dart';
import 'package:rxdart/rxdart.dart';

class InteractNative {

  static BehaviorSubject<Object> _appEvent = BehaviorSubject<Object>();

  static BehaviorSubject<MessageEntity> _messageEvent =
      BehaviorSubject<MessageEntity>();

  static const int PULL_MESSAGE = 1;
  static const int PULL_CONVERSATION = 2;
  static const int CHANGE_PAGE_TO_MAIN = 3;
  static const int CHANGE_PAGE_TO_LOGIN = 4;
  
  /*
  * 自定义通信
  */
  static BehaviorSubject<MessageEntity> initMessageEvent() {
    if (null == _messageEvent || _messageEvent.isClosed) {
      _messageEvent = BehaviorSubject<MessageEntity>();
    }
    return _messageEvent;
  }

  /*发送*/
  static Sink<MessageEntity> getMessageEventSink() {
    initMessageEvent();
    return _messageEvent.sink;
  }

  /*接收*/
  static Stream<MessageEntity> getMessageEventStream() {
    initMessageEvent();
    return _messageEvent.stream;
  }

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
    if (null != _messageEvent) {
      _messageEvent.close();
    }
    if (null != _appEvent) {
      _appEvent.close();
    }
  }
}
