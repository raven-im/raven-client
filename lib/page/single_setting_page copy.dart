import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/database/db_api.dart';
import 'package:myapp/entity/contact_entity.dart';
import 'package:myapp/utils/constants.dart';
import 'package:myapp/utils/file_util.dart';
import 'package:myapp/utils/sp_util.dart';
import 'more_widgets.dart';

/*
* 单聊设置页面
*/
class SingleSettingPage extends StatefulWidget {
  const SingleSettingPage({
    Key key,
    @required this.targetUid,
  }) : super(key: key);

  final String targetUid;

  @override
  State<StatefulWidget> createState() {
    return new _SingleSettingState();
  }
}

class _SingleSettingState extends State<SingleSettingPage> {
  GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();
  String myUid = SPUtil.getString(Constants.KEY_LOGIN_UID);
  ContactEntity entity;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  _initData() {
    DataBaseApi.get().getContactsEntity(widget.targetUid).then((entity) {
      this.entity = entity;
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
                      entity == null || entity.portrait == null
                          ? FileUtil.getImagePath('raven', dir: 'splash')
                          : entity.portrait,
                      height: 150.0,
                      width: 150.0),
                ),
              ),
              SizedBox(height: 10),
              MoreWidgets.buildDivider(),
              MoreWidgets.groupSettingListViewItem('Contact Name',
                  entity != null ? entity.userName : widget.targetUid,
                  textColor: Colors.black,
                  isDivider: false, onItemClick: (res) {
                // Navigator.push(
                //     context,
                //     new CupertinoPageRoute<void>(
                //         builder: (ctx) => SettingPage())
                //         );
              }),
              MoreWidgets.buildDivider(),
              MoreWidgets.groupSettingListViewItem('Chat Alias',
                  entity != null ? entity.userName : widget.targetUid,
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
            'Details',
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
