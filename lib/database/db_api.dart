import 'dart:convert';
import 'dart:io';
import 'package:myapp/database/db_config.dart';
import 'package:myapp/entity/contact_entity.dart';
import 'package:myapp/entity/content_entities/file_entity.dart';
import 'package:myapp/entity/content_entities/text_entity.dart';
import 'package:myapp/entity/conversation_entity.dart';
import 'package:myapp/entity/group_entity.dart';
import 'package:myapp/entity/group_member_entity.dart';
import 'package:myapp/entity/message_entity.dart';
import 'package:myapp/manager/conversation_manager.dart';
import 'package:myapp/manager/restful_manager.dart';
import 'package:myapp/utils/constants.dart';
import 'package:myapp/utils/interact_vative.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DataBaseApi {
  static final DataBaseApi _messageDataBase = new DataBaseApi._internal();

  static DataBaseApi get() {
    return _messageDataBase;
  }

  DataBaseApi._internal();

  Future<Database> _init() async {
    // Get a location using path_provider
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, DataBaseConfig.DATABASE_NAME);
    return await openDatabase(path, version: DataBaseConfig.VERSION_CODE,
        onCreate: (Database db, int version) async {
      // When creating the db, create the table
      await db.execute(
          "CREATE TABLE IF NOT EXISTS ${DataBaseConfig.CONTACTS_TABLE} ("
          "${ContactEntity.DB_ID} INTEGER PRIMARY KEY AUTOINCREMENT,"
          "${ContactEntity.STATUS} INTEGER,"
          "${ContactEntity.USER_ID} TEXT,"
          "${ContactEntity.USER_NAME} TEXT,"
          "${ContactEntity.MOBILE} TEXT,"
          "${ContactEntity.PORTRAIT} TEXT"
          ")");
      await db.execute(
          "CREATE TABLE IF NOT EXISTS ${DataBaseConfig.MESSAGES_TABLE} ("
          "${MessageEntity.DB_ID} INTEGER PRIMARY KEY AUTOINCREMENT,"
          "${MessageEntity.MSG_ID} TEXT,"
          "${MessageEntity.CONVERSATION_TYPE} INTEGER,"
          "${MessageEntity.IS_UNREAD} INTEGER,"
          "${MessageEntity.FROM_UID} TEXT,"
          "${MessageEntity.TARGET_UID} TEXT,"
          "${MessageEntity.CONTENT} TEXT,"
          "${MessageEntity.CONTENT_TYPE} TEXT,"
          "${MessageEntity.CONVERSATION_ID} TEXT,"
          "${MessageEntity.TIME} TEXT,"
          "${MessageEntity.MESSAGE_OWNER} INTEGER,"
          "${MessageEntity.TYPE} INTEGER,"
          "${MessageEntity.STATUS} INTEGER"
          ")");
      await db.execute(
          "CREATE TABLE IF NOT EXISTS ${DataBaseConfig.CONVERSATIONS_TABLE} ("
          "${ConversationEntity.DB_ID} INTEGER PRIMARY KEY AUTOINCREMENT,"
          "${ConversationEntity.CON_ID} INTEGER,"
          "${ConversationEntity.TARGET_UID} TEXT,"
          "${ConversationEntity.LAST_MESSAGE} TEXT,"
          "${ConversationEntity.IS_UNREAD_COUNT} INTEGER,"
          "${ConversationEntity.LAST_MESSAGE_TIME} TEXT,"
          "${ConversationEntity.LAST_MESSAGE_TYPE} INTEGER,"
          "${ConversationEntity.CONVERATION_TYPE} INTEGER"
          ")");
      await db
          .execute("CREATE TABLE IF NOT EXISTS ${DataBaseConfig.GROUP_TABLE} ("
              "${GroupEntity.DB_ID} INTEGER PRIMARY KEY AUTOINCREMENT,"
              "${GroupEntity.GROUP_ID} TEXT,"
              "${GroupEntity.CONVERSATION_ID} TEXT,"
              "${GroupEntity.NAME} TEXT,"
              "${GroupEntity.PORTRAIT} TEST,"
              "${GroupEntity.TIME} TEXT,"
              "${GroupEntity.GROUP_OWNER} INTEGER,"
              "${GroupEntity.STATUS} INTEGER"
              ")");
      await db.execute(
          "CREATE TABLE IF NOT EXISTS ${DataBaseConfig.GROUP_MEMBERS_TABLE} ("
          "${GroupMemberEntity.DB_ID} INTEGER PRIMARY KEY AUTOINCREMENT,"
          "${GroupMemberEntity.GROUP_ID} TEXT,"
          "${GroupMemberEntity.MEMBER_UID} TEXT,"
          "${GroupMemberEntity.CONVERSATION_ID} TEXT"
          ")");
    });
  }

  Future close() async {
    var db = await _init();
    db.close();
    return db = null;
  }

  Future clearDB() async {
    var db = await _init();
    await db.execute("DELETE FROM  ${DataBaseConfig.GROUP_TABLE}; "
        "DELETE FROM  ${DataBaseConfig.GROUP_MEMBERS_TABLE}; "
        "DELETE FROM  ${DataBaseConfig.CONTACTS_TABLE}; "
        "DELETE FROM  ${DataBaseConfig.MESSAGES_TABLE}; "
        "DELETE FROM  ${DataBaseConfig.CONVERSATIONS_TABLE}; ");
  }

  // Contacts.
  Future<ContactEntity> getContactsEntity(String uid) async {
    var db = await _init();
    var result =
        await db.rawQuery('SELECT * FROM ${DataBaseConfig.CONTACTS_TABLE} '
            'where ${ContactEntity.USER_ID} = "$uid"');
    List<ContactEntity> res = [];
    for (Map<String, dynamic> item in result) {
      res.add(new ContactEntity.fromMap(item));
    }
    return res.first;
  }

  Future<List<ContactEntity>> getAllContactsEntities() async {
    var db = await _init();
    var result =
        await db.rawQuery('SELECT * FROM ${DataBaseConfig.CONTACTS_TABLE}');
    List<ContactEntity> res = [];
    for (Map<String, dynamic> item in result) {
      res.add(new ContactEntity.fromMap(item));
    }
    return res;
  }

  Future updateContactsEntity(ContactEntity entity) {
    getAllContactsEntities().then((list) {
      bool isExit = false;
      for (ContactEntity item in list) {
        if (item.userId == entity.userId) {
          isExit = true;
        }
      }
      if (!isExit) {
        _updateContactsEntity(entity);
      }
    });
    return null;
  }

  Future _updateContactsEntity(ContactEntity entity) async {
    var db = await _init();
    await db.rawUpdate(
        'INSERT OR REPLACE INTO '
        '${DataBaseConfig.CONTACTS_TABLE}(${ContactEntity.USER_ID},${ContactEntity.USER_NAME},${ContactEntity.PORTRAIT},${ContactEntity.STATUS},${ContactEntity.MOBILE})'
        ' VALUES(?,?,?,?,?)',
        [
          entity.userId,
          entity.userName,
          entity.portrait,
          entity.status,
          entity.mobile,
        ]);
  }

  Future updatePortrait(String url, String uid) async {
    var db = await _init();
    await db.rawUpdate('UPDATE ${DataBaseConfig.CONTACTS_TABLE} SET '
        ' ${ContactEntity.PORTRAIT} = "$url" '
        'where ${ContactEntity.USER_ID} = "$uid"');
  }
  // Messages

  // get all messages that belongs to that conversation.
  Future<List<MessageEntity>> getMessagesEntities(String convId) async {
    var db = await _init();
    var result =
        await db.rawQuery('SELECT * FROM ${DataBaseConfig.MESSAGES_TABLE} '
            'where ${MessageEntity.CONVERSATION_ID} = "$convId"');
    List<MessageEntity> res = [];
    for (Map<String, dynamic> item in result) {
      res.add(new MessageEntity.fromMap(item));
    }
    return res;
  }

  // get all messages that belongs to that conversation.
  Future<int> getLatestMessageTime(String convId) async {
    var db = await _init();
    var result = await db.rawQuery(
        'SELECT ${MessageEntity.TIME} FROM ${DataBaseConfig.MESSAGES_TABLE} '
        ' order by ${MessageEntity.TIME} desc');
    List<int> res = [];
    for (Map<String, dynamic> item in result) {
      res.add(int.parse(item[MessageEntity.TIME]));
    }
    return res.first;
  }

  Future updateMessageEntities(
      String convId, List<MessageEntity> entities) async {
    // if (entities.length <= 0) {
    //   return null;
    // }

    getMessagesEntities(convId).then((list) {
      var msgList = list.map((f) => f.msgId).toList();

      for (MessageEntity item in entities) {
        if (!msgList.contains(item.msgId)) {
          item.convId = convId;
          _updateMessagesEntity(item); // ?? TODO async.
        }
      }
      InteractNative.getAppEventSink().add(InteractNative.PULL_MESSAGE);
    });
    return null;
  }

  Future updateMessageEntity(MessageEntity entity, bool notify) async {
    _updateMessagesEntity(entity).then((_) {
      if (notify) {
        InteractNative.getMessageEventSink().add(entity);
      }
    });

    isConversationIdExist(entity.convId).then((isExist) {
      if (isExist) {
        // otherwise update the conversation.
        updateConversationEntity(entity.convId, entity);
        InteractNative.getAppEventSink().add(InteractNative.PULL_CONVERSATION);
      } else {
        //if conversation id not exsists,  request the conversation from server.
        ConversationManager.get().requestConverEntity(entity.convId);
      }
    });
  }

  Future _updateMessagesEntity(MessageEntity entity) async {
    var db = await _init();
    await db.rawUpdate(
        'INSERT OR REPLACE INTO '
        '${DataBaseConfig.MESSAGES_TABLE} '
        '(${MessageEntity.MSG_ID},${MessageEntity.CONVERSATION_TYPE},'
        '${MessageEntity.IS_UNREAD},${MessageEntity.FROM_UID},'
        '${MessageEntity.TARGET_UID},${MessageEntity.CONTENT},'
        '${MessageEntity.CONTENT_TYPE},${MessageEntity.CONVERSATION_ID},'
        '${MessageEntity.TIME},${MessageEntity.MESSAGE_OWNER}, ${MessageEntity.STATUS},'
        '${MessageEntity.TYPE})'
        ' VALUES(?,?,?,?,?,?,?,?,?,?,?,?)',
        [
          entity.msgId,
          entity.convType,
          entity.isUnread,
          entity.fromUid,
          entity.targetUid,
          entity.content,
          entity.contentType,
          entity.convId,
          entity.time,
          entity.messageOwner,
          entity.status,
          entity.type
        ]);
  }

  // Conversations.

  // get all conversation.
  Future<List<ConversationEntity>> getConversationEntities() async {
    var db = await _init();
    var result = await db.rawQuery(
        'SELECT * FROM ${DataBaseConfig.CONVERSATIONS_TABLE} ORDER BY ${ConversationEntity.LAST_MESSAGE_TIME} DESC');
    List<ConversationEntity> res = [];
    for (Map<String, dynamic> item in result) {
      res.add(new ConversationEntity.fromMap(item));
    }
    return res;
  }

  Future<GroupEntity> getGroupEntity(String id) async {
    var db = await _init();
    var result =
        await db.rawQuery('SELECT * FROM ${DataBaseConfig.GROUP_TABLE} '
            'where ${GroupEntity.GROUP_ID} = "$id"');
    List<GroupEntity> res = [];
    for (Map<String, dynamic> item in result) {
      res.add(GroupEntity.fromMap(item));
    }

    var memberResult =
        await db.rawQuery('SELECT * FROM ${DataBaseConfig.GROUP_MEMBERS_TABLE} '
            'where ${GroupMemberEntity.GROUP_ID} = "$id"');
    List<String> members = [];
    for (Map<String, dynamic> item in memberResult) {
      members.add(GroupMemberEntity.fromMap(item).member);
    }
    res.first.members = members;
    return res.first;
  }

  Future<String> getConversationIdByUserid(String uid) async {
    var db = await _init();
    var result = await db
        .rawQuery('SELECT id FROM ${DataBaseConfig.CONVERSATIONS_TABLE} '
            'where ${ConversationEntity.TARGET_UID} = "$uid"');
    List<String> res = [];
    for (Map<String, dynamic> item in result) {
      res.add(item[ConversationEntity.CON_ID]);
    }
    return res.length > 0 ? res.first : " ";
  }

  Future<bool> isConversationIdExist(String convId) async {
    var db = await _init();
    var result = await db
        .rawQuery('SELECT id FROM ${DataBaseConfig.CONVERSATIONS_TABLE} '
            'where ${ConversationEntity.CON_ID} = "$convId"');
    List<String> res = [];
    for (Map<String, dynamic> item in result) {
      res.add(item[ConversationEntity.CON_ID]);
    }
    return res.length > 0;
  }

  Future<ConversationEntity> getConversationById(String convId) async {
    var db = await _init();
    var result = await db
        .rawQuery('SELECT * FROM ${DataBaseConfig.CONVERSATIONS_TABLE} '
            'where ${ConversationEntity.CON_ID} = "$convId"');
    List<ConversationEntity> res = [];
    for (Map<String, dynamic> item in result) {
      res.add(ConversationEntity.fromMap(item));
    }
    return res.first;
  }

  Future updateConversationEntity(String convId, MessageEntity entity) async {
    await _updateConversationEntity(convId, entity);
  }

  Future updateConversationEntities(List<ConversationEntity> entities) async {
    getConversationEntities().then((list) {
      var convList = list.map((f) => f.id).toList();
      for (ConversationEntity item in entities) {
        if (!convList.contains(item.id)) {
          _updateConversationsEntity(item);
        }
      }
    });
  }

  Future _updateConversationEntity(String convId, MessageEntity entity) async {
    var db = await _init();
    String lastMsg = "default";
    var data = json.decode(entity.content);
    switch (entity.contentType) {
      case Constants.CONTENT_TYPE_TEXT:
        TextEntity text = TextEntity.fromMap(data);
        lastMsg = text.content;
        break;
      case Constants.CONTENT_TYPE_IMAGE:
        FileEntity image = FileEntity.fromMap(data);
        lastMsg = image.name;
        break;
      default:
        break;
    }

    await db.rawUpdate('UPDATE ${DataBaseConfig.CONVERSATIONS_TABLE} SET '
        ' ${ConversationEntity.LAST_MESSAGE} = "$lastMsg", '
        ' ${ConversationEntity.LAST_MESSAGE_TIME} = "${entity.time}" '
        'where ${ConversationEntity.CON_ID} = "$convId"');
  }

  Future _updateConversationsEntity(ConversationEntity entity) async {
    var db = await _init();
    String lastMsg = "";
    if (entity.lastMessage.isNotEmpty) {
      var data = json.decode(entity.lastMessage);
      switch (entity.lastMsgType) {
        case Constants.CONTENT_TYPE_TEXT:
          TextEntity text = TextEntity.fromMap(data);
          lastMsg = text.content;
          break;
        case Constants.CONTENT_TYPE_IMAGE:
          FileEntity image = FileEntity.fromMap(data);
          lastMsg = image.name;
          break;
        default:
          break;
      }
    }

    await db.rawUpdate(
        'INSERT OR REPLACE INTO '
        '${DataBaseConfig.CONVERSATIONS_TABLE} '
        '(${ConversationEntity.CON_ID},${ConversationEntity.TARGET_UID},'
        '${ConversationEntity.LAST_MESSAGE},${ConversationEntity.IS_UNREAD_COUNT},'
        '${ConversationEntity.LAST_MESSAGE_TYPE},'
        '${ConversationEntity.LAST_MESSAGE_TIME},${ConversationEntity.CONVERATION_TYPE}) '
        ' VALUES(?,?,?,?,?,?,?)',
        [
          entity.id,
          entity.targetUid,
          lastMsg,
          entity.isUnreadCount,
          entity.lastMsgType,
          entity.timestamp,
          entity.conversationType,
        ]);
  }

  //group.
  Future updateGroupInfo(List<ConversationEntity> entities) async {
    var groups = entities
        .where((f) => f.conversationType == Constants.CONVERSATION_GROUP)
        .map((f) => f.targetUid)
        .toList();
    List<GroupEntity> groupEntities =
        await RestManager.get().detailsGroup(groups);
    groupEntities.forEach((entity) {
      _updateGroupInfo(entity);
      entity.members.forEach((member) {
        updateGroupMemberInfo(GroupMemberEntity(
          groupId: entity.groupId,
          conversationId: entity.conversationId,
          member: member,
        ));
      });
    });
  }

  Future _updateGroupInfo(GroupEntity entity) async {
    var db = await _init();
    await db.rawUpdate(
        'INSERT OR REPLACE INTO '
        '${DataBaseConfig.GROUP_TABLE} '
        '(${GroupEntity.GROUP_ID},${GroupEntity.CONVERSATION_ID},'
        '${GroupEntity.NAME},${GroupEntity.PORTRAIT},'
        '${GroupEntity.TIME},'
        '${GroupEntity.GROUP_OWNER},${GroupEntity.STATUS}) '
        ' VALUES(?,?,?,?,?,?,?)',
        [
          entity.groupId,
          entity.conversationId,
          entity.name,
          entity.portrait,
          entity.time,
          entity.groupOwner,
          entity.status,
        ]);
  }

  Future updateGroupMemberInfo(GroupMemberEntity entity) async {
    var db = await _init();
    var result = await db.rawQuery(
        'SELECT * FROM ${DataBaseConfig.GROUP_MEMBERS_TABLE} '
        'where ${GroupMemberEntity.GROUP_ID} = "${entity.groupId}" and ${GroupMemberEntity.MEMBER_UID} = "${entity.member}" ');
    if (result.length > 0) {
      return;
    }
    await db.rawUpdate(
        'INSERT OR REPLACE INTO '
        '${DataBaseConfig.GROUP_MEMBERS_TABLE} '
        '(${GroupMemberEntity.GROUP_ID},${GroupMemberEntity.CONVERSATION_ID},'
        '${GroupMemberEntity.MEMBER_UID}) '
        ' VALUES(?,?,?)',
        [
          entity.groupId,
          entity.conversationId,
          entity.member,
        ]);
  }

  Future deleteGroupMemberInfo(GroupMemberEntity entity) async {
    var db = await _init();
    await db.rawUpdate('DELETE FROM '
        '${DataBaseConfig.GROUP_MEMBERS_TABLE} '
        ' where ${GroupMemberEntity.GROUP_ID} = "${entity.groupId}" and '
        ' ${GroupMemberEntity.CONVERSATION_ID} = "${entity.conversationId}" and '
        ' ${GroupMemberEntity.MEMBER_UID} = "${entity.member}" ');
  }

  Future<List<GroupEntity>> getAllGroupEntities() async {
    var db = await _init();
    var result =
        await db.rawQuery('SELECT * FROM ${DataBaseConfig.GROUP_TABLE}');
    List<GroupEntity> res = [];
    for (Map<String, dynamic> item in result) {
      res.add(GroupEntity.fromMap(item));
    }
    for (GroupEntity entity in res) {
      var tmpResult = await db
          .rawQuery('SELECT * FROM ${DataBaseConfig.GROUP_MEMBERS_TABLE} '
              'where ${GroupEntity.GROUP_ID} = "${entity.groupId}"');
      for (Map<String, dynamic> member in tmpResult) {
        if (entity.members == null) {
          entity.members = [];
        }
        entity.members.add(GroupMemberEntity.fromMap(member).member);
      }
    }
    return res;
  }

  Future _deleteGroupMemberById(String convId) async {
    var db = await _init();
    await db.rawUpdate('DELETE FROM '
        '${DataBaseConfig.GROUP_MEMBERS_TABLE} '
        ' where ${GroupMemberEntity.CONVERSATION_ID} = "$convId" ');
  }

  Future _deleteGroupById(String convId) async {
    var db = await _init();
    await db.rawUpdate('DELETE FROM '
        '${DataBaseConfig.GROUP_TABLE} '
        ' where ${GroupEntity.CONVERSATION_ID} = "$convId" ');
  }

  Future _deleteConversationById(String convId) async {
    var db = await _init();
    await db.rawUpdate('DELETE FROM '
        '${DataBaseConfig.CONVERSATIONS_TABLE} '
        ' where ${ConversationEntity.CON_ID} = "$convId" ');
  }

  Future _deleteMsgsById(String convId) async {
    var db = await _init();
    await db.rawUpdate('DELETE FROM '
        '${DataBaseConfig.MESSAGES_TABLE} '
        ' where ${MessageEntity.CONVERSATION_ID} = "$convId" ');
  }


  Future deleteConversationById(String convId) async {
    ConversationEntity entity = await getConversationById(convId);
    _deleteConversationById(convId);
    _deleteMsgsById(convId);
    if (entity.conversationType == Constants.CONVERSATION_GROUP) {
      _deleteGroupMemberById(convId);
      _deleteGroupById(convId);
    }
  }
}
