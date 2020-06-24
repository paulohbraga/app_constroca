import 'dart:async';
import 'dart:convert';
import 'package:app_constroca/perfil.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'appdata.dart';
import 'constants.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'perfil.dart';



Future<List<Produto>> fetchProdutos(http.Client client) async {
  final response = await client.get('http://192.168.15.6/api/produto/read.php');

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
      appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          backgroundColor: APP_BAR_COLOR,
          title: Text("Troca"),
          
          actions: <Widget>[
            appData.id_usuario != null
                ? InkWell(
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (context) => PerfilUser())),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.network(
                        'http://192.168.15.6/api/usuario/imagens/' +
                            appData.avatar +
                            "",
                      ),
                    ))
                : Divider(),
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
                        image: AssetImage("imgs/5.jpg"), fit: BoxFit.cover)),
                constraints: BoxConstraints.expand(
                  height:
                      Theme.of(context).textTheme.display1.fontSize * 5 + 400.0,
                ),
                alignment: Alignment.center,
                child: Card(
                  margin: EdgeInsets.only(left: 15, right: 15, bottom: 10, top: 5),
                  color: Colors.grey[100],
                  child: Container(
                    padding: EdgeInsets.all(5),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Image.network(
                            'http://192.168.15.6/api/produto/imagens/' +
                                produtos[index].imagem +
                                '',
                            height: 190,
                            width: MediaQuery.of(context).size.width,
                            fit: BoxFit.cover,
                          ),
                          Divider(),
                          Center(
                            child: Text(
                              produtos[index].nome_produto,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 20, color: Colors.blueAccent[900]),
                            ),
                          ),
                          Divider(),
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              produtos[index].descricao_produto,
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.normal),
                            ),
                          ),
                          ButtonTheme.bar(
                              child: ButtonBar(
                            alignment: MainAxisAlignment.center,
                            children: <Widget>[
                              // Text(
                              //   produtos[index].tipo == "D"
                              //       ? "DOACAO"
                              //       : "TROCA",
                              //   style: TextStyle(color: Colors.black87),
                              // ),
                              //     Padding(
                              //   padding: EdgeInsets.only(top: 20),
                              //   child: Text("Anunciante: " +
                              //     produtos[index].nome_usuario,
                              //     textAlign: TextAlign.justify,
                              //     style: TextStyle(
                              //         fontSize: 18, fontWeight: FontWeight.normal),
                              //   ),
                              // ),
                              // Column(
                              //   mainAxisSize: MainAxisSize.min,
                              //   children: <Widget>[
                              //     Ink(
                              //         decoration: const ShapeDecoration(
                              //           shape: CircleBorder(),
                              //         ),
                              //         child: IconButton(
                              //           icon: Image.asset('assets/m.png',
                              //               width: 322, height: 322),
                              //           color: Colors.white,
                              //           onPressed: () {
                              //             FlutterOpenWhatsapp.sendSingleMessage(
                              //                 "55" + produtos[index].telefone,
                              //                 "Olá, " +
                              //                     produtos[index].nome_usuario +
                              //                     ", tenho interesse no produto: " +
                              //                     produtos[index].nome_produto +
                              //                     ", vi o seu anúncio no App Constroca.");
                              //           },
                              //         )),
                              //     Text("Email"),
                              //   ],
                              // ),

                              // Column(
                              //   mainAxisSize: MainAxisSize.min,
                              //   children: <Widget>[
                              //     Ink(
                              //         decoration: const ShapeDecoration(
                              //           shape: CircleBorder(),
                              //         ),
                              //         child: IconButton(
                              //           icon: Image.asset('assets/c.png',
                              //               width: 322, height: 322),
                              //           color: Colors.white,
                              //           onPressed: () {
                              //             FlutterOpenWhatsapp.sendSingleMessage(
                              //                 "55" + produtos[index].telefone,
                              //                 "Olá, " +
                              //                     produtos[index].nome_usuario +
                              //                     ", tenho interesse no produto: " +
                              //                     produtos[index].nome_produto +
                              //                     ", vi o seu anúncio no App Constroca.");
                              //           },
                              //         )),
                              //     Text("Ligar"),
                              //   ],
                              //   // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
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
                                              "55" + produtos[index].telefone,
                                              "Olá, " +
                                                  produtos[index].nome_usuario +
                                                  ", tenho interesse no produto: " +
                                                  produtos[index].nome_produto +
                                                  ", vi o seu anúncio no App Constroca.");
                                        },
                                      )),
                                  Text("Chat"),
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
                            ],
                          )),
                          Padding(padding:EdgeInsets.all(15) ),
                          ListTile(
                                leading: CircleAvatar(backgroundImage: NetworkImage('http://192.168.15.6/api/usuario/imagens/' +
                                      produtos[index].avatar) ),
                                title: Text("Anunciante: " + produtos[index].nome_usuario),
                                subtitle: Text("Telefone: " + produtos[index].telefone),
                                trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    IconButton(icon: Icon(Icons.person_add), onPressed: null)
                                  ]
                                ),
                                  
                              ),
                          Padding(padding:EdgeInsets.only(left: 20), child: 
                          Text("Email: " + produtos[index].email)
                          , ),

                        ]),
                  ),
                )),
          ],
        );
      },
    );
  }
}
