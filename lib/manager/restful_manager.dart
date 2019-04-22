import 'package:myapp/entity/contact_entity.dart';
import 'package:dio/dio.dart';
import 'dart:convert';

import 'package:myapp/entity/rest_entity.dart';

class RestManager {
  //TODO  through config file
  static const String APP_SERVER_URL = 'http://10.12.9.85:9080/api';
  static const String IM_SERVER_URL = 'http://10.12.9.85:8060';

  static const String GET_TOKEN = '/user/login';
  static final RestManager _contacts = new RestManager._internal();

  static RestManager get() {
    return _contacts;
  }

  RestManager._internal();

  Future<RestEntity> login(String username, String password) async {

      Response response = await Dio().post(APP_SERVER_URL + GET_TOKEN,
        data: {"username": username, "password": password});
      print(response);
      var data = json.decode(response.toString());
      RestEntity entity = RestEntity.fromMap(data);
      return entity;
  }

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
