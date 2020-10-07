import 'package:app_constroca/providers/ProdutosProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:provider/provider.dart';
import 'home_bar.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();

    SystemChrome.setEnabledSystemUIOverlays([]);
    Future.delayed(Duration(seconds: 5)).then((_) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Inicio()));
      final appState = Provider.of<ProdutosProvider>(context, listen: true);
      appState.fetchData();
      appState.fetchMyChat();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [Colors.lightBlueAccent[400], Colors.indigo[900]])),
        child: FlareActor(
          'assets/logo3.flr',
          animation: 'carro',
          sizeFromArtboard: true,
          alignment: Alignment.center,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
