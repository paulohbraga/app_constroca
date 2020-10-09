import 'dart:convert';
import 'package:app_constroca/appdata.dart';
import 'package:app_constroca/chat_message_list.dart';
import 'package:app_constroca/providers/ProdutosProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class UserChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final chatState = Provider.of<ProdutosProvider>(context, listen: true);

    return RefreshIndicator(
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
                              child: appData.id_usuario == chatState.getResponseJsonMyChat()[index].receiver.toString()
                                  ? Row(
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.all(15.0),
                                          child: CircleAvatar(backgroundImage: AssetImage("assets/avatar.png")),
                                        ),
                                        Text(
                                          "Recebida",
                                          style: TextStyle(fontSize: 18, fontFamily: 'Raleway', color: Colors.black87),
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
    );
  }
}

Chat chatFromJson(String str) => Chat.fromJson(json.decode(str));

String chatToJson(Chat data) => json.encode(data.toJson());

class Chat {
  Chat({
    this.id,
    this.sender,
    this.receiver,
    this.mensagens,
  });

  int id;
  int sender;
  int receiver;
  List<Mensagen> mensagens;

  factory Chat.fromJson(Map<String, dynamic> json) => Chat(
        id: json["id"],
        sender: json["sender"],
        receiver: json["receiver"],
        mensagens: List<Mensagen>.from(json["mensagens"].map((x) => Mensagen.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "sender": sender,
        "receiver": receiver,
        "mensagens": List<dynamic>.from(mensagens.map((x) => x.toJson())),
      };
}

class Mensagen {
  Mensagen({
    this.mensagem,
    this.sender,
    this.receiver,
    this.instant,
  });

  String mensagem;
  int sender;
  int receiver;
  DateTime instant;

  factory Mensagen.fromJson(Map<String, dynamic> json) => Mensagen(
        mensagem: json["mensagem"],
        sender: json["sender"],
        receiver: json["receiver"],
        instant: DateTime.parse(json["instant"]),
      );

  Map<String, dynamic> toJson() => {
        "mensagem": mensagem,
        "sender": sender,
        "receiver": receiver,
        "instant": instant.toIso8601String(),
      };
}
