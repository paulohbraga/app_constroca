import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    Future.delayed(Duration(seconds: 4)).then((_){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MyApp()));
    });
  }

  @override
  Widget build(BuildContext context) {

    return Container(
            color: Colors.greenAccent[900],
            child: Center(
              child: Container(
                width: 150,
                height: 150,
                child: Image.asset("imgs/icon.png"),
              ),
            )
        );
  }
}