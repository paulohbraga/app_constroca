class Usuario {
  Usuario({
    this.id,
    this.nome,
    this.loginUsuario,
    this.email,
    this.cpf,
    this.telefone,
    this.cidade,
    this.logado,
    this.avatar,
  });

  int id;
  String nome;
  String loginUsuario;
  String email;
  String cpf;
  int telefone;
  String cidade;
  int logado;
  String avatar;

  factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
        id: json["id"],
        nome: json["nome"],
        loginUsuario: json["login_usuario"],
        email: json["email"],
        cpf: json["cpf"],
        telefone: json["telefone"],
        cidade: json["cidade"],
        logado: json["logado"],
        avatar: json["avatar"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nome": nome,
        "login_usuario": loginUsuario,
        "email": email,
        "cpf": cpf,
        "telefone": telefone,
        "cidade": cidade,
        "logado": logado,
        "avatar": avatar,
      };
}
