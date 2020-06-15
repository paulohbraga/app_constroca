import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'constants.dart';
import 'detalhaProduto.dart';

Future<List<Produto>> fetchProdutos(http.Client client) async {
  final response = await client.get('http://192.168.15.4/api/produto/read.php');
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var email = prefs.getString('email');
  //print(email);

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
  final String nome_produto;
  final String descricao_produto;
  final String imagem;

  Produto(
      {this.id_produto,
      this.fk_id_usuario,
      this.nome_produto,
      this.descricao_produto,
      this.imagem});

  factory Produto.fromJson(Map<String, dynamic> json) {
    return Produto(
      id_produto: json['id_produto'] as String,
      fk_id_usuario: json['fk_id_usuario'] as String,
      nome_produto: json['nome_produto'] as String,
      descricao_produto: json['descricao_produto'] as String,
      imagem: json['imagem'] as String,
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'Troca';

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: appTitle,
      home: MyHomePage(title: appTitle),
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
        centerTitle: true,
        backgroundColor: APP_BAR_COLOR,
        title: Text(title),
      ),
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

  Future<void> main() async {
    WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var email = prefs.getString('email');
    print(email);
  }

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
                  height: Theme.of(context).textTheme.display1.fontSize * 3.9 +
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
                            'http://192.168.15.4/api/produto/imagens/' +
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
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                          ),
                          ButtonTheme.bar(
                              child: ButtonBar(
                            children: <Widget>[
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
