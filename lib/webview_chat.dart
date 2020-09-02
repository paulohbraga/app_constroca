import 'package:app_constroca/providers/Users.dart';
import 'package:flutter/material.dart';
import 'package:app_constroca/splash.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:provider/provider.dart';

import 'constants.dart';

void main() => runApp(Constroca());

class Constroca extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => Users())],
      child: MaterialApp(
        //routes: ,
        home: Scaffold(
          body: WebviewScaffold(
            url: "http://localhost:8080/",
            appBar: new AppBar(
              title: new Text("Widget webview"),
            ),
          ),
        ),
      ),
    );
  }
}
