import 'dart:io';

import 'dart:typed_data';

class SocketMngr {
  static const String accessAddr = '10.12.9.139';
  static int port = 7010;
  Socket socket;

  // 工厂模式
  factory SocketMngr() =>_getInstance();
  static SocketMngr get instance => _getInstance();
  static SocketMngr _instance;
  SocketMngr._internal() {
    // 初始化
    _initSocket().then((sock) { 
      sock.listen((data) {
        print("接收到来自Server的数据：");
      });
    });
  }
  static SocketMngr _getInstance() {
    if (_instance == null) {
      _instance = new SocketMngr._internal();
    }
    return _instance;
  }

  Future<Socket> _initSocket() async {
    socket = await Socket.connect(accessAddr, port);
    return socket;
  }

  void write(Uint8List list) {
    socket?.add(list);
  }

  void release() {
    socket?.close();
  }
}