class Mensagen {
  Mensagen({
    this.mensagem,
    this.sender,
    this.receiver,
    this.name_sender,
    this.name_receiver,
    this.avatar_sender,
    this.avatar_receiver,
    this.instant,
  });

  String mensagem;
  String sender;
  String receiver;
  String name_sender;
  String name_receiver;
  String avatar_sender;
  String avatar_receiver;
  DateTime instant;

  factory Mensagen.fromJson(Map<String, dynamic> json) => Mensagen(
        mensagem: json["mensagem"],
        sender: json["sender"],
        receiver: json["receiver"],
        name_sender: json["name_sender"],
        name_receiver: json["name_receiver"],
        avatar_sender: json["avatar_sender"],
        avatar_receiver: json["avatar_receiver"],
        instant: DateTime.parse(json["instant"]),
      );

  Map<String, dynamic> toJson() => {
        "mensagem": mensagem,
        "sender": sender,
        "receiver": receiver,
        "name_sender": name_sender,
        "name_receiver": name_receiver,
        "avatar_sender": avatar_sender,
        "avatar_receiver": avatar_receiver,
        "instant": instant.toIso8601String(),
      };
}
