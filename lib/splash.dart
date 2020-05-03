import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'home_widget.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();

    SystemChrome.setEnabledSystemUIOverlays([]);
    Future.delayed(Duration(seconds: 4)).then((_) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => MyApp()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Container(
        color: Colors.teal[900],
          child: new Center(
              widthFactor: 150.0,
              heightFactor: 150.0,
              child: FlareActor(
                'assets/carro.flr',
                animation: 'carro',
              )
          )
      ),
    );
  }
}
