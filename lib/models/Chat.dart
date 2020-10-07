import 'dart:convert';

import '../Message.dart';

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
