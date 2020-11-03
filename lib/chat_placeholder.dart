import 'package:app_constroca/providers/MessagesProvider.dart';
import 'package:app_constroca/providers/ProdutosProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import 'appdata.dart';
import 'chat_list_body.dart';
import 'chat_message_list.dart';
import 'constants.dart';

class Chat_Placeholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final chatState = Provider.of<ProdutosProvider>(context, listen: true);
    final messageState = Provider.of<MessageProvider>(context, listen: true);

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
      body: RefreshIndicator(
        onRefresh: () => chatState.fetchMyChat(),
        child: chatState.isFetchingMyChat
            ? Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Center(
                    child: SpinKitDualRing(
                  size: 100.0,
                  color: Colors.transparent,
                )),
              )
            : chatState.getResponseJsonMyChat() != null
                ? Center(
                    child: Container(
                      margin: EdgeInsets.all(15),
                      height: MediaQuery.of(context).size.height,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: chatState.itemsMyChat.length,
                        itemBuilder: (context, index) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              InkWell(
                                splashColor: Colors.amber,
                                onTap: () => {
                                  messageState.fetchMessages(chatState.getResponseJsonMyChat()[index].id),
                                  appData.chat_id = chatState.getResponseJsonMyChat()[index].id,
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => Messages()))
                                },
                                child: chatState.getResponseJsonMyChat()[index].receiver.toString() ==
                                            appData.id_usuario ||
                                        chatState.getResponseJsonMyChat()[index].sender.toString() == appData.id_usuario
                                    ? Row(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.all(15.0),
                                            child: CircleAvatar(backgroundImage: AssetImage("assets/avatar.png")),
                                          ),
                                          Text(
                                            chatState.getResponseJsonMyChat()[index].receiver.toString() ==
                                                    appData.id_usuario
                                                ? chatState.getResponseJsonMyChat()[index].mensagens[0].name_sender
                                                : chatState.getResponseJsonMyChat()[index].mensagens[0].name_receiver,
                                            style:
                                                TextStyle(fontSize: 18, fontFamily: 'Raleway', color: Colors.black87),
                                          ),
                                        ],
                                      )
                                    : Text(""),
                              )
                            ],
                          );
                        },
                      ),
                    ),
                  )
                : Text("Você deve estar logado para ter acesso ao chat"),
      ),
    );
  }
}
