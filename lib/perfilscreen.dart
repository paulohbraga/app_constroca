import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'home.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'home2.dart';
import 'home_widget.dart';
import 'cadastro.dart';

class PerfilScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            appBar: AppBar(
              title: Text('Login'),
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
  final senhaController = TextEditingController();

  // Boolean variable for CircularProgressIndicator.
  bool visible = false;

  Future webCall() async {
    // Showing CircularProgressIndicator using State.
    setState(() {
      visible = true;
    });

    // Getting value from Controller
    String nome = nomeController.text;
    String loginUsuario = loginUsuarioController.text;
    String email = emailController.text;
    String telefone = telefoneController.text;
    String cidade = cidadeController.text;
    String senha = senhaController.text;

    // API URL
    var url = 'http://192.168.15.6/api/usuario/checkuser.php';

    // Store all data with Param Name.
    var data = {
      'nome': nome,
      'login_usuario': loginUsuario,
      'email': email,
      'telefone': telefone,
      'cidade': cidade,
      'senha': senha
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
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyApp()),
                );
              },
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

         
          Container(
              width: 280,
              padding: EdgeInsets.all(10.0),
              child: TextField(
                controller: loginUsuarioController,
                autocorrect: true,
                decoration: InputDecoration(hintText: 'Login usuário'),
              )),
         
          Container(
              width: 280,
              padding: EdgeInsets.all(10.0),
              child: TextField(
                controller: senhaController,
                autocorrect: true,
                decoration: InputDecoration(hintText: 'Senha'),
              )),
         

          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              
              children:
             <Widget>[
                        RaisedButton(
                          color: Colors.orange,
                          child: Text("Entrar"),
                          onPressed: webCall,
                        ),
                      
                        RaisedButton(
                          color: Colors.orange,
                          child: Text("Cadastrar"),
                          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Cadastro())),
                        ),

                        RaisedButton(
                          color: Colors.orange,
                          child: Text("Esqueci a senha"),
                          onPressed: () => null,
                        ),
                      
                    ]),
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
