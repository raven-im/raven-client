// import 'package:myapp/manager/sender_manager.dart';
import 'package:myapp/manager/wssender_manager.dart';

class MessageManager {
  static final MessageManager _conversaion = new MessageManager._internal();

  static MessageManager get() {
    return _conversaion;
  }

  MessageManager._internal();

  /*
  *  查询消息列表
  */
  void requestMessageEntities(String convId, int beginTime) async {
    SenderMngr.sendMessageEntityReq(convId, beginTime);
  }
}
