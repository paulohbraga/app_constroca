import 'dart:convert';

import 'package:app_constroca/providers/MessagesProvider.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

import 'appdata.dart';
import 'chat_message_list.dart';
import 'constants.dart';

class MyHomePageDetail extends StatefulWidget {
  MyHomePageDetail(
      String descricao, String idProduto, String nome_produto, String img_produto, String avatar, int id_usuario_owner,
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
          icon: Icon(FeatherIcons.arrowLeftCircle, color: Colors.white),
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
                contentPadding: EdgeInsets.symmetric(vertical: 35.0, horizontal: 20.0),
                leading: CircleAvatar(
                    radius: 25,
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
                trailing: appData.id_usuario == null
                    ? Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                        IconButton(
                            icon: Icon(FeatherIcons.send),
                            color: Colors.transparent,
                            onPressed: () => {print(appData.id_usuario)})
                      ])
                    : Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                        IconButton(
                            icon: Icon(FeatherIcons.send),
                            color: Colors.blue,
                            onPressed: () => {
                                  _showdialog(),
                                  Provider.of<MessageProvider>(context, listen: false)
                                      .createRoom(int.parse(appData.id_usuario), appData.usuario_p_owner),
                                })
                      ])),
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(appData.descricao_produto,
                      textAlign: TextAlign.justify,
                      style: TextStyle(fontSize: 18, fontFamily: 'Raleway', fontWeight: FontWeight.normal)),
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

  void _showdialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
            actions: <Widget>[
              FlatButton(
                child: Text("Cancelar", style: TextStyle(color: Colors.red, fontFamily: 'Raleway')),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text(
                  "Enviar",
                  style: TextStyle(color: Colors.green[900], fontFamily: 'Raleway'),
                ),
                onPressed: () => {
                  Provider.of<MessageProvider>(context, listen: false)
                      .createRoom(int.parse(appData.id_usuario), int.parse(appData.id_usuario)),
                  Navigator.pop(context)
                },
              )
            ],
            content: SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.all(1),
                padding: EdgeInsets.only(bottom: 1.0),
                height: 100,
                width: 300,
                child: TextField(
                  maxLength: 100,
                  textAlignVertical: TextAlignVertical.bottom,
                  maxLines: null,
                  minLines: null,
                  expands: true,
                ),
              ),
            ),
            title: Text(
              "Mensagem",
              textAlign: TextAlign.center,
            ),
          );
        });
  }
}
