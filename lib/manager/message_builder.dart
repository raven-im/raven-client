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
    return message.writeToBuffer();
  }

  static List<int> getAllConversationList(int id) {
    var message = new TimMessage();
    message.type = TimMessage_Type.ConverReq;
    var data = ConverReq();
    data.id = Int64(id);
    data.type = OperationType.ALL;
    message.converReq = data;
    return message.writeToBuffer();
  }

  static List<int> getDetailConversationList(int id, String cid) {
    var message = new TimMessage();
    message.type = TimMessage_Type.ConverReq;
    var data = ConverReq();
    data.id = Int64(id);
    data.type = OperationType.DETAIL;
    data.conversationId = cid;
    message.converReq = data;
    return message.writeToBuffer();
  }

  static List<int> sendSingleMessage(int id, String fromId, String targetId, MessageType type, 
      String content, {String converId}) {
    var message = new TimMessage();
    message.type = TimMessage_Type.UpDownMessage;
    var data = UpDownMessage();
    // data.id = Int64(id);  server set
    data.cid = Int64(id);
    data.fromUid = fromId;
    data.targetUid = targetId;
    data.converType = ConverType.SINGLE;
    if (converId != null) {
      data.converId = converId;
    }
    data.content = _getMessageContent(fromId, type, content);
    message.upDownMessage = data;
    return message.writeToBuffer();
  }

  static List<int> sendGroupMessage(int id, String fromId, String targetId, MessageType type, 
      String content, String groupId, {String converId}) {
    var message = new TimMessage();
    message.type = TimMessage_Type.UpDownMessage;
    var data = UpDownMessage();
    // data.id = Int64(id);  server set
    data.cid = Int64(id);
    data.fromUid = fromId;
    data.targetUid = targetId;
    data.converType = ConverType.GROUP;
    if (converId != null) {
      data.converId = converId;
    }
    data.groupId = groupId;
    data.content = _getMessageContent(fromId, type, content);
    message.upDownMessage = data;
    return message.writeToBuffer();
  }

  static MessageContent _getMessageContent(String fromId, MessageType type, String content) {
    var msgContent = MessageContent();
    // msgContent.id = Int64(1);   Server set.
    msgContent.uid = fromId;
    msgContent.type = type;
    msgContent.content = content;
    msgContent.time = Int64(DateTime.now().millisecondsSinceEpoch);
    return msgContent;
  }

  static List<int> sendHeartBeat(Int64 id, HeartBeatType type) {
    var message = new TimMessage();
    message.type = TimMessage_Type.HeartBeat;
    var data = HeartBeat();
    data.id = id;
    data.heartBeatType = type;
    message.heartBeat = data;
    return message.writeToBuffer();
  }

  static List<int> getMessageList(int id, String convId, int beginTime) {
    var message = new TimMessage();
    message.type = TimMessage_Type.HisMessagesReq;
    var data = HisMessagesReq();
    // data.id = Int64(id);  server set
    data.converId = convId;
    data.beaginTime = Int64(beginTime);

    message.hisMessagesReq = data;
    return message.writeToBuffer();
  }
}