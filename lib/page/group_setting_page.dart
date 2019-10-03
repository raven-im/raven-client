import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/base/base_state.dart';
import 'package:myapp/database/db_api.dart';
import 'package:myapp/entity/group_entity.dart';
import 'package:myapp/manager/restful_manager.dart';
import 'package:myapp/page/group_member_select.dart';
import 'package:myapp/utils/constants.dart';
import 'package:myapp/utils/dialog_util.dart';
import 'package:myapp/utils/file_util.dart';
import 'package:myapp/utils/interact_vative.dart';
import 'package:myapp/utils/sp_util.dart';
import 'more_widgets.dart';

/*
* 群聊设置页面
*/
class GroupSettingPage extends StatefulWidget {
  const GroupSettingPage({
    Key key,
    @required this.groupId,
  }) : super(key: key);

  final String groupId;

  @override
  State<StatefulWidget> createState() {
    return new _GroupSettingState();
  }
}

class _GroupSettingState extends BaseState<GroupSettingPage> {
  GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();
  String myUid = SPUtil.getString(Constants.KEY_LOGIN_UID);
  String groupOwner;
  bool isOwner = false;
  GroupEntity entity;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  _initData() {
    DataBaseApi.get().getGroupEntity(widget.groupId).then((entity) {
      this.entity = entity;
      isOwner = entity.groupOwner == myUid;
      DataBaseApi.get().getContactsEntity(entity.groupOwner).then((entity) {
        groupOwner = entity.userName;
        if (this.mounted) {
          setState(() {});
        }
      });
      if (this.mounted) {
        setState(() {});
      }
    });
  }

  _quitGroup() async {
    List<String> members = new List();
    members.add(myUid);

    int result =
        await RestManager.get().quitGroup(entity.groupId);
    if (result != 10000) {
      DialogUtil.buildToast(
          "Failed to quit group ${entity.name} . $result");
    }
    await new Future.delayed(new Duration(milliseconds: 500));
    InteractNative.getAppEventSink().add(InteractNative.PULL_GROUP_INFO);
    Navigator.pop(context);
  }

  _dissmissGroup() async {
    int result = await RestManager.get().dismissGroup(entity.groupId);
    if (result != 10000) {
      DialogUtil.buildToast(
          "Failed to dismiss group ${entity.name} . $result");
    }
    await new Future.delayed(new Duration(milliseconds: 500));
    InteractNative.getAppEventSink().add(InteractNative.PULL_GROUP_INFO);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new MaterialApp(
        theme: ThemeData(platform: TargetPlatform.android),
        home: new Scaffold(
          key: _key,
          backgroundColor: Colors.white,
          primary: true,
          body: SafeArea(
              child: ListView(
            children: <Widget>[
              SizedBox(height: 40.0),
              new Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: new Image.asset(
                      FileUtil.getImagePath('raven',
                          dir: 'splash'), //TODO widget.entity.portrait,
                      height: 150.0,
                      width: 150.0),
                ),
              ),
              SizedBox(height: 10),
              MoreWidgets.buildDivider(),
              MoreWidgets.groupSettingListViewItem(
                  'Group Name', entity != null ? entity.name : 'Group',
                  textColor: Colors.black,
                  isDivider: false, onItemClick: (res) {
                // Navigator.push(
                //     context,
                //     new CupertinoPageRoute<void>(
                //         builder: (ctx) => SettingPage())
                //         );
              }),
              MoreWidgets.buildDivider(),
              MoreWidgets.groupSettingListViewItem('Group Owner',
                  groupOwner == null ? (entity != null ? entity.groupOwner: 'Owner') : groupOwner,
                  textColor: Colors.black,
                  isDivider: false, onItemClick: (res) {
                // Navigator.push(
                //     context,
                //     new CupertinoPageRoute<void>(
                //         builder: (ctx) => SettingPage())
                //         );
              }),
              MoreWidgets.buildDivider(),
              MoreWidgets.defaultListViewItem(null, 'Member Managment',
                  textColor: Colors.black,
                  isDivider: false, onItemClick: (res) {
                Navigator.push(
                    context,
                    new CupertinoPageRoute<void>(
                        builder: (ctx) => GroupMemberSelectPage(
                              entity: entity,
                            )));
              }),
              MoreWidgets.buildDivider(),
              SizedBox(height: 50),
              RaisedButton(
                textColor: Colors.white,
                color: Colors.redAccent,
                padding: EdgeInsets.all(12.0),
                shape: new StadiumBorder(
                    side: new BorderSide(
                  style: BorderStyle.solid,
                  color: Colors.grey,
                )),
                child: Text(isOwner ? 'Dismiss' : 'Quit',
                    style: new TextStyle(fontSize: 16.0)),
                onPressed: () {
                  if (isOwner) {
                    _dissmissGroup();
                  } else {
                    _quitGroup();
                  }
                },
              ),
            ],
          )),
          appBar: MoreWidgets.buildAppBar(
            context,
            'Group (${entity != null ? entity.members.length : 0})',
            centerTitle: true,
            elevation: 2.0,
            leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                }),
          ),
        ));
  }

  @override
  void notify(Object type) {
    if (type == InteractNative.PULL_GROUP_INFO) {
      _initData();
    }
  }
}
