import 'package:flutter/material.dart';

import 'constants.dart';

class MyProducts extends StatelessWidget {
  final String id;

  MyProducts({Key key, @required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Recuperar senha',
      home: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          backgroundColor: APP_BAR_COLOR,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            "Meus produtos",
            style: TextStyle(fontFamily: 'Raleway', fontWeight: FontWeight.bold),
          ),
          flexibleSpace: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft, end: Alignment.bottomRight, colors: APP_BAR_GRADIENT_COLOR))),
        ),
        body: Center(
          child: Text('Criar aqui: ' + id + '...'),
        ),
      ),
    );
  }
}
