import 'package:flutter/material.dart';
import 'package:myapp/base/base_state.dart';
import 'package:myapp/database/db_api.dart';
import 'package:myapp/entity/message_entity.dart';
import 'package:myapp/manager/contacts_manager.dart';
import 'package:myapp/manager/sender_manager.dart';
import 'package:myapp/page/contacts_page.dart';
import 'package:myapp/page/conversation_page.dart';
import 'package:myapp/page/login_page.dart';
import 'package:myapp/utils/constants.dart';
import 'package:myapp/utils/interact_vative.dart';
import 'package:myapp/utils/sp_util.dart';

/*
*  主页
*/
class MainPage extends StatelessWidget {

  final bool isShowLogin;
  MainPage({Key key, this.isShowLogin}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return MyHomePage(isShowLogin: isShowLogin);
  }
}

class MyHomePage extends StatefulWidget {
  final bool isShowLogin;
  MyHomePage({Key key, this.isShowLogin}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends BaseState<MyHomePage> {
  var _pageController = new PageController(initialPage: 0);
  int _tabIndex = 0;
  var appBarTitles = ['Conversations', 'Contacts'];
  List _pageList;
  bool _isShowLogin;

  /*
   * 获取bottomTab的颜色和文字
   */
  Text getTabTitle(int curIndex) {
    if (curIndex == _tabIndex) {
      return new Text(appBarTitles[curIndex],
          style: new TextStyle(fontSize: 12.0, color: Colors.indigo));
    } else {
      return new Text(appBarTitles[curIndex],
          style: new TextStyle(fontSize: 12.0, color: Colors.grey));
    }
  }
  
  void initData() {
    /*
     * 2个子界面
     */
    _pageList = [
      new ConversationPage(rootContext: context),
      new ContactsPage(rootContext: context),
    ];

    String myUid = SPUtil.getString(Constants.KEY_LOGIN_UID);
    SenderMngr.init();

    // request Contacts.
    if (myUid != null) {
      ContactManager.get().getContactsEntity(myUid).then((entities) {
        entities.forEach((entity) {
          DataBaseApi.get().updateContactsEntity(entity);
        });
      });
    }
  }

  @override
  void initState() {
    super.initState();
    initData();
    _isShowLogin = widget.isShowLogin;
  }

  @override
  void dispose() {
    _pageController.dispose();
    SenderMngr.release();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
            // primaryColor: primaryColor,
            // primarySwatch: primarySwatch,
            platform: TargetPlatform.android),
        
        
        home: Stack(children: <Widget>[
          Offstage(offstage: !_isShowLogin, child: LoginPage()),
          Offstage(
              offstage: _isShowLogin,
              child: new Scaffold(
                body: new PageView.builder(
                  onPageChanged: _pageChange,
                  controller: _pageController,
                  itemBuilder: (BuildContext context, int index) {
                    return _pageList[index];
                  },
                  itemCount: 2,
                ),
                bottomNavigationBar: new BottomNavigationBar(
                  items: <BottomNavigationBarItem>[
                    new BottomNavigationBarItem(
                        icon: new Icon(
                          Icons.message,
                          color: _tabIndex == 0 ? Colors.blueGrey : null,
                        ),
                        title: getTabTitle(0)),
                    new BottomNavigationBarItem(
                        icon: new Icon(
                          Icons.contacts,
                          color: _tabIndex == 1 ? Colors.blueGrey : null,
                        ),
                        title: getTabTitle(1)),
                  ],
                  type: BottomNavigationBarType.fixed,
                  //默认选中首页
                  currentIndex: _tabIndex,
                  iconSize: 22.0,
                  //点击事件
                  onTap: (index) {
                    _pageController.jumpToPage(index);
                    if (_tabIndex == 0) {
                      InteractNative.getAppEventSink().add(InteractNative.PULL_CONVERSATION);
                    }
                  },
                )
              ),
          )]));
  }

  void _pageChange(int index) {
    Constants.currentPage = index;
    setState(() {
      if (_tabIndex != index) {
        _tabIndex = index;
      }
    });
  }

  @override
  void notify(Object type) {
  if (type == InteractNative.CHANGE_PAGE_TO_MAIN) {
    setState(() {
      if (null != _pageList) {
        _pageList.clear();
        initData();
      } else {
        initData();
      }
      _isShowLogin = false;
    });
  } else if (type == InteractNative.CHANGE_PAGE_TO_LOGIN) {
      setState(() {
        _isShowLogin = true;
      });
    }
  }

  @override
  void updateData(MessageEntity entity) {
    
  }
}
