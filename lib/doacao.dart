import 'dart:async';
import 'dart:convert';
import 'package:app_constroca/perfil.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:transparent_image/transparent_image.dart';
import 'appdata.dart';
import 'constants.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'detalhaProduto.dart';
import 'perfil.dart';

Future<List<Produto>> fetchProdutos(http.Client client) async {
  final response =
      await client.get('http://192.168.15.10/api/produto/readDonation.php');

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

class MyApp2 extends StatelessWidget {
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
      backgroundColor: Colors.blue[900],
      appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          backgroundColor: APP_BAR_COLOR,
          title: Text("Troca"),
          flexibleSpace: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: APP_BAR_GRADIENT_COLOR))),
          actions: <Widget>[
            appData.id_usuario != null
                ? InkWell(
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (context) => PerfilUser())),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.network(
                        'http://192.168.15.10/api/usuario/imagens/' +
                            appData.avatar +
                            "",
                      ),
                    ))
                : Divider(),
          ]),
      body: Padding(
        child: FutureBuilder<List<Produto>>(
          future: buildFetchProdutos(),
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

  Future<List<Produto>> buildFetchProdutos() => fetchProdutos(http.Client());
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
                  color: Colors.grey[50],
                  // image: DecorationImage(
                  //     image: AssetImage("imgs/5.jpg"), fit: BoxFit.cover)
                ),
                constraints: BoxConstraints.expand(
                  height:
                      Theme.of(context).textTheme.display1.fontSize * 5 + 400.0,
                ),
                alignment: Alignment.center,
                child: InkWell(
                  onTap: () => {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MyHomePageDetail(
                                  produtos[index].id_produto,
                                  produtos[index].nome_produto,
                                  produtos[index].imagem,
                                ))),
                    appData.id_produto = produtos[index].id_produto,
                    appData.name_produto = produtos[index].nome_produto,
                    appData.img_produto = produtos[index].imagem,
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 0.5, color: Colors.grey),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    elevation: 8,
                    margin: EdgeInsets.only(
                        left: 15, right: 15, bottom: 25, top: 25),
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
                                tag: index,
                                child: FadeInImage.memoryNetwork(
                                    fadeInDuration:
                                        const Duration(milliseconds: 400),
                                    height: 220,
                                    width:
                                        MediaQuery.of(context).size.width / 1.2,
                                    fit: BoxFit.cover,
                                    placeholder: kTransparentImage,
                                    image:
                                        'http://192.168.15.10/api/produto/imagens/' +
                                            produtos[index].imagem +
                                            ''),
                              ),
                            ),
                            Divider(),
                            Center(
                              child: Text(
                                produtos[index].nome_produto,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.blueAccent[900]),
                              ),
                            ),
                            Divider(),
                            Padding(
                              padding: EdgeInsets.all(10),
                              child: Text(
                                produtos[index].descricao_produto,
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal),
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
                            ListTile(
                              leading: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      'http://192.168.15.10/api/usuario/imagens/' +
                                          produtos[index].avatar)),
                              title: Text("Anunciante: " +
                                  produtos[index].nome_usuario),
                              subtitle:
                                  Text("Telefone: " + produtos[index].telefone),
                              trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    IconButton(
                                        icon: Icon(Icons.person_add),
                                        onPressed: null)
                                  ]),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 20),
                              child: Text("Email: " + produtos[index].email),
                            ),
                          ]),
                    ),
                  ),
                )),
          ],
        );
      },
    );
  }
}

class CustomShapeBorder extends ContinuousRectangleBorder {
  @override
  Path getOuterPath(Rect rect, {TextDirection textDirection}) {
    final double innerCircleRadius = 150.0;

    Path path = Path();
    path.lineTo(0, rect.height);
    path.quadraticBezierTo(rect.width / 2 - (innerCircleRadius / 2) - 30,
        rect.height + 15, rect.width / 2 - 75, rect.height + 50);
    path.cubicTo(
        rect.width / 2 - 40,
        rect.height + innerCircleRadius - 40,
        rect.width / 2 + 40,
        rect.height + innerCircleRadius - 40,
        rect.width / 2 + 75,
        rect.height + 50);
    path.quadraticBezierTo(rect.width / 2 + (innerCircleRadius / 2) + 30,
        rect.height + 15, rect.width, rect.height);
    path.lineTo(rect.width, 0.0);
    path.close();

    return path;
  }
}
