
import 'package:myapp/manager/socket_manager.dart';
import 'package:myapp/manager/message_builder.dart';

class SenderMngr {

  static void sendConvListReq(int id, String cid) {
    List<int> list = MessageBuilder.getConversationList(id, cid);
    SocketMngr.instance.write(list);
  }
  
}