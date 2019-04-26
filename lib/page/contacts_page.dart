import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/database/contacts_db.dart';

import 'package:myapp/entity/contact_entity.dart';
import 'package:myapp/page/message_page.dart';
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
    ContactsDataBase.get().getAllContactsEntities().then((entities) {
      if (entities.length > 0) {
        setState(() {
          _list.clear();
          _map.clear();

          entities.forEach((entity) {
            if (entity.userId != myUid) {
              _list.insert(0, entity);
              _map[entity.userId] = entity;
            }
          });
        });
      }
    });
  }

  Widget layout(BuildContext context) {
    return new Scaffold(
      key: _key,
      appBar: MoreWidgets.buildAppBar(context, 'Contacts'),
      body: ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return _itemWidget(index);
          },
          itemCount: _list.length),
    );
  }

  Widget _itemWidget(int index) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            new CupertinoPageRoute<void>(
                builder: (ctx) => MessagePage(
                      title: _list[index].userName,
                      targetUid: _list[index].userId,
                      convId: "TODO", //TODO  get convId from My & Target.
                    )));
      },
      
      child: MoreWidgets.buildListViewItem('img_headportrait', _list[index].userName),
    );
  
  }

  @override
  bool get wantKeepAlive => true;
}
