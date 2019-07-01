
import 'package:flutter/material.dart';
import 'package:myapp/database/db_api.dart';
import 'package:myapp/entity/conversation_entity.dart';
import 'package:myapp/entity/message_entity.dart';
import 'package:myapp/manager/sender_manager.dart';
import 'package:myapp/pb/message.pb.dart';
import 'package:myapp/utils/constants.dart';
import 'package:myapp/utils/interact_vative.dart';
import 'package:myapp/utils/sp_util.dart';

class ObjectUtil {
  
  static bool isNotEmpty(Object object) {
    return !isEmpty(object);
  }

  static bool isEmpty(Object object) {
    if (object == null) return true;
    if (object is String && object.isEmpty) {
      return true;
    } else if (object is List && object.isEmpty) {
      return true;
    } else if (object is Map && object.isEmpty) {
      return true;
    }
    return false;
  }

  static List<ConversationEntity> getConvEntities(String myUid, List<ConverInfo> convList) {
    List<ConversationEntity> list = new List();
    convList.forEach((info) {
      String targetId;
      info.uidList.forEach((id){
        if (id != myUid) {
          targetId = id;
        }
      });
      ConversationEntity entity = new ConversationEntity(
        id: info.converId,
        targetUid: targetId,
        isUnreadCount: info.unCount.toInt(),
        lastMessage: info.lastContent.content,
        lastMsgType: info.lastContent.type.value,
        timestamp: info.lastContent.time.toInt(),
        conversationType: Constants.CONVERSATION_SINGLE); //TODO group
      list.add(entity);
    });
    return list;
  }

  static List<ConversationEntity> getConvEntity(String myUid, ConverInfo info) {
    List<ConversationEntity> list = new List();
    String targetId;
    info.uidList.forEach((id){
      if (id != myUid) {
        targetId = id;
      }
    });
    ConversationEntity entity = new ConversationEntity(
      id: info.converId,
      targetUid: targetId,
      isUnreadCount: 0, //TODO
      lastMessage: info.lastContent.content,
      timestamp: info.lastContent.time.toInt(),
      conversationType: Constants.CONVERSATION_SINGLE); //TODO group
    list.add(entity);
    return list;
  }
  static List<MessageEntity> getMsgEntities(String myUid, List<MessageContent> msgList) {
    List<MessageEntity> list = new List();
    msgList.forEach((msg) {
      MessageEntity entity = new MessageEntity(
        msgId: msg.id.toInt(),
        convType: Constants.CONVERSATION_SINGLE, //TODO Group?
        fromUid: msg.uid,
        targetUid: myUid, //??
        contentType: msg.type.value,
        content: msg.content,
        time: msg.time.toString(),
        status: 0,
        messageOwner: myUid == msg.uid ? 0 : 1,
      );
      list.add(entity);
    });
    return list;
  }

  static MessageEntity getMsgEntity(String myUid, UpDownMessage msg) {

    MessageEntity entity = new MessageEntity(
      msgId: msg.id.toInt(),
      convType: Constants.CONVERSATION_SINGLE, //TODO Group?
      fromUid: msg.fromUid,
      targetUid: msg.targetUid, //??
      contentType: msg.content.type.value, //??
      content: msg.content.content,
      time: msg.content.time.toString(),
      status: 0,
      messageOwner: myUid == msg.fromUid ? 0 : 1,
      convId: msg.converId,
    );
    return entity;
  }

  static MessageEntity getMsgEntityByAck(String myUid, UpDownMessage oriMsg, MessageAck ack) {

    MessageEntity entity = new MessageEntity(
      msgId: ack.id.toInt(),
      convType: Constants.CONVERSATION_SINGLE, //TODO Group?
      fromUid: oriMsg.fromUid,
      targetUid: oriMsg.targetUid, //??
      contentType: oriMsg.content.type.value, //??
      content: oriMsg.content.content,
      time: ack.time.toString(),
      status: 0,
      messageOwner: myUid == oriMsg.fromUid ? 0 : 1,
      convId: ack.converId
    );
    return entity;
  }

  static bool isNetUri(String uri) {
    if (uri.isNotEmpty &&
        (uri.startsWith('http://') || uri.startsWith('https://'))) {
      return true;
    }
    return false;
  }

  static void doExit(BuildContext context) {
    //SP delete.
    SPUtil.putBool(Constants.KEY_LOGIN, false);
    SPUtil.remove(Constants.KEY_LOGIN_ACCOUNT);
    SPUtil.remove(Constants.KEY_LOGIN_UID);
    SPUtil.remove(Constants.KEY_LOGIN_TOKEN);
    SPUtil.remove(Constants.KEY_ACCESS_NODE_IP);
    SPUtil.remove(Constants.KEY_ACCESS_NODE_PORT);
    SPUtil.remove(Constants.KEY_LOGIN_ACCOUNT_MOBILE);
    SPUtil.remove(Constants.KEY_LOGIN_ACCOUNT_PORTRAIT);
    
    //DB delete.
    DataBaseApi.get().clearDB().then((_) => DataBaseApi.get().close());
    //socket disconnect.
    SenderMngr.release();
    //notify UI switch.
    InteractNative.getAppEventSink().add(InteractNative.CHANGE_PAGE_TO_LOGIN);
    InteractNative.closeStream();
  }
}
