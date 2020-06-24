class AppData {
  static final AppData _appData = new AppData._internal();
  
  String id_usuario;  
  String avatar = 'offline.png'; 
  String nome_usuario;
  String cidade;
  String telefone; 
  String email; 
  String count_produtos; 
  
  factory AppData() {
    return _appData;
  }  
  AppData._internal();
}

final appData = AppData();