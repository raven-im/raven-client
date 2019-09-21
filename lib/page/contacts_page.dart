import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/database/db_api.dart';
import 'package:myapp/entity/contact_entity.dart';
import 'package:myapp/page/contact_details.dart';
import 'package:myapp/page/more_widgets.dart';
import 'package:myapp/utils/constants.dart';
import 'package:myapp/utils/sp_util.dart';

/*
*  联系人
*/
class ContactsPage extends StatefulWidget {
  ContactsPage({Key key, this.rootContext}) : super(key: key);

  final BuildContext rootContext;

  @override
  State<StatefulWidget> createState() {
    return new Contacts();
  }
}

class Contacts extends State<ContactsPage> with AutomaticKeepAliveClientMixin {
  var _list = List<ContactEntity>();
  var _map = Map();
  GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return layout(context);
  }

  @override
  void initState() {
    super.initState();
    _getContacts();
  }

  _getContacts() {
    String myUid = SPUtil.getString(Constants.KEY_LOGIN_UID);
    DataBaseApi.get().getAllContactsEntities().then((entities) {
      if (entities.length > 0) {
        setState(() {
          _list.clear();

          entities.forEach((entity) {
            if (entity.userId != myUid) {
              _list.insert(0, entity);
              DataBaseApi.get()
                  .getConversationIdByUserid(entity.userId)
                  .then((convId) {
                if (convId != " ") {
                  _map[entity.userId] = convId;
                }
              });
            }
          });
        });
      }
    });
  }

  Widget layout(BuildContext context) {
    return new Scaffold(
      key: _key,
      appBar: _appBar(),
      body: ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return _itemWidget(index);
          },
          itemCount: _list.length),
    );
  }

  _appBar() {
    return MoreWidgets.buildAppBar(
      context,
      'Contacts',
      elevation: 2.0,
      actions: <Widget>[
        InkWell(
            child: Container(
                padding: EdgeInsets.only(right: 15, left: 15),
                child: Icon(
                  Icons.more_horiz,
                  size: 22,
                )),
            onTap: () {})
      ],
    );
  }

  Widget _itemWidget(int index) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            new CupertinoPageRoute<void>(
                builder: (ctx) => ContactsDetailPage(
                      targetUid: _list[index].userId,
                    )));
      },
      child: MoreWidgets.buildListViewItem(
          _list[index].portrait, _list[index].userName),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
