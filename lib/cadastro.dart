import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'constants.dart';
import 'package:cpfcnpj/cpfcnpj.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

import 'login.dart';


class Cadastro extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:  TransfterData());
      
      
  }
}

class TransfterData extends StatefulWidget {
  TransfterDataWidget createState() => TransfterDataWidget();
}

class TransfterDataWidget extends State {
  // Getting value from TextField widget.
  String _valid_cpf = "";
  final nomeController = TextEditingController();
  final loginUsuarioController = TextEditingController();
  var cpfController = MaskedTextController(mask: '000.000.000-00');
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
    String cpf_usuario = cpfController.text;
    String email = emailController.text;
    String telefone = telefoneController.text;
    String cidade = cidadeController.text;
    String password = passwordController.text;

    // API URL
    var url = 'http://192.168.15.4/api/usuario/create.php';

    // Store all data with Param Name.
    var data = {
      'nome': nome,
      'login_usuario': login_usuario,
      'email': email,
      'cpf': cpf_usuario,
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
                  context, MaterialPageRoute(builder: (context) => Logar())), // edit 10-06 - can cause error
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text('Cadastro de usuário'),
          centerTitle: true,
          backgroundColor: APP_BAR_COLOR,
        ),
        body: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height + 200),
              child: Column(
                children: <Widget>[
                  Divider(
                    color: null,
                  ),
                  Container(
                      width: MediaQuery.of(context).size.width / 1.2,
                      padding: EdgeInsets.all(10.0),
                      child: TextField(
                        style: TextStyle(fontSize: 16, color: Colors.black),
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
                        style: TextStyle(fontSize: 16, color: Colors.black),
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
                        style: TextStyle(fontSize: 16, color: Colors.black),
                        controller: emailController,
                        autocorrect: true,
                        decoration: InputDecoration(
                          hintText: 'Seu e-mail',
                          labelText: "e-mail",
                          border: OutlineInputBorder(),
                        ),
                      )),
                      Container(
                      width: MediaQuery.of(context).size.width / 1.2,
                      padding: EdgeInsets.all(10.0),
                      child: TextField(
                        onChanged: (cpf_usuario){

                          if(cpf_usuario == ""){
                            setState(() {
                              _valid_cpf = "Digite o CPF";
                            });
                          }else{

                            if (CPF.isValid(cpf_usuario)){
                              setState(() {
                                _valid_cpf = "CPF válido";
                              });
                            }else{
                              setState(() {
                                _valid_cpf = "CPF inválido";
                              });
                            }
                          }
                        } ,
                        style: TextStyle(fontSize: 16, color: Colors.black),
                        controller: cpfController,
                        autocorrect: true,
                        decoration: InputDecoration(
                          hintText: 'Digite o CPF',
                          labelText: 'CPF',
                          border: OutlineInputBorder(),
                        ),
                      )),
                      Text(_valid_cpf),
                  Container(
                      width: MediaQuery.of(context).size.width / 1.2,
                      padding: EdgeInsets.all(10.0),
                      child: TextField(
                        style: TextStyle(fontSize: 16, color: Colors.black),
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
                        style: TextStyle(fontSize: 16, color: Colors.black),
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
                        style: TextStyle(fontSize: 16, color: Colors.black),
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
                  
                ],

              ),
            ),
              

                              ),
            );
  }
}
