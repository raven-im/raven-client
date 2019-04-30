
import 'package:fixnum/fixnum.dart';
import 'dart:io';
import 'package:myapp/database/db_api.dart';
import 'package:myapp/manager/conversation_manager.dart';
import 'package:myapp/manager/message_builder.dart';
import 'package:myapp/pb/message.pb.dart';
import 'package:myapp/utils/constants.dart';
import 'package:myapp/utils/object_util.dart';
import 'package:myapp/utils/sp_util.dart';

class SenderMngr {

  static bool isLogined = false;
  // client id match to server.
  static int _msgId = 1;
  // client message list.
  static Map<int, List<int>> _msgMap = new Map<int, List<int>>();
  static Socket _socket;
  
  static init() async {
    if (_socket != null) {
      print("socket already connected.");
      return;
    }

    List<int> original;
    String myUid = SPUtil.getString(Constants.KEY_LOGIN_UID);
    String ip = SPUtil.getString(Constants.KEY_ACCESS_NODE_IP)?? null;
    int port = SPUtil.getInt(Constants.KEY_ACCESS_NODE_PORT) ?? 0;
    if (ip == null && port == 0) {
      print("socket ip&port not set yet.");
      return;
    }

    // normal case,  socket connect.
    print("socket connect to $ip:$port");
    _socket = await Socket.connect(ip, port);

    _socket.listen((data) {
      RavenMessage message = RavenMessage.fromBuffer(data);
      print(message.type);
      switch (message.type) {
        case RavenMessage_Type.LoginAck:
          if (_msgMap.containsKey(message.loginAck.id)) {
            original = _msgMap.remove(message.loginAck.id);
          } else {
            print("error: ${message.loginAck.id} contains? ${_msgMap.containsKey(message.loginAck.id)}");
          } 
          if (message.loginAck.code == Code.SUCCESS) {
            isLogined = true;
            print("IM Login success");
            ConversationManager.get().requestConverEntities(); 
          } else {
            print("error: login ack: $message.loginAck.code ");
          }
          break;
        case RavenMessage_Type.MessageAck:
          if (_msgMap.containsKey(message.messageAck.cid)) {
            original = _msgMap.remove(message.messageAck.cid);
          } else {
            print("error: ${message.messageAck.cid} contains? ${_msgMap.containsKey(message.messageAck.cid)}");
          } 
          if (message.messageAck.code == Code.SUCCESS) {
            RavenMessage originalMsg = RavenMessage.fromBuffer(original);
            DataBaseApi.get().updateMessageEntity(message.messageAck.converId, 
                ObjectUtil.getMsgEntity(myUid, originalMsg.upDownMessage), false);
          } else {
            print("error: message ack: $message.messageAck.code ");
          }
          break;
        case RavenMessage_Type.ConverAck:
          if (_msgMap.containsKey(message.converAck.id)) {
            original = _msgMap.remove(message.converAck.id);
          } else {
            print("error: ${message.converAck.id} contains? ${_msgMap.containsKey(message.converAck.id)}");
          } 
          if (message.converAck.code == Code.SUCCESS) {
            if (message.converAck.converList != null) {
              DataBaseApi.get()
                  .updateConversationEntities(
                    ObjectUtil.getConvEntities(myUid, message.converAck.converList));
            } else if (message.converAck.converInfo != null) {
              DataBaseApi.get()
                  .updateConversationEntities(
                    ObjectUtil.getConvEntity(myUid, message.converAck.converInfo));
            }
          } else {
            print("error: conversation ack: $message.converAck.code ");
          }
          break;
        case RavenMessage_Type.HeartBeat:
          _sendPong(message.heartBeat.id);
          break;
        case RavenMessage_Type.HisMessagesAck:
          if (_msgMap.containsKey(message.hisMessagesAck.id)) {
            original = _msgMap.remove(message.hisMessagesAck.id);
            //DB insert
            DataBaseApi.get().updateMessageEntities(message.hisMessagesAck.converId, 
                ObjectUtil.getMsgEntities(myUid, message.hisMessagesAck.messageList));
          } else {
            print("error: ${message.hisMessagesAck.id} contains? ${_msgMap.containsKey(message.hisMessagesAck.id)}");
          }
          break;
        case RavenMessage_Type.UpDownMessage:
          print(" receive messages.");
          //DB insert
          DataBaseApi.get().updateMessageEntity(message.upDownMessage.converId, 
              ObjectUtil.getMsgEntity(myUid, message.upDownMessage), true);
          break;
      }
    });
      // socket connected, login.
      _loginReq();
  }

  static void _sendMsg(List<int> msg) async {
    if (isLogined && _socket != null) {
      print("sending message.  $_msgId");
      _socket.add(msg);
      _msgMap.putIfAbsent(_msgId, () => msg);
      _msgId++;
    } else {
      print(" can't send message. Login($isLogined), Socket Connected($_socket)");
    }
  }

  static void _loginReq() {
    if (_socket != null && !isLogined) {
      String uid = SPUtil.getString(Constants.KEY_LOGIN_UID);
      String token = SPUtil.getString(Constants.KEY_LOGIN_TOKEN);
      List<int> list = MessageBuilder.login(_msgId, uid, token);
      _socket.add(list);
      _msgMap.putIfAbsent(_msgId, () => list);
      _msgId++;
    } else {
      print("can't login. Login($isLogined), Socket Connected($_socket)");
    }
  }

  static void sendAllConvListReq() {
    List<int> list = MessageBuilder.getAllConversationList(_msgId);
    _sendMsg(list);
  }

  static void sendDetailConvListReq(String uid) {
    List<int> list = MessageBuilder.getDetailConversationList(_msgId, uid);
    _sendMsg(list);
  }

  static void sendSingleMessageReq(String fromId, String targetId, MessageType type, String content, {String convId}) {
    List<int> list = MessageBuilder.sendSingleMessage(_msgId, fromId, targetId, type, content, converId: convId);
    _sendMsg(list);
  }

  static void sendGroupMessageReq(String fromId, String targetId, MessageType type, String content, String groupId, {String convId}) {
    List<int> list = MessageBuilder.sendGroupMessage(_msgId, fromId, targetId, type, content, groupId, converId: convId);
    _sendMsg(list);
  }

  static void _sendPong(Int64 id) {
    if (isLogined) {
      List<int> msg = MessageBuilder.sendHeartBeat(id, HeartBeatType.PONG);
      _socket.add(msg);
    } else {
      print(" can't send pong. Login($isLogined), Socket Connected($_socket)");
    }
  }

  static void sendPing() {
    List<int> list = MessageBuilder.sendHeartBeat(Int64(_msgId), HeartBeatType.PING);
    _sendMsg(list);
  }

  static void sendMessageEntityReq(String convId, int beginTime) {
    List<int> list = MessageBuilder.getMessageList(_msgId, convId, beginTime);
    _sendMsg(list);
  }

  static void release() {
    _socket?.close();
    _socket = null;
    isLogined = false;
  }
}