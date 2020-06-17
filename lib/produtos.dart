import 'dart:async';
import 'dart:convert';
import 'package:app_constroca/perfil.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'appdata.dart';
import 'constants.dart';
import 'detalhaProduto.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'perfil.dart';

Future<List<Produto>> fetchProdutos(http.Client client) async {
  
  final response = await client.get('http://192.168.15.7/api/produto/read.php');
 

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
  final String descricao_produto;
  final String imagem;
  final String tipo;

  Produto(
      {this.id_produto,
      this.fk_id_usuario,
      this.nome_usuario,
      this.nome_produto,
      this.descricao_produto,
      this.imagem,
      this.tipo});

  factory Produto.fromJson(Map<String, dynamic> json) {
    return Produto(
      id_produto: json['id_produto'] as String,
      fk_id_usuario: json['fk_id_usuario'] as String,
      nome_usuario: json['nome_usuario'] as String,
      nome_produto: json['nome_produto'] as String,
      descricao_produto: json['descricao_produto'] as String,
      imagem: json['imagem'] as String,
      tipo: json['tipo'] as String,
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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: APP_BAR_COLOR,
        title: Text("Produtos"),
          actions: <Widget>[ appData.id_usuario != null ?
                
                InkWell(
                  onTap:  () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PerfilUser())),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    
                    child: Image.network('http://192.168.15.7/api/usuario/imagens/' +
                                appData.avatar + "", fit: BoxFit.cover),
                  )

                ) : Divider(),
         ]),
      body: Padding(
        child: FutureBuilder<List<Produto>>(
          future: fetchProdutos(http.Client()),
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);

            return snapshot.hasData
                ? ProdutosList(produtos: snapshot.data)
                : Center(child: CircularProgressIndicator());
          },
        ),
        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      ),
    );
  }
}

class ProdutosList extends StatelessWidget {
  final List<Produto> produtos;

  ProdutosList({Key key, this.produtos}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: produtos.length,
      itemBuilder: (context, index) {
        return Column(
          children: <Widget>[
            Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("imgs/4.png"), fit: BoxFit.cover)),
                constraints: BoxConstraints.expand(
                  height: Theme.of(context).textTheme.display1.fontSize * 4.9 +
                      250.0,
                ),
                alignment: Alignment.center,
                child: Card(
                  margin: EdgeInsets.only(left: 15, right: 15, bottom: 10),
                  color: Colors.grey[100],
                  child: Container(
                    padding: EdgeInsets.all(5),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Image.network(
                            'http://192.168.15.7/api/produto/imagens/' +
                                produtos[index].imagem +
                                '',
                            height: 190,
                            width: 400,
                            fit: BoxFit.cover,
                          ),
                          Divider(),
                          Center(
                            child: Text(
                              produtos[index].nome_produto,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style:
                                  TextStyle(fontSize: 20, color: Colors.blue),
                            ),
                          ),
                          Divider(),
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              produtos[index].descricao_produto,
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                          ),
                          ButtonTheme.bar(
                              child: ButtonBar(
                            alignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              // Text(
                              //   produtos[index].tipo == "D"
                              //       ? "DOACAO"
                              //       : "TROCA",
                              //   style: TextStyle(color: Colors.black87),
                              // ),
                              Column(
                                  mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Ink(
                                  decoration: const ShapeDecoration(
                                    shape: CircleBorder(),
                                  ),
                                  child: IconButton(
                                    icon: Image.asset('assets/w.png',
                                        width: 322, height: 322),
                                    color: Colors.white,
                                    onPressed: () {
                                      FlutterOpenWhatsapp.sendSingleMessage(
                                          "5561998753273",
                                          "Olá, " + produtos[index].nome_usuario + ", tenho interesse no produto: " +
                                              produtos[index].nome_produto +
                                              ", vi o seu anúncio no App Constroca.");
                                    },
                                  )),
                                  Text("Chat")
                                ],
                              ),
                              
                              // FlatButton(
                              //   child: const Text('Mensagem'),
                              //   onPressed: () {
                              //     FlutterOpenWhatsapp.sendSingleMessage(
                              //         "5561998753273",
                              //         "Olá, tenho interesse no produto: " +
                              //             produtos[index].nome_produto +
                              //             ", vi o anúncio no App Constroca.");
                              //   },
                              // ),
                              FlatButton(
                                child: const Text('DETALHES'),
                                onPressed: () {/* ... */},
                              ),
                            ],
                          ))
                        ]),
                  ),
                )),
          ],
        );
      },
    );
  }
}
