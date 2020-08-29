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

Future<List<Produto>> fetchProdutos(http.Client client) async {
  final response = await client.get('http://192.168.15.10/api/produto/read.php');

  // Use the compute function to run parsePhotos in a separate isolate
  return compute(parseProdutos, response.body);
}

// A function that will convert a response body into a List<Photo>
List<Produto> parseProdutos(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Produto>((json) => Produto.fromJson(json)).toList();
}

class Produto {
  final String id_produto;
  final String fk_id_usuario;
  final String nome_usuario;
  final String nome_produto;
  final String telefone;
  final String email;
  final String descricao_produto;
  final String imagem;
  final String tipo;
  final String avatar;

  Produto(
      {this.id_produto,
      this.fk_id_usuario,
      this.nome_usuario,
      this.nome_produto,
      this.telefone,
      this.email,
      this.descricao_produto,
      this.imagem,
      this.avatar,
      this.tipo});

  factory Produto.fromJson(Map<String, dynamic> json) {
    return Produto(
      id_produto: json['id_produto'] as String,
      fk_id_usuario: json['fk_id_usuario'] as String,
      nome_usuario: json['nome_usuario'] as String,
      nome_produto: json['nome_produto'] as String,
      telefone: json['telefone'] as String,
      email: json['email'] as String,
      descricao_produto: json['descricao_produto'] as String,
      imagem: json['imagem'] as String,
      avatar: json['avatar'] as String,
      tipo: json['tipo'] as String,
      //email
      //telefone
      //cidade
      // avatar
    );
  }
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
                            builder: (context) => MyHomePageDetail(
                                produtos[index].descricao_produto,
                                produtos[index].id_produto,
                                produtos[index].nome_produto,
                                produtos[index].imagem,
                                produtos[index].avatar))),
                    appData.id_produto = produtos[index].id_produto,
                    appData.name_produto = produtos[index].nome_produto,
                    appData.img_produto = produtos[index].imagem,
                    appData.descricao_produto = produtos[index].descricao_produto,
                    appData.email_client = produtos[index].email,
                    appData.avatar_client = produtos[index].avatar,
                    appData.telefone_client = produtos[index].telefone
                  },
                  child: Stack(
                    children: <Widget>[
                      Card(
                        semanticContainer: true,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: Hero(
                          tag: produtos[index].id_produto,
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
                                  colors: <Color>[Color(0x999999), Colors.blue[900]]),
                              borderRadius:
                                  BorderRadius.only(topRight: Radius.circular(10), topLeft: Radius.circular(10)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(5),
                              child: Text(produtos[index].nome_produto,
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
