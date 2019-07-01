import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/database/db_api.dart';
import 'package:myapp/manager/restful_manager.dart';
import 'package:myapp/page/more_widgets.dart';
import 'package:myapp/utils/constants.dart';
import 'package:myapp/utils/dialog_util.dart';
import 'package:myapp/utils/object_util.dart';
import 'package:myapp/utils/popupwindow_widget.dart';
import 'package:myapp/utils/sp_util.dart';

/*
*  我的
*/
class MinePage extends StatefulWidget {
  MinePage({Key key, this.rootContext})
      : super(key: key);
  final BuildContext rootContext;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MineState();
  }
}

class _MineState extends State<MinePage> with AutomaticKeepAliveClientMixin {
  File imageChild;
  String myUid = SPUtil.getString(Constants.KEY_LOGIN_UID);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MoreWidgets.buildAppBar(context, 'Profile',
            elevation: 0.0, actions: _actions(context)),
        body: ListView(
          children: <Widget>[
            MoreWidgets.mineListViewItem1(
                SPUtil.getString(Constants.KEY_LOGIN_ACCOUNT)??"Me",
                content: SPUtil.getString(Constants.KEY_LOGIN_ACCOUNT_MOBILE),
                imageChild: _getHeadPortrait(), onImageClick: (res) {
              PopupWindowUtil.showPhotoChosen(context, onCallBack: (image) {
                File file = image;
                RestManager.get().updatePortrait(file, myUid)
                  .then((imgEntity) {
                    if (imgEntity == null) {
                      return;
                    }
                    // set DB
                    String uid = SPUtil.getString(Constants.KEY_LOGIN_UID);
                    DataBaseApi.get().updatePortrait(imgEntity.url, uid).then((entities) {
                      SPUtil.putString(Constants.KEY_LOGIN_ACCOUNT_PORTRAIT, imgEntity.url);
                    });
                    setState(() {
                      imageChild = image;
                    });
                  });
              });
            }),
            MoreWidgets.buildDivider(),
            MoreWidgets.defaultListViewItem(Icons.settings, 'Settings',
                textColor: Colors.black, isDivider: false, onItemClick: (res) {
              // Navigator.push(
              //     context,
              //     new CupertinoPageRoute<void>(
              //         builder: (ctx) => SettingPage())
              //         );
            }),
            MoreWidgets.buildDivider(),
            MoreWidgets.defaultListViewItem(Icons.exit_to_app, 'Logout',
                textColor: Colors.black, isDivider: false, onItemClick: (res) {
              DialogUtil.showBaseDialog(context, 'Sure to logout？', leftClick: (res) {
                _logOut();
              });
            }),
            MoreWidgets.buildDivider(),
          ],
        )
        // This trailing comma makes auto-formatting nicer for build methods.
        );
  }

  List<Widget> _actions(BuildContext context) {
    List<Widget> actions = new List();
    Widget widget = InkWell(
        child: Container(
            padding: EdgeInsets.only(right: 20, left: 20),
            child: Icon(
              Icons.add_a_photo,
              size: 22,
            )),
        onTap: () {
          PopupWindowUtil.showPhotoChosen(context, onCallBack: (image) {
                File file = image;
                RestManager.get().updatePortrait(file, myUid)
                  .then((imgEntity) {
                    if (imgEntity == null) {
                      return;
                    }
                    // set DB
                    DataBaseApi.get().updatePortrait(imgEntity.url, myUid).then((entities) {
                      SPUtil.putString(Constants.KEY_LOGIN_ACCOUNT_PORTRAIT, imgEntity.url);
                    });
                    setState(() {
                      imageChild = image;
                    });
                  });
              });
        });
    actions.add(widget);
    return actions;
  }

  Widget _getHeadPortrait() {
    if (null != imageChild) {
      return Image.file(imageChild, width: 62, height: 62, fit: BoxFit.fill);
    }
    String portraitUrl = SPUtil.getString(Constants.KEY_LOGIN_ACCOUNT_PORTRAIT);
    if (portraitUrl == null || portraitUrl.length <= 0) {
      portraitUrl = Constants.DEFAULT_PORTRAIT;
    }
    return CachedNetworkImage(
      width: 62,
      height: 62,
      fit: BoxFit.fill,
      imageUrl: portraitUrl,
      placeholder: (context, url) => new CircularProgressIndicator(),
      errorWidget: (context, url, error) => new Icon(Icons.error),
    );
  }

  _logOut() {
    ObjectUtil.doExit(widget.rootContext);
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
