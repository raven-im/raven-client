import 'package:flutter/material.dart';
import 'package:myapp/database/db_api.dart';
import 'package:myapp/page/main_page.dart';
import 'package:myapp/page/splash_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    DataBaseApi.get().getAllContactsEntities();
    return MaterialApp(home: new SplashPage(), routes: {
      '/MainPage': (ctx) => MainPage(),
    });
  }
}
