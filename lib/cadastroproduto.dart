import 'package:app_constroca/perfil.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'inicio.dart';
import 'dart:io';

class CadastroProduto extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            appBar: AppBar(
              title: Text('Cadastrar novo produto'),
              centerTitle: true,
              backgroundColor: Colors.teal[900],
            ),
            body: Center(child: TransfterData())));
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
    String login_Usuario = loginUsuarioController.text;
    String email = emailController.text;
    String telefone = telefoneController.text;
    String cidade = cidadeController.text;
    String password = passwordController.text;

    // API URL
    var url = 'http://192.168.15.2/api/usuario/create.php';

    // Store all data with Param Name.
    var data = {
      'nome': nome,
      'login_usuario': login_Usuario,
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
        body: SingleChildScrollView(
            child: Center(
      child: Column(
        children: <Widget>[
          Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text('Preencha todos os campos',
                  style: TextStyle(fontSize: 22))),
          Container(
              width: MediaQuery.of(context).size.width / 1.1,
              padding: EdgeInsets.all(10.0),
              child: TextField(
                controller: nomeController,
                autocorrect: true,
                decoration: InputDecoration(
                  hintText: 'Produto',
                  border: OutlineInputBorder(),
                ),
              )),
          Container(
              width: MediaQuery.of(context).size.width / 1.1,
              padding: EdgeInsets.all(10),
              child: TextField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                controller: loginUsuarioController,
                autocorrect: true,
                decoration: InputDecoration(
                  hintText: 'Descrição',
                  border: OutlineInputBorder(),
                ),
              )),
          Container(
              width: MediaQuery.of(context).size.width / 1.1,
              padding: EdgeInsets.all(10),
              child: new DropdownButton<String>(
                items: <String>['Troca', 'Doação'].map((String value) {
                  return new DropdownMenuItem<String>(
                    value: value,
                    child: new Text(value),
                  );
                }).toList(),
                onChanged: (_) {},
              )),
        
          RaisedButton(
            onPressed: cadastrar,
            color: Colors.orange[400],
            textColor: Colors.white,
            padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
            child: Text('Cadastrar produto'),
          ),
          Visibility(
              visible: visible,
              child: Container(
                  margin: EdgeInsets.only(bottom: 30, top: 10),
                  child: CircularProgressIndicator())),
        ],
      ),
    )));
  }
}
