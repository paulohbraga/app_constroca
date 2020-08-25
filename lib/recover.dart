import 'package:flutter/material.dart';

class Recover extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Recuperar senha',
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text('Recuperar Senha'),
        ),
        body: Center(
          child: Text('Nova tela'),
        ),
      ),
    );
  }
}
