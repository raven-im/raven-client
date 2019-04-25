import 'package:myapp/manager/sender_manager.dart';

class MessageManager {
  static final MessageManager _conversaion = new MessageManager._internal();

  static MessageManager get() {
    return _conversaion;
  }

  MessageManager._internal();

  /*
  *  查询消息列表
  */
  void requestMessageEntities(String convId) async {
    SenderMngr.sendMessageEntityReq(convId);
  }
}
