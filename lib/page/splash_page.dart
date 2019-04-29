
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/page/main_page.dart';
import 'package:myapp/utils/constants.dart';
import 'package:myapp/utils/file_util.dart';
import 'package:myapp/utils/sp_util.dart';
import 'package:myapp/utils/timer_util.dart';
import 'package:rxdart/rxdart.dart';

class SplashPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _SplashPageState();
  }
}

class _SplashPageState extends State<SplashPage> {
  bool isLogin = false;
  TimerUtil _timerUtil;
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initTools();
    _checkPage();
  }

  void _initTools() async {
    await SPUtil.getInstance();
  }

  void _checkPage() {
    Observable.just(1).delay(new Duration(milliseconds: 1000)).listen((_) {
      if (SPUtil.getBool(Constants.KEY_LOGIN) != true) {
        isLogin = false;
      } else {
        isLogin = true;
      }
      _initSplash();
    });
  }

  _initSplash() {
    _timerUtil = new TimerUtil(mTotalTime: 3 * 1000);
    _timerUtil.setOnTimerTickCallback((int tick) {
      double _tick = tick / 1000;
      if (_tick == 0) {
        _goNext();
      }
    });
    _timerUtil.startCountDown();
  }

  Widget _buildSplashBg() {
    return new Image.asset(
      FileUtil.getImagePath('raven', dir: 'splash'),
      width: double.infinity,
      fit: BoxFit.fill,
      height: double.infinity,
    );
  }

  _goNext() {
    if (isLogin) {
      Navigator.pushAndRemoveUntil(context,
          new MaterialPageRoute(builder: (BuildContext context) {
        return MainPage(isShowLogin: false);
      }), (Route<dynamic> route) => false);
    } else {
      Navigator.pushAndRemoveUntil(context,
          new MaterialPageRoute(builder: (BuildContext context) {
        return MainPage(isShowLogin: true);
      }), (Route<dynamic> route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Material(
      child: _buildSplashBg(),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    if (null != _timerUtil) {
      _timerUtil.cancel();
    }
  }
}
