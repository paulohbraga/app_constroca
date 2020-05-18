import 'package:flutter/material.dart';
import 'package:app_constroca/splash.dart';

import 'constants.dart';

void main() => runApp(Constroca());

class Constroca extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: APP_NAME,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: Splash(),
    );
  }
}