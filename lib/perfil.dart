import 'package:app_constroca/cadastroProduto.dart';
import 'package:app_constroca/login.dart';
import 'package:app_constroca/my_products.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'constants.dart';
import 'appdata.dart';
import 'login.dart';

class Perfil extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PerfilUser(),
    );
  }
}

class PerfilUser extends StatefulWidget {
  PerfilUser();

  PerfilUserState createState() => PerfilUserState();
}

class PerfilUserState extends State {
  // For CircularProgressIndicator.
  bool visible = false;
  // Getting value from TextField widget.
  var message_global;
  final appData = AppData();

  PerfilUserState();

  @override
  Widget build(BuildContext context) {
    //print(message);
    return Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: false, backgroundColor: APP_BAR_COLOR, centerTitle: true, title: Text('Perfil')),
        resizeToAvoidBottomInset: true,
        body: Container(
            child: Container(
          decoration: BoxDecoration(),
          constraints: BoxConstraints.expand(height: MediaQuery.of(context).size.height),
          child: Column(
            children: <Widget>[
              Container(
                  child: Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(10),
                    ),
                    InkWell(
                        child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.network(
                        'http://192.168.15.10/api/usuario/imagens/' + appData.message['avatar'],
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                      ),
                    )),
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        appData.message['nome'],
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      ),
                    ),
                  ]),
                  // decoration: BoxDecoration(
                  //     image: DecorationImage(
                  //         image: AssetImage("imgs/4.png"), fit: BoxFit.cover)),
                  constraints: BoxConstraints.expand(
                    height: Theme.of(context).textTheme.display1.fontSize * 1 + 100.0,
                  )),
              Container(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 5, top: 25),
                        child: Text(
                          "Cidade: " + appData.message['cidade'],
                          style: TextStyle(fontSize: 20, color: Colors.black),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 5, top: 25),
                        child: Text(
                          "Telefone: " + appData.message['telefone'].toString(),
                          style: TextStyle(fontSize: 20, color: Colors.black),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 5, top: 25),
                        child: Text(
                          "e-mail: " + appData.message['email'],
                          style: TextStyle(fontSize: 20, color: Colors.black),
                        ),
                      ),
                    ]),
                // decoration: BoxDecoration(
                //     image: DecorationImage(
                //         image: AssetImage("imgs/4.png"), fit: BoxFit.cover)),
              ),
              Padding(
                padding: EdgeInsets.only(top: MediaQuery.of(context).size.width / 4),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
                  RaisedButton(
                    onPressed: () =>
                        Navigator.push(context, MaterialPageRoute(builder: (context) => CadastroProduto())),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
                    padding: EdgeInsets.all(0.0),
                    child: Ink(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xff374ABE), Color(0xff64B6FF)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(10.0)),
                      child: Container(
                        constraints: BoxConstraints(maxWidth: 180.0, minHeight: 40.0),
                        alignment: Alignment.center,
                        child: Text(
                          "Cadastrar novo produto",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  RaisedButton(
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => MyProducts())),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
                    padding: EdgeInsets.all(0.0),
                    child: Ink(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xff374ABE), Color(0xff64B6FF)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(10.0)),
                      child: Container(
                        constraints: BoxConstraints(maxWidth: 180.0, minHeight: 40.0),
                        alignment: Alignment.center,
                        child: Text(
                          "Meus produtos",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ]),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 100),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    RaisedButton(
                      onPressed: () => {
                        appData.id_usuario = null,
                        appData.cidade = null,
                        appData.nome_usuario = null,
                        appData.telefone = null,
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Logar())),
                      },
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
                      padding: EdgeInsets.all(0.0),
                      child: Ink(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xff374ABE), Color(0xff64B6FF)],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(10.0)),
                        child: Container(
                          constraints: BoxConstraints(maxWidth: 140.0, minHeight: 40.0),
                          alignment: Alignment.center,
                          child: Text(
                            "Sair",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )));
  }
}
