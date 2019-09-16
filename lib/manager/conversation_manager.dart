// import 'package:myapp/manager/sender_manager.dart';
import 'package:myapp/manager/wssender_manager.dart';

class ConversationManager {
  static final ConversationManager _conversaion =
      new ConversationManager._internal();

  static ConversationManager get() {
    return _conversaion;
  }

  ConversationManager._internal();
  /*
  *  查询会话列表
  */
  void requestConverEntities() async {
    SenderMngr.sendAllConvListReq();
  }

  void requestConverEntity(String convId) async {
    SenderMngr.sendDetailConvListReq(convId);
  }
}
