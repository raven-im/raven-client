import 'package:flutter/material.dart';
import 'package:myapp/page/contacts_page.dart';
import 'package:myapp/page/message_page.dart';
import 'package:myapp/utils/constants.dart';

/*
*  主页
*/
class MainPage extends StatelessWidget {


  MainPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyHomePage();
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _pageController = new PageController(initialPage: 0);
  int _tabIndex = 0;
  var appBarTitles = ['Messages', 'Contacts'];
  List _pageList;

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
      new ContactsPage(rootContext: context)
    ];
  }

  @override
  void initState() {
    super.initState();
    initData();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
            // primaryColor: primaryColor,
            // primarySwatch: primarySwatch,
            platform: TargetPlatform.android),
        
        home: new Scaffold(
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
                          color: _tabIndex == 0 ? Colors.grey : null,
                        ),
                        title: getTabTitle(0)),
                    new BottomNavigationBarItem(
                        icon: new Icon(
                          _tabIndex == 1 ? Icons.favorite : Icons.favorite_border,
                          color: _tabIndex == 1 ? Colors.grey : null,
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
                  },
                )
              ),
          );
  }

  void _pageChange(int index) {
    Constants.currentPage = index;
    setState(() {
      if (_tabIndex != index) {
        _tabIndex = index;
      }
    });
  }

  _backPress() {
    // TODO
  }
}
