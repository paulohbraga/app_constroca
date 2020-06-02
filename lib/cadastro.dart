import 'package:app_constroca/perfil.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'inicio.dart';
import 'constants.dart';


class Cadastro extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false, home: TransfterData());
  }
}

class TransfterData extends StatefulWidget {
  TransfterDataWidget createState() => TransfterDataWidget();
}

class TransfterDataWidget extends State {
  // Getting value from TextField widget.
  final nomeController = TextEditingController();
  final loginUsuarioController = TextEditingController();
  final emailController = TextEditingController();
  final telefoneController = TextEditingController();
  final cidadeController = TextEditingController();
  final passwordController = TextEditingController();

  // Boolean variable for CircularProgressIndicator.
  bool visible = false;

  Future cadastrar() async {
    // Showing CircularProgressIndicator using State.
    setState(() {
      visible = true;
    });

    // Getting value from Controller
    String nome = nomeController.text;
    String login_usuario = loginUsuarioController.text;
    String email = emailController.text;
    String telefone = telefoneController.text;
    String cidade = cidadeController.text;
    String password = passwordController.text;

    // API URL
    var url = 'http://192.168.15.8/api/usuario/create.php';

    // Store all data with Param Name.
    var data = {
      'nome': nome,
      'login_usuario': login_usuario,
      'email': email,
      'telefone': telefone,
      'cidade': cidade,
      'password': password
    };

    // Starting Web Call with data.
    var response = await http.post(url, body: json.encode(data));

    // Getting Server response into variable.
    var message = jsonDecode(response.body);

    // If Web call Success than Hide the CircularProgressIndicator.
    if (response.statusCode == 200) {
      setState(() {
        visible = false;
      });
    }

    // Showing Alert Dialog with Response JSON.
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(message),
          actions: <Widget>[
            FlatButton(
              child: new Text("OK"),
              onPressed: () => Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Perfil())),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: true,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          
          automaticallyImplyLeading: false,
          title: Text('Cadastro de usuário'),
          centerTitle: true,
          backgroundColor: APP_BAR_COLOR,
        ),
        body: SingleChildScrollView(
            reverse: true,
            child: Center(
              child: Column(
                children: <Widget>[
                  Divider(
                    color: null,
                  ),
                  Container(
                      width: MediaQuery.of(context).size.width / 1.2,
                      padding: EdgeInsets.all(10.0),
                      child: TextField(
                        style: TextStyle(fontSize: 20, color: Colors.black),
                        controller: nomeController,
                        autocorrect: true,
                        decoration: InputDecoration(
                          hintText: 'Seu nome',
                          labelText: 'Seu nome',
                          border: OutlineInputBorder(),
                        ),
                      )),
                  Container(
                      width: MediaQuery.of(context).size.width / 1.2,
                      padding: EdgeInsets.all(10.0),
                      child: TextField(
                        style: TextStyle(fontSize: 20, color: Colors.black),
                        controller: loginUsuarioController,
                        autocorrect: true,
                        decoration: InputDecoration(
                          hintText: 'Login',
                          labelText: 'Login',
                          border: OutlineInputBorder(),
                        ),
                      )),
                  Container(
                      width: MediaQuery.of(context).size.width / 1.2,
                      padding: EdgeInsets.all(10.0),
                      child: TextField(
                        style: TextStyle(fontSize: 20, color: Colors.black),
                        controller: emailController,
                        autocorrect: true,
                        decoration: InputDecoration(
                          hintText: 'Seu e-mail',
                          labelText: 'e-mail',
                          border: OutlineInputBorder(),
                        ),
                      )),
                  Container(
                      width: MediaQuery.of(context).size.width / 1.2,
                      padding: EdgeInsets.all(10.0),
                      child: TextField(
                        style: TextStyle(fontSize: 20, color: Colors.black),
                        controller: telefoneController,
                        autocorrect: true,
                        decoration: InputDecoration(
                          hintText: 'Seu número de celular',
                          labelText: 'Celular',
                          border: OutlineInputBorder(),
                        ),
                      )),
                  Container(
                      width: MediaQuery.of(context).size.width / 1.2,
                      padding: EdgeInsets.all(10.0),
                      child: TextField(
                        style: TextStyle(fontSize: 20, color: Colors.black),
                        controller: cidadeController,
                        autocorrect: true,
                        decoration: InputDecoration(
                          hintText: 'Cidade',
                          labelText: 'Cidade',
                          border: OutlineInputBorder(),
                        ),
                      )),
                  Container(
                      width: MediaQuery.of(context).size.width / 1.2,
                      padding: EdgeInsets.all(10.0),
                      child: TextField(
                        style: TextStyle(fontSize: 20, color: Colors.black),
                        controller: passwordController,
                        autocorrect: true,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: 'Senha',
                          labelText: 'Senha',
                          border: OutlineInputBorder(),
                        ),
                      )),
                  RaisedButton(
                    onPressed: cadastrar,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(80.0)),
                    padding: EdgeInsets.all(0.0),
                    child: Ink(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xff374ABE), Color(0xff64B6FF)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(30.0)),
                      child: Container(
                        constraints:
                            BoxConstraints(maxWidth: 300.0, minHeight: 50.0),
                        alignment: Alignment.center,
                        child: Text(
                          "Cadastrar",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                      visible: visible,
                      child: Container(
                          margin: EdgeInsets.only(bottom: 30, top: 10),
                          child: CircularProgressIndicator())),
                  Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom)),
                ],
              ),
            )));
  }
}
