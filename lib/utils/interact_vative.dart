import 'dart:async';
import 'package:myapp/entity/message_entity.dart';
import 'package:rxdart/rxdart.dart';

class InteractNative {

  static BehaviorSubject<MessageEntity> _messageEvent =
      BehaviorSubject<MessageEntity>();

  static const int RESET_THEME_COLOR = 1;
  static const int CHANGE_PAGE_TO_MAIN = 2;
  static const int CHANGE_PAGE_TO_LOGIN = 3;
  

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
  *  退出登录时，需要关闭
  */
  static void closeMessageStream() {
    if (null != _messageEvent) {
      _messageEvent.close();
    }
  }
}
