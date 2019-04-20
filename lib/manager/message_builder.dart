import 'dart:typed_data';
import 'package:myapp/pb/message.pb.dart';
import 'package:fixnum/fixnum.dart';

class MessageBuilder {


  // // 工厂模式
  // factory ProtocBufMngr() =>_getInstance();
  // static ProtocBufMngr get instance => _getInstance();
  // static ProtocBufMngr _instance;
  // ProtocBufMngr._internal() {
  //   // 初始化
 
  // }
  // static ProtocBufMngr _getInstance() {
  //   if (_instance == null) {
  //     _instance = new ProtocBufMngr._internal();
  //   }
  //   return _instance;
  // }

  static Uint8List login(int id, String uid, String token){
    var message = new TimMessage();
    message.type = TimMessage_Type.Login;
    var data = Login();
    data.id = Int64(id);
    data.uid = uid;
    data.token = token;
    message.login = data;
    // File file = File(arguments.first);
    return message.writeToBuffer();
  }

  static List<int> getConversationList(int id, String cid){
    var message = new TimMessage();
    message.type = TimMessage_Type.ConverReq;
    var data = ConverReq();
    data.id = Int64(id);
    data.type = OperationType.ALL;
    data.conversationId = cid;
    message.converReq = data;
    // File file = File(arguments.first);
    return message.writeToBuffer();
  }
}