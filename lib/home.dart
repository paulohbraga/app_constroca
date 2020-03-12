import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'constants.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    var num = 0;
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text("Doações"),
          centerTitle: true,
          backgroundColor: Colors.teal[900],
        ),
        body: Container(
          padding: EdgeInsets.all(16.0),
          child: GridView.count(
          crossAxisCount: 3,
          crossAxisSpacing: 4.0,
          mainAxisSpacing: 8.0,
          children: <Widget>[
            Image.network("https://placeimg.com/500/500/any"),
            Image.network("https://placeimg.com/500/500/any"),
            Image.network("https://placeimg.com/500/500/any"),
            Image.network("https://placeimg.com/500/500/any"),
            Image.network("https://placeimg.com/500/500/any"),
            Image.network("https://placeimg.com/500/500/any"),
            Image.network("https://placeimg.com/500/500/any"),
            Image.network("https://placeimg.com/500/500/any"),
            Image.network("https://placeimg.com/500/500/any"),
            Image.network("https://placeimg.com/500/500/any"),
            Image.network("https://placeimg.com/500/500/any"),
            Image.network("https://placeimg.com/500/500/any"),
            Image.network("https://placeimg.com/500/500/any"),
            Image.network("https://placeimg.com/500/500/any"),
            Image.network("https://placeimg.com/500/500/any"),
            Image.network("https://placeimg.com/500/500/any"),
          ],
        )),
      ),
    );
  }
}
