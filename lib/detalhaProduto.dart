import 'dart:convert';

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

class MyHomePageDetail extends StatefulWidget {
  MyHomePageDetail(String descricao, String idProduto, String nome_produto, String img_produto, String avatar,
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
                    colors: <Color>[Colors.blue, Colors.blue[800]]))),
        centerTitle: true,
        backgroundColor: APP_BAR_COLOR,
        title: Text(appData.name_produto, style: TextStyle(fontSize: 15)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      //The whole application area
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)), child: hero(appData.id_produto)),
            ListTile(
              contentPadding: EdgeInsets.symmetric(vertical: 50.0, horizontal: 16.0),
              leading: CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(
                      'https://constroca-webservice-app.herokuapp.com/imagens/' + appData.avatar_client + '')),
              title: Text(
                "Contato: " + appData.email_client,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Raleway',
                  fontWeight: FontWeight.normal,
                ),
              ),
              subtitle: Text(
                "Telefone: " + appData.telefone_client,
                textAlign: TextAlign.center,
                style: TextStyle(fontFamily: 'Raleway', fontWeight: FontWeight.normal),
              ),
              trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[IconButton(icon: Icon(Icons.chat), onPressed: null)]),
            ),
            spaceVertical(2),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Text(appData.descricao_produto,
                      textAlign: TextAlign.justify,
                      style: TextStyle(fontSize: 20, fontFamily: 'Raleway', fontWeight: FontWeight.normal)),
                ),
                Text(
                  "Chat",
                  style: TextStyle(fontFamily: 'Raleway', fontSize: 16, fontWeight: FontWeight.normal),
                ),
              ],
            ),
            //Center Items
            // Expanded(
            //   child: sections(),
            // ),
            Padding(
              padding: EdgeInsets.only(left: 5),
              child: Text(
                "Email: " + appData.email_client,
                style: TextStyle(fontFamily: 'Raleway', fontWeight: FontWeight.normal),
              ),
            ),

            //Bottom Button
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
                height: MediaQuery.of(context).size.height / 2.5,
                fit: BoxFit.fill,
                placeholder: kTransparentImage,
                image: 'https://constroca-webservice-app.herokuapp.com/imagens/' + appData.img_produto + ''),
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
        ],
      ),
    );
  }

  Widget description() {
    return Text(
      appData.descricao_produto,
      textAlign: TextAlign.justify,
      style: TextStyle(fontFamily: 'Raleway', height: 1.5),
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
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF2F2F3E)),
        ),
        spaceVertical(10),
        Container(
          width: 70,
          padding: EdgeInsets.all(10),
          color: Color(0xFFF5F8FB),
          child: Text(
            "teste",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2F2F3E)),
          ),
        )
      ],
    );
  }

  /***** End */

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
