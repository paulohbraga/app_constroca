import 'package:app_constroca/providers/MessagesProvider.dart';
import 'package:app_constroca/providers/ProdutosProvider.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import 'appdata.dart';
import 'chat_list_body.dart';
import 'chat_message_list.dart';
import 'constants.dart';

class Chat_Empty extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final chatState = Provider.of<ProdutosProvider>(context, listen: true);
    final messageState = Provider.of<MessageProvider>(context, listen: false);

    return Scaffold(
        appBar: AppBar(
            backgroundColor: APP_BAR_COLOR,
            centerTitle: true,
            title: Text(
              "Chats",
              style: TextStyle(fontFamily: 'Raleway'),
            ),
            flexibleSpace: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: <Color>[Colors.blue[800], Colors.blue])))),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: AssetImage('assets/chat.png'),
              width: 150,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Center(
                    child: Text("Faca login para bater papo com outros usuários",
                        style: TextStyle(fontFamily: 'Raleway', fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}
