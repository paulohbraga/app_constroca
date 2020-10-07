import 'package:app_constroca/providers/ProdutosProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'constants.dart';

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
                child: RaisedButton(
                  child: Text("botao"),
                ),
              ),
            )
          : chatState.getResponseJsonMyChat() != null
              ? Center(
                  child: Container(
                    margin: EdgeInsets.all(15),
                    height: MediaQuery.of(context).size.height,
                    color: Colors.grey[300],
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: chatState.itemsMyChat.length,
                      itemBuilder: (context, index) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            // ignore: unrelated_type_equality_checks
                            chatState.getResponseJsonMyChat()[index].sender == 50
                                ? Row(
                                    children: <Widget>[
                                      Spacer(),
                                      Text(
                                        chatState.getResponseJsonMyChat()[index].sender.toString(),
                                        style: TextStyle(fontSize: 20, fontFamily: 'Raleway', color: Colors.black87),
                                      ),
                                      CircleAvatar(backgroundImage: AssetImage("assets/avatar.png")),
                                    ],
                                  )
                                : Row(
                                    children: <Widget>[
                                      CircleAvatar(backgroundImage: AssetImage("assets/avatar.png")),
                                      Text(
                                        chatState.getResponseJsonMyChat()[index].sender.toString(),
                                        style: TextStyle(fontSize: 20, fontFamily: 'Raleway', color: Colors.black87),
                                      ),
                                      Spacer(),
                                    ],
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
