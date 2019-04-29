
import 'package:myapp/entity/conversation_entity.dart';
import 'package:myapp/entity/message_entity.dart';
import 'package:myapp/pb/message.pb.dart';
import 'package:myapp/utils/constants.dart';

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
        isUnreadCount: 0, //TODO
        lastMessage: info.lastContent.content,
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
        contentType: Constants.MESSAGE_TYPE_CHAT,
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
      contentType: Constants.MESSAGE_TYPE_CHAT,
      content: msg.content.content,
      time: msg.content.time.toString(),
      status: 0,
      messageOwner: myUid == msg.fromUid ? 0 : 1,
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
}
