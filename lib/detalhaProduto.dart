import 'dart:convert';

import 'package:app_constroca/produtos.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:transparent_image/transparent_image.dart';

import 'appdata.dart';
import 'constants.dart';

// Future<List<Produto>> fetchProdutos(http.Client client) async {
//   final response = await client.get(
//       'http://192.168.15.10/api/produto/readOne.php?id=' + appData.id_produto);
//   // Use the compute function to run parsePhotos in a separate isolate
//   return compute(parseProdutos, response.body);
// }

// // A function that will convert a response body into a List<Photo>
// List<Produto> parseProdutos(String responseBody) {
//   print(appData.id_produto + ">>>>>>>>>>>++++++++++++++++++++");

//   final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

//   return parsed.map<Produto>((json) => Produto.fromJson(json)).toList();
// }

// class Produto {
//   final String id_produto;
//   final String fk_id_usuario;
//   final String nome_usuario;
//   final String nome_produto;
//   final String telefone;
//   final String email;
//   final String descricao_produto;
//   final String imagem;
//   final String tipo;
//   final String avatar;

//   Produto(
//       {this.id_produto,
//       this.fk_id_usuario,
//       this.nome_usuario,
//       this.nome_produto,
//       this.telefone,
//       this.email,
//       this.descricao_produto,
//       this.imagem,
//       this.avatar,
//       this.tipo});

//   factory Produto.fromJson(Map<String, dynamic> json) {
//     return Produto(
//       id_produto: json['id_produto'] as String,
//       fk_id_usuario: json['fk_id_usuario'] as String,
//       nome_usuario: json['nome_usuario'] as String,
//       nome_produto: json['nome_produto'] as String,
//       telefone: json['telefone'] as String,
//       email: json['email'] as String,
//       descricao_produto: json['descricao_produto'] as String,
//       imagem: json['imagem'] as String,
//       avatar: json['avatar'] as String,
//       tipo: json['tipo'] as String,
//       //email
//       //telefone
//       //cidade
//       // avatar
//     );
//   }
// }

class DetalhaProduto extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Product page',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Montserrat'),
      home: MyHomePage(title: 'Flutter Product page'),
    );
  }
}

class MyHomePageDetail extends StatefulWidget {
  MyHomePageDetail(String idProduto, String nome_produto, String img_produto,
      {Key key, this.title})
      : super(key: key);
  final appData = AppData();

  final String title;

  @override
  _MyHomePageDetail createState() => _MyHomePageDetail();
}

class _MyHomePageDetail extends State<MyHomePageDetail> {
  String selected = "blue";
  bool favourite = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: <Color>[Colors.blue[800], Colors.blue]))),
        centerTitle: true,
        backgroundColor: APP_BAR_COLOR,
        title: Text(appData.name_produto),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      //The whole application area
      body: SafeArea(
        child: Column(
          children: <Widget>[
            hero(appData.id_produto),
            spaceVertical(2),
            //Center Items
            Expanded(
              child: sections(),
            ),

            //Bottom Button
            purchase()
          ],
        ),
      ),
    );
  }

  ///************** Hero   ***************************************************/
  Widget hero(String id) {
    return Container(
      child: Stack(
        children: <Widget>[
          Hero(
            tag: id,
            child: FadeInImage.memoryNetwork(
                placeholder: kTransparentImage,
                image: 'http://192.168.15.10/api/produto/imagens/' +
                    appData.img_produto +
                    ''),
          ),
          //This
          // should be a paged
          // view.
          Positioned(
            child: appBar(),
            top: 0,
          ),
        ],
      ),
    );
  }

  Widget appBar() {
    return Container(
      padding: EdgeInsets.all(16),
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                // Text(
                //   "Troco canos",
                //   style: TextStyle(
                //     fontWeight: FontWeight.w100,
                //     fontSize: 14,
                //   ),
                // ),
                // Text(
                //   "José",
                //   style: TextStyle(
                //       fontSize: 24,
                //       fontWeight: FontWeight.bold,
                //       color: Color(0xFF2F2F3E)),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /***** End */

  ///************ SECTIONS  *************************************************/
  Widget sections() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        children: <Widget>[
          description(),
          spaceVertical(50),
          property(),
        ],
      ),
    );
  }

  Widget description() {
    return Text(
      "Aqui vai a descriçao do item para troca ou doação ",
      textAlign: TextAlign.justify,
      style: TextStyle(height: 1.5, color: Color(0xFF6F8398)),
    );
  }

  Widget property() {
    return Container(
      padding: EdgeInsets.only(right: 20, left: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "texto aqui texto aqui",
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2F2F3E)),
              ),
              spaceVertical(10),
              //colorSelector(),
            ],
          ),
          size()
        ],
      ),
    );
  }

  Widget size() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Teste",
          textAlign: TextAlign.left,
          style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2F2F3E)),
        ),
        spaceVertical(10),
        Container(
          width: 70,
          padding: EdgeInsets.all(10),
          color: Color(0xFFF5F8FB),
          child: Text(
            "teste",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2F2F3E)),
          ),
        )
      ],
    );
  }

  /***** End */

  ///************** BOTTOM BUTTON ********************************************/
  Widget purchase() {
    return Container(
      padding: EdgeInsets.all(5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          FlatButton(
            child: Text(
              "Adicionar os favoritos +",
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2F2F3E)),
            ),
            color: Colors.transparent,
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  /***** End */

  ///************** UTILITY WIDGET ********************************************/
  Widget spaceVertical(double size) {
    return SizedBox(
      height: size,
    );
  }

  Widget spaceHorizontal(double size) {
    return SizedBox(
      width: size,
    );
  }
  /***** End */
}

class ColorTicker extends StatelessWidget {
  final Color color;
  final bool selected;
  final VoidCallback selectedCallback;
  ColorTicker({this.color, this.selected, this.selectedCallback});

  @override
  Widget build(BuildContext context) {
    Future<List<Produto>> buildFetchProdutos() => fetchProdutos(http.Client());

    print(selected);
    return GestureDetector(
        onTap: () {
          selectedCallback();
          fetchProdutos(http.Client());
        },
        child: Container(
          padding: EdgeInsets.all(7),
          margin: EdgeInsets.all(5),
          width: 30,
          height: 30,
          decoration: BoxDecoration(
              shape: BoxShape.circle, color: color.withOpacity(0.7)),
          child: selected ? Image.asset("imgs/checker.png") : Container(),
        ));
  }
}
