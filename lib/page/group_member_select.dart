import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/database/db_api.dart';
import 'package:myapp/entity/contact_entity.dart';
import 'package:myapp/entity/group_entity.dart';
import 'package:myapp/entity/group_member_entity.dart';
import 'package:myapp/manager/restful_manager.dart';
import 'package:myapp/page/more_widgets.dart';
import 'package:myapp/utils/constants.dart';
import 'package:myapp/utils/dialog_util.dart';
import 'package:myapp/utils/interact_vative.dart';
import 'package:myapp/utils/sp_util.dart';

class GroupMemberSelectPage extends StatefulWidget {
  const GroupMemberSelectPage({
    Key key,
    @required this.entity,
  }) : super(key: key);

  final GroupEntity entity;

  @override
  State<StatefulWidget> createState() {
    return _MemberSelectPageState();
  }
}

class _MemberSelectPageState extends State<GroupMemberSelectPage> {
  List<ContactEntity> contactsList = new List();

  List<String> selectUserIds = new List();

  String myUid = SPUtil.getString(Constants.KEY_LOGIN_UID);

  String groupName;

  @override
  void initState() {
    super.initState();
    String myUid = SPUtil.getString(Constants.KEY_LOGIN_UID);
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
          _initMembers(widget.entity.members);
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

  _initMembers(List<String> members) {
    selectUserIds.addAll(members);
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

  void _changeGroup() async {
    List<String> delMembers = new List();
    List<String> addMembers = new List();
    selectUserIds.forEach((item) {
      if (!widget.entity.members.contains(item)) {
        addMembers.add(item);
      }
    });

    widget.entity.members.forEach((item) {
      if (!selectUserIds.contains(item)) {
        delMembers.add(item);
      }
    });
    if (delMembers.length > 0) {
      int result =
          await RestManager.get().kickGroup(widget.entity.groupId, delMembers);
      if (result != 10000) {
        DialogUtil.buildToast(
            "Failed to quit group ${widget.entity.name} . $result");
      } else {
        delMembers.forEach((member) {
          DataBaseApi.get().deleteGroupMemberInfo(GroupMemberEntity(
            member: member,
            groupId: widget.entity.groupId,
            conversationId: widget.entity.conversationId,
          ));
        });
      }
    }
    if (addMembers.length > 0) {
      int result =
          await RestManager.get().joinGroup(widget.entity.groupId, addMembers);
      if (result != 10000) {
        DialogUtil.buildToast(
            "Failed to join group ${widget.entity.name} . $result");
      } else {
        addMembers.forEach((member) {
          DataBaseApi.get().updateGroupMemberInfo(GroupMemberEntity(
            member: member,
            groupId: widget.entity.groupId,
            conversationId: widget.entity.conversationId,
          ));
        });
      }
    }
    await new Future.delayed(new Duration(milliseconds: 500));
    InteractNative.getAppEventSink().add(InteractNative.PULL_GROUP_INFO);
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
            tooltip: 'ChangeGroup',
            onPressed: () {
              _changeGroup();
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
