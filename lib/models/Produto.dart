import 'Usuario.dart';

class Produto {
  Produto({
    this.id_produto,
    this.nomeProduto,
    this.descricao,
    this.status,
    this.tipo,
    this.imagem,
    this.usuario,
  });

  int id_produto;
  String nomeProduto;
  String descricao;
  String status;
  String tipo;
  String imagem;
  Usuario usuario;

  factory Produto.fromJson(Map<String, dynamic> json) => Produto(
        id_produto: json["id_produto"],
        nomeProduto: json["nome_produto"],
        descricao: json["descricao"],
        status: json["status"],
        tipo: json["tipo"],
        imagem: json["imagem"],
        usuario: Usuario.fromJson(json["usuario"]),
      );

  Map<String, dynamic> toJson() => {
        "id_produto": id_produto,
        "nome_produto": nomeProduto,
        "descricao": descricao,
        "status": status,
        "tipo": tipo,
        "imagem": imagem,
        "usuario": usuario.toJson(),
      };
}
