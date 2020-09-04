import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:transparent_image/transparent_image.dart';

import 'appdata.dart';
import 'constants.dart';
import 'detalhaProduto.dart';
import 'models/Usuario.dart';

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

  String id;
  String nomeProduto;
  String descricao;
  String status;
  String tipo;
  String imagem;
  Usuario usuario;

  factory Produto.fromJson(Map<String, dynamic> json) => Produto(
        id: json["id"],
        nomeProduto: json["nome_produto"],
        descricao: json["descricao_produto"],
        status: json["status"],
        tipo: json["tipo"],
        imagem: json["imagem"],
        usuario: Usuario.fromJson(json["usuario"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nome_produto": nomeProduto,
        "descricao_produto": descricao,
        "status": status,
        "tipo": tipo,
        "imagem": imagem,
        "usuario": usuario.toJson(),
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
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.blue[900],
      appBar: AppBar(
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
      //width: MediaQuery.of(context).size.height,
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
                        MaterialPageRoute(
                            builder: (context) => MyHomePageDetail(produtos[index].descricao, produtos[index].id,
                                produtos[index].nomeProduto, produtos[index].imagem, produtos[index].usuario.avatar))),
                    appData.id_produto = produtos[index].id,
                    appData.name_produto = produtos[index].nomeProduto,
                    appData.img_produto = produtos[index].imagem,
                    appData.descricao_produto = produtos[index].descricao,
                    appData.email_client = produtos[index].usuario.email,
                    appData.avatar_client = produtos[index].usuario.avatar,
                    appData.telefone_client = produtos[index].usuario.telefone.toString()
                  },
                  child: Stack(
                    children: <Widget>[
                      Card(
                        semanticContainer: true,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: Hero(
                          tag: produtos[index].id,
                          child: FadeInImage.memoryNetwork(
                            fadeInDuration: const Duration(milliseconds: 400),
                            image: "http://192.168.15.10/api/produto/imagens/" + produtos[index].imagem + "",
                            fit: BoxFit.fill,
                            placeholder: kTransparentImage,
                            height: 280,
                            width: MediaQuery.of(context).size.width,
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation: 5,
                        margin: EdgeInsets.all(10),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Center(
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: <Color>[Color(0x499999), Colors.black87]),
                              borderRadius:
                                  BorderRadius.only(topRight: Radius.circular(10), topLeft: Radius.circular(10)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: Text(produtos[index].nomeProduto,
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                      fontFamily: 'Raleway',
                                      fontSize: 15,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
