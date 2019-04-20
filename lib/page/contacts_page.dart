import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/base/base_state.dart';
import 'package:myapp/entity/message_entity.dart';
import 'package:myapp/manager/contacts_manager.dart';
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

class Contacts extends BaseState<ContactsPage> with AutomaticKeepAliveClientMixin {
  var _list = List();
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
    String myUid = SPUtil.getString(Constants.KEY_LOGIN_ACCOUNT);
    ContactManager.get().getContactsEntity(myUid).then((entities) async {
      if (entities.length > 0) {
        setState(() {
          _list.clear();
          _map.clear();

          entities.forEach((entity) {
              _list.insert(0, entity.userName);
              _map[entity.userId] = entity;
          });
        });
      }
    });
    // InteractNative.goNativeWithValue(
    //         InteractNative.methodNames['getAllContacts'], null)
    //     .then((success) {
    //   if (null != success && success is List) {
    //     InteractNative.goNativeWithValue(
    //             InteractNative.methodNames['getBlackListUsernames'], null)
    //         .then((blackList) {
    //       setState(() {
    //         for (String ms in success) {
    //           if (!_list.contains(ms)) {
    //             _list.add(ms);
    //           }
    //         }
    //         if (null != blackList && blackList is List) {
    //           _blackList.clear();
    //           for (String ms in blackList) {
    //             if (!_blackList.contains(ms)) {
    //               _blackList.add(ms);
    //             }
    //           }
    //         }
    //       });
    //     });
    //   }
    // });
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
                      title: _list[index],
                      senderAccount: _list[index],
                    )));
      },
      
      child: MoreWidgets.buildListViewItem('img_headportrait', _list[index]),
    );
  
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void updateData(MessageEntity entity) {
    if (entity != null &&
        entity.type == Constants.MESSAGE_TYPE_CHAT) {
      _list.remove(entity.senderAccount);
      _getContacts();
    }
  }
}
