
import 'package:myapp/message/socket_manager.dart';
import 'package:myapp/message/message_builder.dart';

class SenderMngr {

  static void sendConvListReq(int id, String cid) {
    List<int> list = MessageBuilder.getConversationList(id, cid);
    SocketMngr.instance.write(list);
  }
  
}