import 'package:app_constroca/chat_message_list.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';

import 'constants.dart';

class ChatListBody extends StatelessWidget {
  get id => null;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          resizeToAvoidBottomPadding: false,
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: APP_BAR_COLOR,
            title: Text(
              "Conversa",
              style: TextStyle(fontFamily: 'Raleway', fontWeight: FontWeight.bold),
            ),
            leading: IconButton(
              icon: Icon(FeatherIcons.arrowLeftCircle, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            flexibleSpace: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topLeft, end: Alignment.bottomRight, colors: APP_BAR_GRADIENT_COLOR))),
          ),
          body: Messages()),
    );
  }
}
