import 'package:dio/dio.dart';
import 'dart:convert';

import 'package:myapp/entity/rest_entity.dart';
import 'package:myapp/entity/rest_list_entity.dart';

class RestManager {
  //TODO  through config file
  static const String APP_SERVER_URL = 'http://10.12.9.85:9080/api';
  static const String IM_SERVER_URL = 'http://10.12.9.85:8060/api';

  static const String GET_TOKEN = '/user/login';
  static const String GET_ACCESS_NODE = '/user/access';
  static const String GET_USER_LIST = '/user/list';
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

  Future<RestEntity> getAccess(String appKey, String token) async {

    Response response = await Dio().post(IM_SERVER_URL + GET_ACCESS_NODE,
      data: {"appKey": appKey, "token": token});
    print(response);
    var data = json.decode(response.toString());
    RestEntity entity = RestEntity.fromMap(data);
    return entity;
  }

  Future<RestListEntity> getUserList() async {

    Response response = await Dio().get(APP_SERVER_URL + GET_USER_LIST, queryParameters: {"type": 1});
    print(response);
    var data = json.decode(response.toString());
    RestListEntity entity = RestListEntity.fromMap(data);
    return entity;
  }
}
