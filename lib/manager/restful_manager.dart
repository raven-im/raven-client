import 'dart:io';
import 'package:dio/dio.dart';
import 'package:myapp/entity/content_entities/image_entity.dart';
import 'dart:convert';
import 'package:path/path.dart' as path;
import 'package:myapp/entity/rest_entity.dart';
import 'package:myapp/entity/rest_list_entity.dart';
import 'package:myapp/utils/constants.dart';

class RestManager {
  //TODO  through config file
  // static const String APP_SERVER_URL = 'http://10.12.9.127:9080/api';
  // static const String IM_SERVER_URL = 'http://10.12.9.127:8060/route';
  static const String APP_SERVER_URL = 'http://114.67.79.183:8080/api';
  static const String IM_SERVER_URL = 'http://114.67.79.183:8060/raven-zuul/route';

  static const String GET_TOKEN = '/user/login';
  static const String GET_ACCESS_NODE = '/user/access';
  static const String GET_USER_LIST = '/user/list';
  static const UPLOAD_FILE = '/upload';
  static final RestManager _rest = new RestManager._internal();

  static RestManager get() {
    return _rest;
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

    Response response = await Dio().get(IM_SERVER_URL + GET_ACCESS_NODE, 
      options: new Options(
        headers: {
          "token": token,
        }
    ));
    
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

  Future<ImgEntity> uploadFile(File file, String token) async {
    String fileName = path.basename(file.path);
    FormData formData = new FormData.from({
      "file": new UploadFileInfo(file, fileName)
    });

    Response response = await Dio().post(IM_SERVER_URL + UPLOAD_FILE,
      data: formData,
      options: new Options(
        headers: {
          "token": token,
        }
    ));
    
    print(response);
    var data = json.decode(response.toString());
    RestEntity entity = RestEntity.fromMap(data);
    if (Constants.RSP_COMMON_SUCCESS != entity.code) {
      print('upload fail ' + entity.message);
      return null;
    }
    
    ImgEntity image = new ImgEntity(
      name: entity.data['name'],
      size: entity.data['size'],
      url: entity.data['url']); // async from File Server.
    return image;
  }
}
