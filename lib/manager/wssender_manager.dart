
import 'package:fixnum/fixnum.dart';
import 'package:myapp/database/db_api.dart';
import 'package:myapp/entity/conversation_entity.dart';
import 'package:myapp/entity/message_entity.dart';
import 'package:myapp/manager/conversation_manager.dart';
import 'package:myapp/manager/message_builder.dart';
import 'package:myapp/pb/message.pb.dart';
import 'package:myapp/utils/constants.dart';
import 'package:myapp/utils/dialog_util.dart';
import 'package:myapp/utils/interact_vative.dart';
import 'package:myapp/utils/object_util.dart';
import 'package:myapp/utils/sp_util.dart';
import 'package:web_socket_channel/io.dart';

class SenderMngr {

  static bool isLogined = false;
  // client message list.
  static Map<Int64, List<int>> _msgMap = new Map<Int64, List<int>>();
  static IOWebSocketChannel _channel;
  
  static init() async {
    if (_channel != null) {
      print("websocket already connected.");
      return;
    }

    String ip = SPUtil.getString(Constants.KEY_ACCESS_NODE_IP)?? null;
    int port = SPUtil.getInt(Constants.KEY_ACCESS_NODE_PORT) ?? 0;
    if (ip == null && port == 0) {
      print("websocket ip&port not set yet.");
      return;
    }

    // normal case,  socket connect.
    print("websocket connect to $ip:$port");
    _channel = IOWebSocketChannel.connect("ws://$ip:$port/ws");
    // socket connected, login.
    _loginReq();
    _channel.stream.listen(_dataHandler, 
          onError: _errorHandler, 
          onDone: _doneHandler, 
          cancelOnError: false
    );

  }

  static void _sendMsg(Int64 msgId, List<int> msg) async {
    if (isLogined && _channel != null) {
      print("sending message.  $msgId");
      _channel.sink.add(msg);
      _msgMap.putIfAbsent(msgId, () => msg);
    } else {
      print(" can't send message. Login($isLogined), Socket Connected($_channel)");
      DialogUtil.buildToast("Socket lost, please reconnect.");
    }
  }

  static void _loginReq() {
    if (_channel != null && !isLogined) {
      String uid = SPUtil.getString(Constants.KEY_LOGIN_UID);
      String token = SPUtil.getString(Constants.KEY_LOGIN_TOKEN);
      Int64 msgId = _getMsgId();
      List<int> list = MessageBuilder.login(msgId, uid, token);
      _channel.sink.add(list);
      _msgMap.putIfAbsent(msgId, () => list);
    } else {
      print("can't login. Login($isLogined), Socket Connected($_channel)");
    }
  }

  static void sendAllConvListReq() {
    Int64 msgId = _getMsgId();
    List<int> list = MessageBuilder.getAllConversationList(msgId);
    _sendMsg(msgId, list);
  }

  static void sendDetailConvListReq(String uid) {
    Int64 msgId = _getMsgId();
    List<int> list = MessageBuilder.getDetailConversationList(msgId, uid);
    _sendMsg(msgId, list);
  }

  static void sendSingleMessageReq(MessageEntity entity) {
    Int64 msgId = _getMsgId();
    List<int> list = MessageBuilder.sendSingleMessage(msgId, entity);
    _sendMsg(msgId, list);
  }

  static void sendGroupMessageReq(MessageEntity entity) {
    Int64 msgId = _getMsgId();
    List<int> list = MessageBuilder.sendGroupMessage(msgId, entity);
    _sendMsg(msgId, list);
  }

  static void _sendPong(Int64 id) {
    if (isLogined) {
      List<int> msg = MessageBuilder.sendHeartBeat(id, HeartBeatType.PONG);
      _channel.sink.add(msg);
    } else {
      print(" can't send pong. Login($isLogined), Socket Connected($_channel)");
    }
  }

  static void sendPing() {
    Int64 msgId = _getMsgId();
    List<int> list = MessageBuilder.sendHeartBeat(msgId, HeartBeatType.PING);
    _sendMsg(msgId, list);
  }

  static void sendMessageEntityReq(String convId, int beginTime) {
    Int64 msgId = _getMsgId();
    List<int> list = MessageBuilder.getMessageList(msgId, convId, beginTime);
    _sendMsg(msgId, list);
  }

  static void release() {
    _channel.sink.close();
    _channel = null;
    isLogined = false;
  }

  static void _dataHandler(data) async {
    List<int> original;
    String myUid = SPUtil.getString(Constants.KEY_LOGIN_UID);

    RavenMessage message = RavenMessage.fromBuffer(data);
    print(message.type);
    switch (message.type) {
      case RavenMessage_Type.LoginAck:
        if (_msgMap.containsKey(message.loginAck.id)) {
          original = _msgMap.remove(message.loginAck.id);
        } else {
          print("error: ${message.loginAck.id} contains? ${_msgMap.containsKey(message.loginAck.id)}");
          return;
        } 
        if (message.loginAck.code == Code.SUCCESS) {
          isLogined = true;
          print("IM Login success");
          // pull conversation from DB.
          InteractNative.getAppEventSink().add(InteractNative.PULL_CONVERSATION);
          // request server to update db.
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
          return;
        } 
        if (message.messageAck.code == Code.SUCCESS) {
          RavenMessage originalMsg = RavenMessage.fromBuffer(original);
          DataBaseApi.get().updateMessageEntity(
            ObjectUtil.getMsgEntityByAck(myUid, originalMsg.upDownMessage, message.messageAck),
            false);
        } else {
          print("error: message ack: $message.messageAck.code ");
        }
        break;
      case RavenMessage_Type.ConverAck:
        if (_msgMap.containsKey(message.converAck.id)) {
          original = _msgMap.remove(message.converAck.id);
        } else {
          print("error: ${message.converAck.id} contains? ${_msgMap.containsKey(message.converAck.id)}");
          return;
        } 
        if (message.converAck.code == Code.SUCCESS) {
          List<ConversationEntity> entities;
          if (message.converAck.converList.isNotEmpty) {
            entities = ObjectUtil.getConvEntities(myUid, message.converAck.converList);
          } else if (message.converAck.converInfo.converId != "") {
            List<ConverInfo> list = new List();
            list.add(message.converAck.converInfo);
            entities = ObjectUtil.getConvEntities(myUid, list);
          }
          await DataBaseApi.get().updateConversationEntities(entities);
          await DataBaseApi.get().updateGroupInfo(entities);
          //notify Pull conversation.
          await new Future.delayed(new Duration(milliseconds: 1000));
          InteractNative.getAppEventSink().add(InteractNative.PULL_CONVERSATION);
        } else {
          print("error: conversation ack: $message.converAck.code ");
        }
        break;
      case RavenMessage_Type.HeartBeat:
        _sendPong(message.heartBeat.id);
        break;
      case RavenMessage_Type.HisMessagesAck:
        if (_msgMap.containsKey(message.hisMessagesAck.id)) {
          _msgMap.remove(message.hisMessagesAck.id);
          //DB insert
          DataBaseApi.get().updateMessageEntities(message.hisMessagesAck.converId, 
              ObjectUtil.getMsgEntities(myUid, message.hisMessagesAck.convType.value, 
                message.hisMessagesAck.converId,message.hisMessagesAck.messageList));
        } else {
          print("error: ${message.hisMessagesAck.id} contains? ${_msgMap.containsKey(message.hisMessagesAck.id)}");
        }
        break;
      case RavenMessage_Type.UpDownMessage:
        print(" receive messages.");
        // response to server with message ack 
        List<int> msg = MessageBuilder.sendMessageAck(message.upDownMessage);
        _channel.sink.add(msg);
    
        //DB insert
        DataBaseApi.get().updateMessageEntity( 
            ObjectUtil.getMsgEntity(myUid, message.upDownMessage), 
            true);
        break;
    }
  }

  static void _errorHandler(Object error, StackTrace trace){
    print(error);
  }

  static void _doneHandler(){
    print("socket done.");
    _channel.sink.close();
    _channel = null;
    isLogined = false;
  }

  static Int64 _getMsgId() {
    return Int64(DateTime.now().millisecondsSinceEpoch);
  }
}