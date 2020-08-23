import 'dart:async';
import 'dart:convert';
import 'package:app_constroca/perfil.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:progress_indicators/progress_indicators.dart';
import 'package:transparent_image/transparent_image.dart';
import 'appdata.dart';
import 'constants.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'detalhaProduto.dart';
import 'login.dart';
import 'perfil.dart';

Future<List<Produto>> fetchProdutos(http.Client client) async {
  final response = await client.get('http://localhost:8080/produtos/');

  // Use the compute function to run parsePhotos in a separate isolate
  return compute(parseProdutos, response.body);
}

// A function that will convert a response body into a List<Photo>
List<Produto> parseProdutos(String str) => List<Produto>.from(json.decode(str).map((x) => Produto.fromJson(x)));

String produtoToJson(List<Produto> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

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

class MyApp extends StatelessWidget {
  final appData = AppData();

  @override
  Widget build(BuildContext context) {
    final appTitle = 'Troca';

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: appTitle,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;

  MyHomePage({
    Key key,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomInset: true,
      backgroundColor: Colors.blue[900],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: APP_BAR_COLOR,
        title: Text(
          "Trocas",
          style: TextStyle(fontFamily: 'Raleway', fontWeight: FontWeight.bold),
        ),
        flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft, end: Alignment.bottomRight, colors: APP_BAR_GRADIENT_COLOR))),
      ),
      body: Padding(
        child: FutureBuilder<List<Produto>>(
          future: buildFetchProdutos(),
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);

            return snapshot.hasData
                ? ProdutosList(produtos: snapshot.data)
                : Center(
                    child: SpinKitDualRing(
                    size: 100.0,
                    color: Colors.white,
                  ));
          },
        ),
        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      ),
    );
  }

  Future<List<Produto>> buildFetchProdutos() => fetchProdutos(http.Client());
}

class ProdutosList extends StatelessWidget {
  final List<Produto> produtos;

  ProdutosList({Key key, this.produtos}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      width: MediaQuery.of(context).size.height,
      child: ListView.builder(
        itemCount: produtos.length,
        itemBuilder: (context, index) {
          return Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    // image: DecorationImage(
                    //     image: AssetImage("imgs/5.jpg"), fit: BoxFit.cover)
                  ),
                  //constraints: BoxConstraints.expand(
                  //   height: MediaQuery.of(context).size.height - 120),
                  alignment: Alignment.center,
                  child: InkWell(
                    onTap: () => {
                      Navigator.push(
                          context,
                          PageRouteBuilder(
                              transitionDuration: Duration(milliseconds: 400),
                              pageBuilder: (_, __, ___) => MyHomePageDetail(
                                  produtos[index].descricao,
                                  produtos[index].id.toString(),
                                  produtos[index].nomeProduto,
                                  produtos[index].imagem,
                                  produtos[index].usuario.avatar))),
                      appData.id_produto = produtos[index].usuario.id.toString(),
                      appData.name_produto = produtos[index].nomeProduto,
                      appData.img_produto = produtos[index].imagem,
                      appData.descricao_produto = produtos[index].descricao,
                      appData.email_client = produtos[index].usuario.email,
                      appData.avatar_client = produtos[index].usuario.avatar
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(width: 0.5, color: Colors.grey),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      elevation: 8,
                      margin: EdgeInsets.only(left: 15, right: 15, bottom: 15, top: 25),
                      color: Colors.white,
                      child: Container(
                        padding: EdgeInsets.all(15),
                        child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Hero(
                                  tag: produtos[index].id,
                                  child: FadeInImage.memoryNetwork(
                                      fadeInDuration: const Duration(milliseconds: 1000),
                                      height: 220,
                                      width: MediaQuery.of(context).size.width / 1.2,
                                      fit: BoxFit.cover,
                                      placeholder: kTransparentImage,
                                      image: 'http://192.168.15.10/api/produto/imagens/' + produtos[index].imagem + ''),
                                ),
                              ),
                              Divider(),
                              Center(
                                child: Text(
                                  produtos[index].nomeProduto,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: 20, color: Colors.blueAccent[900]),
                                ),
                              ),
                              Divider(),
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  produtos[index].descricao,
                                  textAlign: TextAlign.justify,
                                  style: TextStyle(fontFamily: 'Raleway', fontSize: 16, fontWeight: FontWeight.normal),
                                ),
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Ink(
                                      decoration: const ShapeDecoration(
                                        shape: CircleBorder(),
                                      ),
                                      child: IconButton(
                                        icon: Image.asset('assets/w.png', width: 322, height: 322),
                                        color: Colors.white,
                                        onPressed: () {
                                          FlutterOpenWhatsapp.sendSingleMessage(
                                              "55" + produtos[index].usuario.telefone.toString(),
                                              "Olá, " +
                                                  produtos[index].usuario.nome +
                                                  ", tenho interesse no produto: " +
                                                  produtos[index].nomeProduto +
                                                  ", vi o seu anúncio no App Constroca.");
                                        },
                                      )),
                                  Text(
                                    "Chat",
                                    style:
                                        TextStyle(fontFamily: 'Raleway', fontSize: 16, fontWeight: FontWeight.normal),
                                  ),
                                ],
                              ),
                              ListTile(
                                leading: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        'http://192.168.15.10/api/usuario/imagens/' + produtos[index].usuario.avatar)),
                                title: Text(
                                  "Contato: " + produtos[index].usuario.nome,
                                  style: TextStyle(fontFamily: 'Raleway', fontWeight: FontWeight.normal),
                                ),
                                subtitle: Text(
                                  "Telefone: " + produtos[index].usuario.telefone.toString(),
                                  style: TextStyle(fontFamily: 'Raleway', fontWeight: FontWeight.normal),
                                ),
                                trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[IconButton(icon: Icon(Icons.person_add), onPressed: null)]),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 5),
                                child: Text(
                                  "Email: " + produtos[index].usuario.email,
                                  style: TextStyle(fontFamily: 'Raleway', fontWeight: FontWeight.normal),
                                ),
                              ),
                            ]),
                      ),
                    ),
                  )),
            ],
          );
        },
      ),
    );
  }
}
