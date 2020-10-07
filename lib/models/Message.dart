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
