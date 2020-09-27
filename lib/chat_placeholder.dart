import 'package:flutter/material.dart';

import 'constants.dart';

class Chat_Placeholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chat',
      home: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          backgroundColor: APP_BAR_COLOR,
          title: Text(
            "Chat",
            style: TextStyle(fontFamily: 'Raleway', fontWeight: FontWeight.bold),
          ),
          flexibleSpace: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft, end: Alignment.bottomRight, colors: APP_BAR_GRADIENT_COLOR))),
        ),
        body: Center(
          child: Text('Voce precisa logar para ter acesso ao chat'),
        ),
      ),
    );
  }
}
