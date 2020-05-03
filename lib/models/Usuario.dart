// To parse this JSON data, do
//
//     final usuario = usuarioFromJson(jsonString);
import 'dart:async';

import 'dart:convert';

Usuario usuarioFromJson(String str) => Usuario.fromJson(json.decode(str));

String usuarioToJson(Usuario data) => json.encode(data.toJson());

class Usuario {
    String nome;
    String loginUsuario;
    String email;
    String telefone;
    String cidade;
    String senha;

    Usuario({
        this.nome,
        this.loginUsuario,
        this.email,
        this.telefone,
        this.cidade,
        this.senha,
    });

    factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
        nome: json["nome"],
        loginUsuario: json["login_usuario"],
        email: json["email"],
        telefone: json["telefone"],
        cidade: json["cidade"],
        senha: json["senha"],
    );

    Map<String, dynamic> toJson() => {
        "nome": nome,
        "login_usuario": loginUsuario,
        "email": email,
        "telefone": telefone,
        "cidade": cidade,
        "senha": senha,
    };
}
