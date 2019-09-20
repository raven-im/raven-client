import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/database/db_api.dart';
import 'package:myapp/entity/contact_entity.dart';
import 'package:myapp/entity/rest_entity.dart';
import 'package:myapp/manager/restful_manager.dart';
import 'package:myapp/page/more_widgets.dart';
import 'package:myapp/utils/constants.dart';
import 'package:myapp/utils/dialog_util.dart';
import 'package:myapp/utils/sp_util.dart';

class ContactsSelectPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ContactsSelectPageState();
  }
}

class _ContactsSelectPageState extends State<ContactsSelectPage> {
  List<ContactEntity> contactsList = new List();

  List<String> selectUserIds = new List();

  String myUid = SPUtil.getString(Constants.KEY_LOGIN_UID);

  String groupName;

  @override
  void initState() {
    super.initState();
    String myUid = SPUtil.getString(Constants.KEY_LOGIN_UID);
    //for Group chat,  list index 0 used as the Group owner.
    selectUserIds.add(myUid);
    _getContacts(myUid);
  }

  _getContacts(String exceptUid) {
    DataBaseApi.get().getAllContactsEntities().then((entities) {
      if (entities.length > 0) {
        setState(() {
          contactsList.clear();
          entities.forEach((entity) {
            if (entity.userId != exceptUid) {
              contactsList.insert(0, entity);
            }
          });
        });
      }
    });
  }

  _selectUser(int index) {
    String userId = contactsList[index].userId;
    if (selectUserIds.contains(userId)) {
      selectUserIds.remove(userId);
    } else {
      selectUserIds.add(userId);
    }
    setState(() {});
  }

  Widget _buildWidget(int index) {
    Widget image = Image.asset('assets/images/contacts_normal.png');
    if (selectUserIds.contains(contactsList[index].userId)) {
      image = Image.asset('assets/images/contacts_selected.png');
    }
    return Container(
      child: InkWell(
        onTap: () {
          _selectUser(index);
        },
        child: Row(
          children: <Widget>[
            Container(
              width: 30,
              height: 30,
              child: image,
            ),
            Expanded(
              child: MoreWidgets.buildListViewItem(
                  contactsList[index].portrait, contactsList[index].userName),
            )
          ],
        ),
      ),
    );
  }

  void _showGroupNameDialog() {
    showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text('Group Name'),
            content: Card(
              elevation: 0.0,
              child: Column(
                children: <Widget>[
                  // Text('this is a message'),
                  TextField(
                    maxLength: 20,
                    decoration: InputDecoration(
                        hintText: 'Please input group name',
                        filled: true,
                        fillColor: Colors.grey.shade50),
                    onChanged: (String text) {
                      groupName = text;
                    },
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel'),
              ),
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.pop(context);
                  _createGroup();
                },
                child: Text('OK'),
              ),
            ],
          );
        });
  }

  void _createGroup() async {
    RestEntity entity = await RestManager.get().createGroup(
        groupName,
        "https://b-ssl.duitang.com/uploads/item/201805/13/20180513224039_tgfwu.png",
        selectUserIds);
    print("create result :" + entity.toMap().toString());
    if (entity.code != 10000) {
      DialogUtil.buildToast("Failed to create group $groupName . ${entity.code}");
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Member"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.done),
            tooltip: 'CreateGroup',
            onPressed: () {
              _showGroupNameDialog();
            },
          )
        ],
      ),
      body: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: contactsList.length,
        itemBuilder: (BuildContext context, int index) {
          if (contactsList.length <= 0) {
            return Container();
          }
          return _buildWidget(index);
        },
      ),
    );
  }
}
