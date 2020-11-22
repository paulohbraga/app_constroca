import 'dart:convert';

List<ChatMessageList> chatMessageListFromJson(String str) =>
    List<ChatMessageList>.from(json.decode(str).map((x) => ChatMessageList.fromJson(x)));

String chatMessageListToJson(List<ChatMessageList> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ChatMessageList {
  ChatMessageList({
    this.mensagem,
    this.sender,
    this.receiver,
    this.avatar_sender,
    this.avatar_receiver,
    this.instant,
  });

  String mensagem;
  String sender;
  String receiver;
  String avatar_sender;
  String avatar_receiver;
  DateTime instant;

  factory ChatMessageList.fromJson(Map<String, dynamic> json) => ChatMessageList(
        mensagem: json["mensagem"],
        sender: json["sender"],
        receiver: json["receiver"],
        avatar_sender: json["avatar_sender"],
        avatar_receiver: json["avatar_receiver"],
        instant: DateTime.parse(json["instant"]),
      );

  Map<String, dynamic> toJson() => {
        "mensagem": mensagem,
        "sender": sender,
        "receiver": receiver,
        "avatar_sender": sender,
        "avatar_receiver": receiver,
        "instant": instant.toIso8601String(),
      };
}
