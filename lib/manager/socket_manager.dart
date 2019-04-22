import 'dart:io';

import 'package:myapp/utils/constants.dart';
import 'package:myapp/utils/sp_util.dart';

class SocketMngr {
  static Socket socket;

  static Future<Socket> getSocket() async {
    if (socket == null) {
      return _initSocket();
    }
    return socket;
  }

  static Future<Socket> _initSocket() async {
    String ip = SPUtil.getString(Constants.KEY_ACCESS_NODE_IP);
    int port = SPUtil.getInt(Constants.KEY_ACCESS_NODE_PORT);
    print("socket connect to $ip:$port");
    socket = await Socket.connect(ip, port);
    return socket;
  }

  static void release() {
    socket?.close();
  }
}