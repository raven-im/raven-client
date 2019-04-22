
import 'package:myapp/manager/socket_manager.dart';
import 'package:myapp/manager/message_builder.dart';
import 'package:myapp/utils/constants.dart';
import 'package:myapp/utils/sp_util.dart';

class SenderMngr {

  // static void sendConvListReq(int id, String cid) {
  //   List<int> list = MessageBuilder.getConversationList(id, cid);
  //   SocketMngr.instance.write(list);
  // }
  
  static void loginReq(int id, callback(Object data)) {
    String uid = SPUtil.getString(Constants.KEY_LOGIN_UID);
    String token = SPUtil.getString(Constants.KEY_LOGIN_TOKEN);
    List<int> list = MessageBuilder.login(id, uid, token);
    SocketMngr.getSocket().then((socket) {
      socket.add(list);
      socket.listen((data) {
        callback(data);
      });
    });
  }
}