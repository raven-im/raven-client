import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/database/db_api.dart';
import 'package:myapp/entity/group_entity.dart';
import 'package:myapp/utils/file_util.dart';
import 'more_widgets.dart';

/*
* 群聊设置页面
*/
class GroupSettingPage extends StatefulWidget {
  const GroupSettingPage({
    Key key,
    @required this.entity,
  }) : super(key: key);

  final GroupEntity entity;

  @override
  State<StatefulWidget> createState() {
    return new _GroupSettingState();
  }
}

class _GroupSettingState extends State<GroupSettingPage> {
  GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();
  String groupOwner;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  _initData() {
    DataBaseApi.get()
        .getContactsEntity(widget.entity.groupOwner)
        .then((entity) {
      groupOwner = entity.userName;
      if (this.mounted) {
        setState(() {});
      }
    });
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
                      height: 120.0,
                      width: 120.0),
                ),
              ),
              SizedBox(height: 10),
              new Center(
                  child: Text(
                widget.entity.name,
                maxLines: 1,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 22.0, color: Colors.black),
              )),
              MoreWidgets.buildDivider(),
              MoreWidgets.groupSettingListViewItem(
                  'Group Name', widget.entity.name,
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
                  groupOwner == null ? widget.entity.groupOwner : groupOwner,
                  textColor: Colors.black,
                  isDivider: false, onItemClick: (res) {
                // Navigator.push(
                //     context,
                //     new CupertinoPageRoute<void>(
                //         builder: (ctx) => SettingPage())
                //         );
              }),
              MoreWidgets.buildDivider(),
            ],
          )),
          appBar: MoreWidgets.buildAppBar(
            context,
            'Group (${widget.entity.members.length})',
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
}
