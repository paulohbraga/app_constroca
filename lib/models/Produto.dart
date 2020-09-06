import 'Usuario.dart';
import 'dart:convert';

class Produto {
  Produto({
    this.id,
    this.nomeProduto,
    this.descricaoProduto,
    this.status,
    this.tipo,
    this.imagem,
    this.usuario,
  });

  String id;
  String nomeProduto;
  String descricaoProduto;
  String status;
  String tipo;
  String imagem;
  Usuario usuario;

  factory Produto.fromJson(Map<String, dynamic> json) => Produto(
        id: json["id"],
        nomeProduto: json["nome_produto"],
        descricaoProduto: json["descricao_produto"],
        status: json["status"],
        tipo: json["tipo"],
        imagem: json["imagem"],
        usuario: Usuario.fromJson(json["usuario"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nome_produto": nomeProduto,
        "descricao_produto": descricaoProduto,
        "status": status,
        "tipo": tipo,
        "imagem": imagem,
        "usuario": usuario.toJson(),
      };
}
