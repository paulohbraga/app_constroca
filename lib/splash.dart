import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'home.dart';

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
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MyHomePage()));
    });
  }

  @override
  Widget build(BuildContext context) {

    return Container(
            color: Color.fromRGBO(133, 0, 171, 100),
            child: Center(
              child: Container(
                width: 150,
                height: 150,
                child: Image.asset("imgs/house.png"),
              ),
            )
        );
  }
}