import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:transparent_image/transparent_image.dart';

import 'appdata.dart';
import 'constants.dart';

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
              contentPadding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
              leading: CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage('http://www.someletras.com.br/paulo/' + appData.avatar_client + '')),
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
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(10.0),
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
            Padding(
              padding: EdgeInsets.only(left: 5),
              child: Text(
                "Email: " + appData.email_client,
                style: TextStyle(fontFamily: 'Raleway', fontWeight: FontWeight.normal),
              ),
            ),
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
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
                placeholder: kTransparentImage,
                image: 'http://www.someletras.com.br/paulo/' + appData.img_produto + ''),
          ),
        ],
      ),
    );
  }
}
