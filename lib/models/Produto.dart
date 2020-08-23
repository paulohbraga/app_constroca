import 'Usuario.dart';

class Produto {
  Produto({
    this.id,
    this.nomeProduto,
    this.descricao,
    this.status,
    this.tipo,
    this.imagem,
    this.usuario,
  });

  int id;
  String nomeProduto;
  String descricao;
  String status;
  String tipo;
  String imagem;
  Usuario usuario;

  factory Produto.fromJson(Map<String, dynamic> json) => Produto(
        id: json["id"],
        nomeProduto: json["nome_produto"],
        descricao: json["descricao"],
        status: json["status"],
        tipo: json["tipo"],
        imagem: json["imagem"],
        usuario: Usuario.fromJson(json["usuario"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nome_produto": nomeProduto,
        "descricao": descricao,
        "status": status,
        "tipo": tipo,
        "imagem": imagem,
        "usuario": usuario.toJson(),
      };
}
