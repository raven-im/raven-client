
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
      info.uid.forEach((id){
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
  // static MessageEntity getDefaultData(String type, String senderAccount) {
  //   return new MessageEntity(
  //           convType: 1,
  //     @required this.fromUid,
  //     @required this.targetUid,
  //     @required this.contentType,
  //     @required this.titleName,
  //     @required this.content,
  //     @required this.time,
  //       type: type,
  //       senderAccount: senderAccount,
  //       titleName: senderAccount,
  //       content: null,
  //       time: null);
  // }

  static bool isNetUri(String uri) {
    if (uri.isNotEmpty &&
        (uri.startsWith('http://') || uri.startsWith('https://'))) {
      return true;
    }
    return false;
  }
}
