import 'dart:io';


import 'package:myapp/database/contacts_db_cfg.dart';
import 'package:myapp/entity/contact_entity.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';


class ContactsDataBase {
  static final ContactsDataBase _messageDataBase = new ContactsDataBase._internal();

  static ContactsDataBase get() {
    return _messageDataBase;
  }

  ContactsDataBase._internal();

  Future<Database> _init() async {
    // Get a location using path_provider
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(
        documentsDirectory.path,
        DataBaseConfig.DATABASE_NAME);
    return await openDatabase(path, version: DataBaseConfig.VERSION_CODE,
        onCreate: (Database db, int version) async {
      // When creating the db, create the table
      await db.execute(
          "CREATE TABLE IF NOT EXISTS ${DataBaseConfig.CONTACTS_TABLE} ("
          "${ContactEntity.DB_ID} INTEGER PRIMARY KEY AUTOINCREMENT,"
          "${ContactEntity.STATUS} INTEGER,"
          "${ContactEntity.USER_ID} TEXT,"
          "${ContactEntity.USER_NAME} TEXT,"
          "${ContactEntity.PORTRAIT} TEXT"
          ")");
    });
  }

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
        '${DataBaseConfig.CONTACTS_TABLE}(${ContactEntity.USER_ID},${ContactEntity.USER_NAME},${ContactEntity.PORTRAIT},${ContactEntity.STATUS})'
        ' VALUES(?,?,?,?)',
        [
          entity.userId,
          entity.userName,
          entity.portrait,
          entity.status
        ]);
  }

  Future close() async {
    var db = await _init();
    db.close();
    return db = null;
  }
}
