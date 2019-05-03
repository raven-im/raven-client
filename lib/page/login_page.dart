import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myapp/manager/restful_manager.dart';
import 'package:myapp/utils/constants.dart';
import 'package:myapp/utils/dialog_util.dart';
import 'package:myapp/utils/interact_vative.dart';
import 'package:myapp/utils/sp_util.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Login();
  }
}

class Login extends StatefulWidget {
  @override
  _LoginState createState() => new _LoginState();
}

class _LoginState extends State<Login> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  // FocusNode firstTextFieldNode = FocusNode();
  // FocusNode secondTextFieldNode = FocusNode();
  var _scaffoldkey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: "Login",
        theme: ThemeData(
            primarySwatch: Colors.lightBlue,
            primaryColor: Colors.grey,
            platform: TargetPlatform.android),
        home: new Scaffold(
            key: _scaffoldkey,
            backgroundColor: Colors.white,
            primary: true,
            body: SafeArea(
              child: ListView(
                physics: AlwaysScrollableScrollPhysics(), //内容不足一屏
                padding: EdgeInsets.symmetric(horizontal: 40.0),
                children: <Widget>[
                  SizedBox(height: 160.0),
                  new Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: new Text("Raven IM",
                          style: TextStyle(
                              color: Colors.blue,
                              fontSize: 36.0,
                              fontStyle: FontStyle.italic,
                              
                            ))
                    ),
                  ),
                  SizedBox(height: 76.0),
                  new Material(
                    borderRadius: BorderRadius.circular(20.0),
                    shadowColor: Colors.grey,
                    color: Colors.lightBlue,
                    elevation: 5.0,
                    child: new TextField(
                      // focusNode: firstTextFieldNode,
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                      controller: _usernameController,
                      maxLines: 1,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(11), //长度限制11
                        WhitelistingTextInputFormatter.digitsOnly
                      ], //只能输入整数
                      decoration: InputDecoration(
                          labelText: 'Username',
                          hintText: 'Input account',
                          prefixIcon: Icon(Icons.phone_android),
                          contentPadding: EdgeInsets.fromLTRB(0, 6, 16, 6),
                          filled: true,
                          fillColor: Colors.transparent,
                          border: InputBorder.none,
                          labelStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                          ),
                          hintStyle: TextStyle(
                            color: Colors.white,
                          )
                      ),
                      // onEditingComplete: () => FocusScope.of(context)
                      //     .requestFocus(secondTextFieldNode),
                    ),
                  ),
                  SizedBox(height: 12.0),
                  new Material(
                    borderRadius: BorderRadius.circular(20.0),
                    shadowColor: Colors.grey,
                    color: Colors.lightBlue,
                    elevation: 5.0,
                    child: new TextField(
                        // focusNode: secondTextFieldNode,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.done,
                        controller: _passwordController,
                        maxLines: 1,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(18),
                          WhitelistingTextInputFormatter(
                              RegExp(Constants.INPUTFORMATTERS))
                        ],
                        obscureText: true,
                        decoration: InputDecoration(
                            labelText: 'Password',
                            hintText: 'Input password',
                            prefixIcon: Icon(Icons.lock),
                            contentPadding: EdgeInsets.fromLTRB(0, 6, 16, 6),
                            filled: true,
                            fillColor: Colors.transparent,
                            border: InputBorder.none,
                            labelStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                            ),
                            hintStyle: TextStyle(
                              color: Colors.white,
                            )
                        ),
                        onEditingComplete: () {
                          _checkInput(context);
                        }),
                  ),
                  SizedBox(height: 35.0),
                  RaisedButton(
                    textColor: Colors.white,
                    color: Colors.lightBlue,
                    padding: EdgeInsets.all(12.0),
                    shape: new StadiumBorder(
                        side: new BorderSide(
                      style: BorderStyle.solid,
                      color: Colors.grey,
                    )),
                    child: Text('Sign in', style: new TextStyle(fontSize: 16.0)),
                    onPressed: () {
//                  Navigator.pop(context);
                      _checkInput(context);
                    },
                  ),
                ],
              ),
            ),
          ),
        );
  }

  void _checkInput(BuildContext context) {
    var username = _usernameController.text;
    if (username.isEmpty) {
      // FocusScope.of(context).requestFocus(firstTextFieldNode);
      DialogUtil.buildToast("please enter username.");
      return;
    }
    var password = _passwordController.text;
    if (password.isEmpty) {
      // FocusScope.of(context).requestFocus(secondTextFieldNode);
      DialogUtil.buildToast("please enter password.");
      return;
    }

    RestManager.get().login(username, password)
        .then((firstEntity) {
          if (Constants.RSP_COMMON_SUCCESS != firstEntity.code) {
            // FocusScope.of(context).requestFocus(firstTextFieldNode);
            DialogUtil.buildToast(firstEntity.message);
          } else {
            RestManager.get().getAccess(firstEntity.data["appKey"], firstEntity.data["token"])
            .then((secondEntity) {
              if (Constants.RSP_COMMON_SUCCESS != secondEntity.code) {
                DialogUtil.buildToast(secondEntity.message);
              } else {
                String accessIp = secondEntity.data["ip"];
                int port = secondEntity.data["port"];
                print("Access address: $accessIp:$port");
                DialogUtil.buildToast('Sign in success.');
                SPUtil.putBool(Constants.KEY_LOGIN, true);
                SPUtil.putString(Constants.KEY_LOGIN_ACCOUNT, username);
                SPUtil.putString(Constants.KEY_LOGIN_UID, firstEntity.data["uid"]);
                SPUtil.putString(Constants.KEY_LOGIN_TOKEN, firstEntity.data["token"]);
                SPUtil.putString(Constants.KEY_ACCESS_NODE_IP, accessIp);
                SPUtil.putInt(Constants.KEY_ACCESS_NODE_PORT, port);
                SystemChannels.textInput.invokeMethod('TextInput.hide');
                _usernameController.text = "";
                _passwordController.text = "";
                InteractNative.getAppEventSink().add(InteractNative.CHANGE_PAGE_TO_MAIN);
              }
            });

          }
        });
  }
}
