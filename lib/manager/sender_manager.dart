
import 'dart:io';

import 'package:fixnum/fixnum.dart';
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
  
  static init(callback(Object data)) async {
    Socket socket = await SocketMngr.getSocket();
    socket.listen((data) {
      TimMessage message = TimMessage.fromBuffer(data);
      print(message.type);
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
          if (_msgMap.containsKey(message.messageAck.id)) {
            _msgMap.remove(message.messageAck.id);
          } else {
            print("error: $message.messageAck.id contains? $_msgMap.containsKey(message.messageAck.id)");
          } 
          if (message.messageAck.code == Code.SUCCESS) {
            callback(data); 
          } else {
            print("error: message ack: $message.messageAck.code ");
          }
          break;
        case TimMessage_Type.ConverAck:
          if (_msgMap.containsKey(message.converAck.id)) {
            _msgMap.remove(message.converAck.id);
          } else {
            print("error: $message.converAck.id contains? $_msgMap.containsKey(message.converAck.id)");
          } 
          if (message.converAck.code == Code.SUCCESS) {
            callback(data); 
          } else {
            print("error: conversation ack: $message.converAck.code ");
          }
          break;
        case TimMessage_Type.HeartBeat:
          _sendPong(message.heartBeat.id);
          break;
      }
    });
    _loginReq();
  }

  static void _sendMsg(List<int> msg) async {
    if (isLogined) {
      SocketMngr.write(msg);
      _msgMap.putIfAbsent(_msgId, () => msg);
      _msgId++;
    } else {
      print(" not login , can't send message.");
    }
  }

  static void _loginReq() async {
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
      SocketMngr.write(msg);
    } else {
      print(" not login , can't send message.");
    }
  }

  static void sendPing() {
    List<int> list = MessageBuilder.sendHeartBeat(Int64(_msgId), HeartBeatType.PING);
    _sendMsg(list);
  }
}