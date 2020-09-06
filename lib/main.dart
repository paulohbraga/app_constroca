import 'package:app_constroca/providers/ProdutosProvider.dart';
import 'package:app_constroca/providers/Users.dart';
import 'package:flutter/material.dart';
import 'package:app_constroca/splash.dart';
import 'package:provider/provider.dart';

import 'constants.dart';

void main() => runApp(Constroca());

class Constroca extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => ProdutosProvider())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: APP_NAME,
        theme: ThemeData(primarySwatch: Colors.green, fontFamily: 'Raleway'),
        //routes: ,
        home: Splash(),
      ),
    );
  }
}
