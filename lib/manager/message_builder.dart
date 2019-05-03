import 'dart:typed_data';
import 'package:myapp/pb/message.pb.dart';
import 'package:fixnum/fixnum.dart';
import 'package:protobuf/protobuf.dart';

class MessageBuilder {

  static List<int> login(int id, String uid, String token){
    var message = new RavenMessage();
    message.type = RavenMessage_Type.Login;
    var data = Login();
    data.id = Int64(id);
    data.uid = uid;
    data.token = token;
    message.login = data;
    return _protoToDelimitedBuffer(message);
  }

  static List<int> getAllConversationList(int id) {
    var message = new RavenMessage();
    message.type = RavenMessage_Type.ConverReq;
    var data = ConverReq();
    data.id = Int64(id);
    data.type = OperationType.ALL;
    message.converReq = data;
    return _protoToDelimitedBuffer(message);
  }

  static List<int> getDetailConversationList(int id, String cid) {
    var message = new RavenMessage();
    message.type = RavenMessage_Type.ConverReq;
    var data = ConverReq();
    data.id = Int64(id);
    data.type = OperationType.DETAIL;
    data.conversationId = cid;
    message.converReq = data;
    return _protoToDelimitedBuffer(message);
  }

  static List<int> sendSingleMessage(int id, String fromId, String targetId, MessageType type, 
      String content, {String converId}) {
    var message = new RavenMessage();
    message.type = RavenMessage_Type.UpDownMessage;
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
    return _protoToDelimitedBuffer(message);
  }

  static List<int> sendGroupMessage(int id, String fromId, String targetId, MessageType type, 
      String content, String groupId, {String converId}) {
    var message = new RavenMessage();
    message.type = RavenMessage_Type.UpDownMessage;
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
    return _protoToDelimitedBuffer(message);
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
    var message = new RavenMessage();
    message.type = RavenMessage_Type.HeartBeat;
    var data = HeartBeat();
    data.id = id;
    data.heartBeatType = type;
    message.heartBeat = data;
    return _protoToDelimitedBuffer(message);
  }

  static List<int> getMessageList(int id, String convId, int beginTime) {
    var message = new RavenMessage();
    message.type = RavenMessage_Type.HisMessagesReq;
    var data = HisMessagesReq();
    data.id = Int64(id);
    data.converId = convId;
    data.beaginTime = Int64(beginTime);

    message.hisMessagesReq = data;
    return _protoToDelimitedBuffer(message);
  }

  // for protobuf,   length + bytes.  so add the length tag for bytes.
  static List<int> _protoToDelimitedBuffer(RavenMessage message) {
    var messageBuffer = new CodedBufferWriter();
    message.writeToCodedBufferWriter(messageBuffer);

    var delimiterBuffer = new CodedBufferWriter();
    delimiterBuffer.writeInt32NoTag(messageBuffer.lengthInBytes);

    var result = new Uint8List(
        messageBuffer.lengthInBytes + delimiterBuffer.lengthInBytes);

    delimiterBuffer.writeTo(result);
    messageBuffer.writeTo(result, delimiterBuffer.lengthInBytes);
    return result;
  }
}