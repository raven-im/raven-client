import 'dart:typed_data';
import 'package:myapp/entity/message_entity.dart';
import 'package:myapp/pb/message.pb.dart';
import 'package:fixnum/fixnum.dart';
import 'package:myapp/utils/constants.dart';
import 'package:protobuf/protobuf.dart';

class MessageBuilder {

  static List<int> login(Int64 id, String uid, String token){
    var message = RavenMessage();
    message.type = RavenMessage_Type.Login;
    var data = Login();
    data.id = id;
    data.uid = uid;
    data.token = token;
    message.login = data;
    return _protoToDelimitedBuffer(message);
  }

  static List<int> getAllConversationList(Int64 id) {
    var message = RavenMessage();
    message.type = RavenMessage_Type.ConverReq;
    var data = ConverReq();
    data.id = id;
    data.type = OperationType.ALL;
    message.converReq = data;
    return _protoToDelimitedBuffer(message);
  }

  static List<int> getDetailConversationList(Int64 id, String cid) {
    var message = new RavenMessage();
    message.type = RavenMessage_Type.ConverReq;
    var data = ConverReq();
    data.id = id;
    data.type = OperationType.DETAIL;
    data.conversationId = cid;
    message.converReq = data;
    return _protoToDelimitedBuffer(message);
  }

  static List<int> sendSingleMessage(Int64 id, MessageEntity entity) {
    var message = new RavenMessage();
    message.type = RavenMessage_Type.UpDownMessage;
    var data = UpDownMessage();
    // data.id = Int64(id);  server set
    data.cid = id;
    data.fromUid = entity.fromUid;
    data.targetUid = entity.targetUid;
    data.converType = ConverType.SINGLE;
    if (entity.convId != null) {
      data.converId = entity.convId;
    }
    data.content = _getMessageContent(entity);
    message.upDownMessage = data;
    return _protoToDelimitedBuffer(message);
  }

  static List<int> sendGroupMessage(Int64 id, MessageEntity entity) {
    var message = new RavenMessage();
    message.type = RavenMessage_Type.UpDownMessage;
    var data = UpDownMessage();
    // data.id = Int64(id);  server set
    data.cid = id;
    data.fromUid = entity.fromUid;
    data.converType = ConverType.GROUP;
    data.groupId = entity.targetUid;
    data.converId = entity.convId;
    data.content = _getMessageContent(entity);
    message.upDownMessage = data;
    return _protoToDelimitedBuffer(message);
  }

  static MessageContent _getMessageContent(MessageEntity entity) {
    var msgContent = MessageContent();
    // msgContent.id = Int64(1);   Server set.
    MessageType type;
    switch (entity.contentType) {
      case Constants.CONTENT_TYPE_TEXT:
        type = MessageType.TEXT;
        break;
      case Constants.CONTENT_TYPE_IMAGE:
        type = MessageType.PICTURE;
        break;
      case Constants.CONTENT_TYPE_VOICE:
        type = MessageType.VOICE;
        break;
      case Constants.CONTENT_TYPE_VIDEO:
        type = MessageType.VIDEO;
        break;
      default:
        type = MessageType.TEXT;
    }
    msgContent.uid = entity.fromUid;
    msgContent.type = type;
    msgContent.content = entity.content;
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

  static List<int> sendMessageAck(UpDownMessage recvMsg) {
    var message = new RavenMessage();
    message.type = RavenMessage_Type.MessageAck;
    var data = MessageAck();
    data.id = recvMsg.id;
    data.targetUid = recvMsg.targetUid;
    data.converId = recvMsg.converId;
    data.time = Int64(DateTime.now().millisecondsSinceEpoch);
    data.code = Code.SUCCESS;
    message.messageAck = data;
    return _protoToDelimitedBuffer(message);
  }

  static List<int> getMessageList(Int64 id, String convId, int beginTime) {
    var message = new RavenMessage();
    message.type = RavenMessage_Type.HisMessagesReq;
    var data = HisMessagesReq();
    data.id = id;
    data.converId = convId;
    data.beginId = Int64(beginTime);

    message.hisMessagesReq = data;
    return _protoToDelimitedBuffer(message);
  }

  // For Socket version
  // for protobuf,   length + bytes.  so add the length tag for bytes.

  // static List<int> _protoToDelimitedBuffer(RavenMessage message) {
  //   var messageBuffer = new CodedBufferWriter();
  //   message.writeToCodedBufferWriter(messageBuffer);

  //   var delimiterBuffer = new CodedBufferWriter();
  //   delimiterBuffer.writeInt32NoTag(messageBuffer.lengthInBytes);

  //   var result = new Uint8List(
  //       messageBuffer.lengthInBytes + delimiterBuffer.lengthInBytes);

  //   delimiterBuffer.writeTo(result);
  //   messageBuffer.writeTo(result, delimiterBuffer.lengthInBytes);
  //   return result;
  // }

  // For web socket version.
  static List<int> _protoToDelimitedBuffer(RavenMessage message) {
    var messageBuffer = new CodedBufferWriter();
    message.writeToCodedBufferWriter(messageBuffer);

    var result = new Uint8List(messageBuffer.lengthInBytes);
    messageBuffer.writeTo(result);
    return result;
  }
}