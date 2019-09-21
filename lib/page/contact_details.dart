import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/database/db_api.dart';
import 'package:myapp/entity/contact_entity.dart';
import 'package:myapp/utils/constants.dart';
import 'package:myapp/utils/file_util.dart';
import 'package:myapp/utils/sp_util.dart';
import 'message_page.dart';
import 'more_widgets.dart';

/*
* 用户详情页面
*/
class ContactsDetailPage extends StatefulWidget {
  const ContactsDetailPage({
    Key key,
    @required this.targetUid,
  }) : super(key: key);

  final String targetUid;

  @override
  State<StatefulWidget> createState() {
    return new _ContactDetailState();
  }
}

class _ContactDetailState extends State<ContactsDetailPage> {
  GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();
  String myUid = SPUtil.getString(Constants.KEY_LOGIN_UID);
  ContactEntity entity;
  String convId;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  _initData() {
    DataBaseApi.get().getContactsEntity(widget.targetUid).then((entity) {
      this.entity = entity;
      DataBaseApi.get().getConversationIdByUserid(entity.userId).then((convId) {
        if (convId != " ") {
          this.convId = convId;
        }
      });
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
              MoreWidgets.groupSettingListViewItem(
                  'Name', entity != null ? entity.userName : widget.targetUid,
                  textColor: Colors.black,
                  isDivider: false, onItemClick: (res) {
                // Navigator.push(
                //     context,
                //     new CupertinoPageRoute<void>(
                //         builder: (ctx) => SettingPage())
                //         );
              }),
              MoreWidgets.buildDivider(),
              MoreWidgets.groupSettingListViewItem(
                  'Mobile', entity != null ? entity.mobile : 'default',
                  textColor: Colors.black,
                  isDivider: false, onItemClick: (res) {
                _showDialog('Mobile', entity != null ? entity.mobile : '');
              }),
              MoreWidgets.buildDivider(),
              MoreWidgets.groupSettingListViewItem(
                  'Status',
                  entity != null
                      ? (entity.status == 0 ? 'Normal' : 'Abnormal')
                      : 'Normal',
                  textColor: Colors.black,
                  isDivider: false, onItemClick: (res) {
                // Navigator.push(
                //     context,
                //     new CupertinoPageRoute<void>(
                //         builder: (ctx) => SettingPage())
                //         );
              }),
              MoreWidgets.buildDivider(),
              SizedBox(height: 50),
              RaisedButton(
                textColor: Colors.white,
                color: Colors.lightBlue,
                padding: EdgeInsets.all(12.0),
                shape: new StadiumBorder(
                    side: new BorderSide(
                  style: BorderStyle.solid,
                  color: Colors.grey,
                )),
                child:
                    Text('Send Messages', style: new TextStyle(fontSize: 16.0)),
                onPressed: () {
                  Navigator.push(
                      context,
                      new CupertinoPageRoute<void>(
                          builder: (ctx) => MessagePage(
                                title: entity.userName,
                                targetUid: entity.userId,
                                targetUrl: entity.portrait,
                                convId: this.convId,
                                convType: Constants.CONVERSATION_SINGLE,
                              )));
                },
              ),
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

  void _showDialog(String title, String hint) {
    showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text(title),
            content: Card(
                elevation: 0.0,
                child: Text(hint,
                    maxLines: 1,
                    softWrap: true,
                    // overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 18.0,
                      fontStyle: FontStyle.italic,
                      decoration: TextDecoration.underline,
                      color: Colors.black,
                    ))),
            actions: <Widget>[
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        });
  }
}
