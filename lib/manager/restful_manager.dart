import 'dart:io';
import 'package:dio/dio.dart';
import 'package:myapp/entity/content_entities/file_entity.dart';
import 'package:myapp/entity/content_entities/token_entity.dart';
import 'package:myapp/entity/group_entity.dart';
import 'dart:convert';
// import 'package:path/path.dart' as path;
import 'package:myapp/entity/rest_entity.dart';
import 'package:myapp/entity/rest_list_entity.dart';
import 'package:myapp/utils/constants.dart';
import 'package:sy_flutter_qiniu_storage/sy_flutter_qiniu_storage.dart';

class RestManager {
  //TODO  through config file
  static const String APP_SERVER_URL = 'http://raven-im.xyz:8084/api';
  static const String IM_SERVER_URL = 'http://raven-im.xyz:8084/raven';
  static const String QINIU_URL = 'http://pu5wwrylf.bkt.clouddn.com/';

  static const String USER_LOGIN = '/user/login';
  // static const String GET_ACCESS_NODE = '/user/access';

  // for flutter web socket.
  static const String GET_ACCESS_NODE = '/admin/gateway/ws'; 
  static const String GET_USER_LIST = '/user/list';
  static const UPLOAD_FILE = '/upload';
  static const QINIU_UPLOAD = '/qiniu_upload';
  static const String GET_USER = '/user/';
  static const PORTRAIT = '/portrait';
  static final RestManager _rest = new RestManager._internal();

  //group operation api
  static const GROUP_API_BASE = '/group';
  static const CREATE_GROUP = GROUP_API_BASE + '/create';
  static const JOIN_GROUP = GROUP_API_BASE + '/join';
  static const QUIT_GROUP = GROUP_API_BASE + '/quit';
  static const DISMISS_GROUP = GROUP_API_BASE + '/dismiss';
  static const DETAIL_GROUP = GROUP_API_BASE + '/detail';
  static const DETAILS_GROUP = GROUP_API_BASE + '/details';

  static RestManager get() {
    return _rest;
  }

  RestManager._internal();

  Future<RestEntity> login(String username, String password) async {

      Response response = await Dio().post(APP_SERVER_URL + USER_LOGIN,
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

  // Fast DFS support only
  // Future<ImgEntity> uploadFile(File file, String token) async {
  //   String fileName = path.basename(file.path);
  //   FormData formData = new FormData.from({
  //     "file": new UploadFileInfo(file, fileName)
  //   });

  //   Response response = await Dio().post(IM_SERVER_URL + UPLOAD_FILE,
  //     data: formData,
  //     options: new Options(
  //       headers: {
  //         "token": token,
  //       }
  //   ));
    
  //   print(response);
  //   var data = json.decode(response.toString());
  //   RestEntity entity = RestEntity.fromMap(data);
  //   if (Constants.RSP_COMMON_SUCCESS != entity.code) {
  //     print('upload fail ' + entity.message);
  //     return null;
  //   }
    
  //   ImgEntity image = new ImgEntity(
  //     name: entity.data['name'],
  //     size: entity.data['size'],
  //     url: entity.data['url']); // async from File Server.
  //   return image;
  // }

  // for Fast DFS upload.
  // Future<ImgEntity> updatePortrait(File file, String uid) async {
  //   String fileName = path.basename(file.path);
  //   FormData formData = new FormData.from({
  //     "file": new UploadFileInfo(file, fileName)
  //   });

  //   Response response = await Dio().post(APP_SERVER_URL + GET_USER + uid + PORTRAIT,
  //     data: formData,
  //   );
    
  //   print(response);
  //   var data = json.decode(response.toString());
  //   RestEntity entity = RestEntity.fromMap(data);
  //   if (Constants.RSP_COMMON_SUCCESS != entity.code) {
  //     print('upload fail ' + entity.message);
  //     return null;
  //   }
    
  //   ImgEntity image = new ImgEntity(
  //     name: entity.data['name'],
  //     size: entity.data['size'],
  //     url: entity.data['url']); // async from File Server.
  //   return image;
  // }


  Future<FileEntity> uploadFile(File file) async {
    TokenEntity tokenEntity = await _getFileToken(file.path.split('.').last);
    
    if (tokenEntity == null) {
      return null;
    }

    final syStorage = new SyFlutterQiniuStorage();
    //监听上传进度
    syStorage.onChanged().listen((dynamic percent) {
      print(percent);
    });

    //上传文件
    bool result = await syStorage.upload(file.path, tokenEntity.token, tokenEntity.url);
    if (result) {
      FileEntity image = new FileEntity(
        name: tokenEntity.url,
        size: file.lengthSync(),
        url: QINIU_URL + tokenEntity.url); // async from File Server.
      return image;
    }
    return null;
  }

  Future<TokenEntity> _getFileToken(String suffix) async {

    Response response = await Dio().get(APP_SERVER_URL + QINIU_UPLOAD, queryParameters: {"suffix": suffix});
    
    print(response);
    var data = json.decode(response.toString());
    RestEntity entity = RestEntity.fromMap(data);
    if (Constants.RSP_COMMON_SUCCESS != entity.code) {
      print('upload fail ' + entity.message);
      return null;
    }
    
    TokenEntity image = new TokenEntity(
      token: entity.data['token'],
      url: entity.data['url']); // async from File Server.
    return image;
  }

  Future<void> updateUserPortraitDB(String uid, String url) async {
      Response response = await Dio().post(APP_SERVER_URL + GET_USER + uid,
        data: {"portrait": url});
      
      var data = json.decode(response.toString());
      RestEntity entity = RestEntity.fromMap(data);
      if (Constants.RSP_COMMON_SUCCESS != entity.code) {
        print("update portrait fail ." + entity.message);
      }
  }

  //group operation

  /*
   * result entity.  entity.data['groupId'], entity.data['converId'],entity.data['time']
   * String groupId:  group id, use this group id for group operation,like join/dismiss etc.  
     String converId: conversation id for further use .
     Date time:  group create time
   */
  Future<RestEntity> createGroup(String name, String portrait, List<String> members) async {
      Response response = await Dio().post(APP_SERVER_URL + CREATE_GROUP,
        data: {"name": name, "portrait": portrait, "members": members});

      var data = json.decode(response.toString());
      RestEntity entity = RestEntity.fromMap(data);
      return entity;
  }

  /*
   * result entity.
   * entity.code: 
   * 10000, "success"
   * 12001, "group id invalid."
   * 12003, "member already in group."
   */
  Future<int> joinGroup(String groupId, List<String> members) async {
      Response response = await Dio().post(APP_SERVER_URL + JOIN_GROUP,
        data: {"groupId": groupId, "members": members});

      var data = json.decode(response.toString());
      RestEntity entity = RestEntity.fromMap(data);
      return entity.code;
  }

  /*
   * result entity.
   * entity.code: 
   * 10000, "success"
   * 12001, "group id invalid."
   * 12002, "member not in group."
   */
  Future<int> quitGroup(String groupId, List<String> members) async {
      Response response = await Dio().post(APP_SERVER_URL + QUIT_GROUP,
        data: {"groupId": groupId, "members": members});

      var data = json.decode(response.toString());
      RestEntity entity = RestEntity.fromMap(data);
      return entity.code;
  }

  /*
   * result entity.
   * entity.code: 
   * 10000, "success"
   * 12001, "group id invalid."
   */
  Future<int> dismissGroup(String groupId) async {
      Response response = await Dio().post(APP_SERVER_URL + DISMISS_GROUP,
        data: {"groupId": groupId});

      var data = json.decode(response.toString());
      RestEntity entity = RestEntity.fromMap(data);
      return entity.code;
  }

  Future<GroupEntity> detailGroup(String groupId) async {
      Response response = await Dio().post(APP_SERVER_URL + DETAIL_GROUP,
        data: {"groupId": groupId});

      var data = json.decode(response.toString());
      RestEntity entity = RestEntity.fromMap(data);

      if (Constants.RSP_COMMON_SUCCESS == entity.code) {
        return GroupEntity(
          conversationId: entity.data['conversationId'],
          groupId: entity.data['groupId'],
          name: entity.data['name'],
          portrait: entity.data['portrait'],
          groupOwner: entity.data['ownerUid'],
          status: entity.data['status'],
          time: entity.data['time'],
          members: entity.data['members'],
          );
      }
      return null;
  }

  Future<List<GroupEntity>> detailsGroup(List<String> groups) async {
      List<GroupEntity> result = [];
      Response response = await Dio().post(APP_SERVER_URL + DETAILS_GROUP,
        data: {"groups": groups});

      var data = json.decode(response.toString());
      RestListEntity entity = RestListEntity.fromMap(data);

      if (Constants.RSP_COMMON_SUCCESS == entity.code) {
        entity.data.forEach((data) {
          result.add(GroupEntity(
          conversationId: data['conversationId'],
          groupId: data['groupId'],
          name: data['name'],
          portrait: data['portrait'],
          groupOwner: data['ownerUid'],
          status: data['status'],
          time: data['time'],
          members: data['members'],
          ));
        });
      }
      return result;
  }
}
