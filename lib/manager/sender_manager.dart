
import 'package:myapp/manager/socket_manager.dart';
import 'package:myapp/manager/message_builder.dart';
import 'package:myapp/pb/message.pb.dart';
import 'package:myapp/utils/constants.dart';
import 'package:myapp/utils/sp_util.dart';

class SenderMngr {

  static bool isLogined = false;
  // client id match to server.
  static int _msgId = 1;
  // client message list.
  static Map<int, List<int>> _msgMap = new Map<int, List<int>>();

  // static void sendConvListReq(int id, String cid) {
  //   List<int> list = MessageBuilder.getConversationList(id, cid);
  //   SocketMngr.instance.write(list);
  // }
  
  static init(callback(Object data)) {
    SocketMngr.getSocket().then((socket) {
      _loginReq();
      socket.listen((data) {
        TimMessage message = TimMessage.fromBuffer(data);
        switch (message.type) {
          case TimMessage_Type.LoginAck:
            if (_msgMap.containsKey(message.loginAck.id)) {
              _msgMap.remove(message.loginAck.id);
            } else {
              print("error: $message.loginAck.id contains? $_msgMap.containsKey(message.loginAck.id)");
            } 
            if (message.loginAck.code == Code.SUCCESS) {
              isLogined = true;
              callback(data); 
            } else {
              print("error: login ack: $message.loginAck.code ");
            }
            break;
          case TimMessage_Type.MessageAck:
            break;
        }
      });
    });
  }

  static void sendMsg(List<int> msg) {
    if (isLogined) {
      SocketMngr.write(msg);
      _msgMap.putIfAbsent(_msgId, () => msg);
      _msgId++;
    } else {
      print(" not login , can't send message.");
    }
  }

  static void _loginReq() {
    if (!isLogined) {
      String uid = SPUtil.getString(Constants.KEY_LOGIN_UID);
      String token = SPUtil.getString(Constants.KEY_LOGIN_TOKEN);
      List<int> list = MessageBuilder.login(_msgId, uid, token);

      SocketMngr.write(list);
      _msgMap.putIfAbsent(_msgId, () => list);
      _msgId++;
    } else {
      print("already logined.");
    }
  }
}