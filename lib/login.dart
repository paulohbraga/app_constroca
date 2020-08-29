import 'package:app_constroca/perfil.dart';
import 'package:app_constroca/recover.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'constants.dart';
import 'cadastro2.dart';
import 'appdata.dart';
import 'perfil.dart';

class Logar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginUser(),
    );
  }
}

class LoginUser extends StatefulWidget {
  LoginUserState createState() => LoginUserState();
}

class LoginUserState extends State {
  // For CircularProgressIndicator.
  bool visible = false;

  // Getting value from TextField widget.
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final appData = AppData();
  bool teclado = true;

  var image1 = Image.asset("assets/avatar_expressions.gif");
  var image2 = Image.asset("assets/new.gif");

  Future userLogin() async {
    // Showing CircularProgressIrndicator.
    setState(() {
      visible = true;
    });

    // Getting value from Controller
    String email = emailController.text;
    String password = passwordController.text;

    // SERVER LOGIN API URL
    var url = 'http://192.168.15.10/api/login/login.php';

    var url_id_usuario = 'http://192.168.15.10/api/usuario/getidusuario.php';
    var url_img_usuario = 'http://192.168.15.10/api/usuario/getimgusuario.php';
    var url_nome_usuario = 'http://192.168.15.10/api/usuario/getnomeusuario.php';
    var url_cidade = 'http://192.168.15.10/api/usuario/getcidadeusuario.php';
    var url_telefone = 'http://192.168.15.10/api/usuario/gettelefoneusuario.php';
    var url_email = 'http://192.168.15.10/api/usuario/getemailusuario.php';
    var url_count = 'http://192.168.15.10/api/usuario/getprodutosusuario.php';

    // Store all data with Param Name.
    var data = {'email': email, 'password': password};

    // Starting Web API Call.
    var response = await http.post(url, body: json.encode(data));
    var response_id = await http.post(url_id_usuario, body: json.encode(data));
    var response_img = await http.post(url_img_usuario, body: json.encode(data));
    var response_nome = await http.post(url_nome_usuario, body: json.encode(data));
    var response_cidade = await http.post(url_cidade, body: json.encode(data));
    var response_telefone = await http.post(url_telefone, body: json.encode(data));
    var response_email = await http.post(url_email, body: json.encode(data));
    var response_produtos = await http.post(url_count, body: json.encode(data));

    // Getting Server response into variable.
    var message = jsonDecode(response.body);
    var id = jsonDecode(response_id.body);
    var avatar = jsonDecode(response_img.body);
    var nome = jsonDecode(response_nome.body);
    var cidade = jsonDecode(response_cidade.body);
    var telefone = jsonDecode(response_telefone.body);
    var email_user = jsonDecode(response_email.body);
    var user_prod_count = jsonDecode(response_produtos.body);

    appData.id_usuario = id;
    appData.avatar = avatar;
    appData.nome_usuario = nome;
    appData.cidade = cidade;
    appData.telefone = telefone;
    appData.email = email_user;
    appData.count_produtos = user_prod_count;

    // If the Response Message is Matched.
    if (message == 'Usuario existe') {
      // Hiding the CircularProgressIndicator.
      setState(() {
        visible = false;
      });

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('id', id);

      // Navigate to Profile Screen & Sending Email to Next Screen.
      Navigator.push(context, MaterialPageRoute(builder: (context) => PerfilUser()));
      //CadastroProduto( id: id)));
    } else {
      // If Email or Password did not Matched.
      // Hiding the CircularProgressIndicator.
      setState(() {
        appData.cidade = null;
        appData.nome_usuario = null;
        appData.telefone = null;
        visible = false;
      });

      // Showing Alert Dialog with Response JSON Message.
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text(message),
            actions: <Widget>[
              FlatButton(
                child: new Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
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
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
            backgroundColor: APP_BAR_COLOR,
            centerTitle: true,
            title: Text(
              "Login do usuário",
              style: TextStyle(fontFamily: 'Raleway'),
            ),
            flexibleSpace: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: <Color>[Colors.blue[800], Colors.blue])))),
        body: SingleChildScrollView(
            child: Container(
          child: Column(
            children: <Widget>[
              Padding(padding: const EdgeInsets.only(top: 30)),
              Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ClipOval(
                      child: Image.asset(
                    teclado ? 'assets/avatar_expressions.gif' : 'assets/closing_eyes.gif',
                    gaplessPlayback: true,
                    fit: BoxFit.cover,
                    width: 150.0,
                    height: 150.0,
                  ))),
              Container(
                  width: 280,
                  padding: EdgeInsets.all(10.0),
                  child: TextField(
                    style: TextStyle(fontSize: 15, color: Colors.black, fontFamily: 'Raleway'),
                    controller: emailController,
                    autocorrect: true,
                    decoration: InputDecoration(
                      // hintText: 'e-mail',
                      labelText: 'Digite seu e-mail',
                      border: OutlineInputBorder(),
                    ),
                  )),
              Container(
                  width: 280,
                  padding: EdgeInsets.all(10.0),
                  child: TextField(
                    style: TextStyle(fontSize: 15, color: Colors.black, fontFamily: 'Raleway'),
                    controller: passwordController,
                    onChanged: (text) {
                      setState(() {
                        teclado = false;
                        debugPrint(teclado.toString());
                      });
                    },
                    autocorrect: true,
                    obscureText: true,
                    decoration: InputDecoration(
                      //hintText: 'Senha',
                      labelText: 'Senha',
                      border: OutlineInputBorder(),
                    ),
                  )),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
                  RaisedButton(
                    onPressed: userLogin,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
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
                        constraints: BoxConstraints(maxWidth: 100.0, minHeight: 40.0),
                        alignment: Alignment.center,
                        child: Text(
                          "Login",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontFamily: 'Raleway'),
                        ),
                      ),
                    ),
                  ),
                  RaisedButton(
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Cadastro2())),
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
                        constraints: BoxConstraints(maxWidth: 100.0, minHeight: 40.0),
                        alignment: Alignment.center,
                        child: Text(
                          "Cadastro",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontFamily: 'Raleway'),
                        ),
                      ),
                    ),
                  ),
                  RaisedButton(
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Recover())),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
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
                        constraints: BoxConstraints(maxWidth: 140.0, minHeight: 40.0),
                        alignment: Alignment.center,
                        child: Text(
                          "Esqueci a senha",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontFamily: 'Raleway'),
                        ),
                      ),
                    ),
                  ),
                ]),
              ),
              Visibility(
                  visible: visible,
                  child: Container(margin: EdgeInsets.only(bottom: 30), child: CircularProgressIndicator())),
            ],
          ),
        )));
  }
}
