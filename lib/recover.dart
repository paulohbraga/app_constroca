import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'constants.dart';

class Recover extends StatefulWidget {
  @override
  _RecoverState createState() => _RecoverState();
}

class _RecoverState extends State<Recover> {
  bool visible = false;

  final emailController = TextEditingController();

  Future userRecover() async {
    setState(() {
      visible = true;
    });

    String email = emailController.text;

    var url = 'http://localhost:8080/email-send';

    var data = {'email': email};

    var response = await http.post(url,
        body: json.encode(data), headers: {'Content-type': 'application/json', 'Accept': 'application/json'});

    var message = jsonDecode(response.body);

    if (message["responseMail"] == 'sucess') {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text(
              "Sua nova senha foi encaminhada para o seu e-mail",
              textAlign: TextAlign.center,
            ),
            actions: <Widget>[
              FlatButton(
                child: new Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    visible = false;
                    emailController.clear();
                  });
                },
              ),
            ],
          );
        },
      );
      setState(() {
        visible = false;
      });
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text(
              "Usuário não cadastrado no sistema!",
              textAlign: TextAlign.center,
            ),
            actions: <Widget>[
              FlatButton(
                child: new Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    visible = false;
                  });
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Recuperar senha',
      home: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          backgroundColor: APP_BAR_COLOR,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            "Recuperar senha",
            style: TextStyle(fontFamily: 'Raleway', fontWeight: FontWeight.bold),
          ),
          flexibleSpace: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft, end: Alignment.bottomRight, colors: APP_BAR_GRADIENT_COLOR))),
        ),
        body: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 50),
              child: Image.asset(
                'assets/lock.png',
                color: Colors.blue,
                width: 150,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(50.0),
              child: Text(
                'Digite seu email para receber uma nova senha',
                style: TextStyle(fontSize: 20, fontFamily: 'Raleway'),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: TextFormField(
                  key: Key("txtEmail"),
                  controller: emailController,
                  decoration: new InputDecoration(
                      hintText: 'Digite e-mail abaixo', labelText: 'Seu e-mail', border: OutlineInputBorder())),
            ),
            RaisedButton(
              key: Key("recuperar"),
              onPressed: () => userRecover(),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
              padding: EdgeInsets.all(0.0),
              child: Ink(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue[900], Colors.blue[600]],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(5.0)),
                child: Container(
                  constraints: BoxConstraints(maxWidth: 200.0, minHeight: 40.0),
                  alignment: Alignment.center,
                  child: Text(
                    "Enviar nova senha",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontFamily: 'Raleway'),
                  ),
                ),
              ),
            ),
            Visibility(
                visible: visible,
                child: Container(margin: EdgeInsets.only(bottom: 30), child: CircularProgressIndicator())),
          ],
        ),
      ),
    );
  }
}
