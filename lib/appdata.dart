class AppData {
  static final AppData _appData = new AppData._internal();

  String id_usuario;
  String avatar = 'offline.png';
  String nome_usuario;
  String cidade;
  String telefone;
  String email;
  dynamic message;

  //Update Product

  String produto_id_edit = "";
  String produto_nome_edit = "";
  String produto_desc_edit = "";
  String produto_tipo_edit = "";
  String produto_image_edit = "";

  // Product data
  String count_produtos;
  String id_produto = "";
  String name_produto = "";
  String img_produto = "";
  String descricao_produto = "";
  String email_client;
  String avatar_client;
  String telefone_client;
  int chat_id = null;
  int usuario_p_owner;

  factory AppData() {
    return _appData;
  }
  AppData._internal();
}

final appData = AppData();
