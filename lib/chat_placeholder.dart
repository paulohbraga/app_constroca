import 'package:app_constroca/providers/ProdutosProvider.dart';
import 'package:app_constroca/user_chat.dart';
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

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => chatState.fetchMyChat(),
        child: chatState.isFetchingMyChat
            ? Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Center(
                    child: SpinKitDualRing(
                  size: 100.0,
                  color: Colors.blue,
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
                                  //print("Clicado"),
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => Messages()))
                                },
                                child: appData.id_usuario ==
                                        chatState.getResponseJsonMyChat()[index].receiver.toString()
                                    ? Row(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.all(15.0),
                                            child: CircleAvatar(backgroundImage: AssetImage("assets/avatar.png")),
                                          ),
                                          Text(
                                            "Recebida",
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
                : Text("fffff"),
      ),
    );
  }
}
