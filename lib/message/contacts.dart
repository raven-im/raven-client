import 'package:myapp/entity/contact_entity.dart';


class ContactManager {
  static final ContactManager _contacts = new ContactManager._internal();

  static ContactManager get() {
    return _contacts;
  }

  ContactManager._internal();

  /*
  *  查询联系人列表
  */
  Future<List<ContactEntity>> getContactsEntity(String myUid) async {
    var map = {
      ContactEntity.USER_ID: 'xfdsfdfdfa',
      ContactEntity.USER_NAME: "George",
      ContactEntity.PORTRAIT: 'http://google.com/1.jpg',
      ContactEntity.STATUS: 0,
    };
    var map1 = {
      ContactEntity.USER_ID: 'xfdsfdsfafdfdfa',
      ContactEntity.USER_NAME: "Helen",
      ContactEntity.PORTRAIT: 'http://google.com/2.jpg',
      ContactEntity.STATUS: 0,
    };
    var map2 = {
      ContactEntity.USER_ID: 'xfd3432432sfdfdfa',
      ContactEntity.USER_NAME: "Lisa",
      ContactEntity.PORTRAIT: 'http://google.com/3.jpg',
      ContactEntity.STATUS: 0,
    };
    List<Map<String, dynamic>> result = new List();
    result..add(map1)..add(map)..add(map2);

    List<ContactEntity> res = [];
    for (Map<String, dynamic> item in result) {
      res.add(new ContactEntity.fromMap(item));
    }
    return res;
  }

}
