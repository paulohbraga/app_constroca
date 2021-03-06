import 'dart:convert';
import 'package:app_constroca/providers/MessagesProvider.dart';
import 'package:app_constroca/recover_password.dart';
import 'package:app_constroca/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'appdata.dart';
import 'constants.dart';
import 'form_user.dart';
import 'user_profile.dart';

class LoginUser extends StatefulWidget {
  LoginUserState createState() => LoginUserState();
}

class LoginUserState extends State {
  // For CircularProgressIndicator.
  bool visible = false;
  final snackBar = SnackBar(
      content: Text('Usuário ou senha inválidos. Tente novamente.', style: TextStyle(color: Colors.white)),
      backgroundColor: Colors.blue[900]);
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
    var url = 'https://constroca-webservice-app.herokuapp.com/login';

    var data = {'email': email, 'password': password};

    var response = await http.post(url,
        body: json.encode(data), headers: {'Content-type': 'application/json', 'Accept': 'application/json'});
    //HACK to convert special chars from response
    String source = Utf8Decoder().convert(response.bodyBytes);
    // Getting Server response into variable.
    var message = json.decode(source);
    appData.id_usuario = message['id'].toString();
    appData.message = message;

    // If the Response Message is Matched.
    if (message["id"] != null) {
      //print(message);
      // Hiding the CircularProgressIndicator.
      setState(() {
        visible = false;
      });

      // Navigate to Profile Screen & Sending Email to Next Screen.
      Navigator.push(context, MaterialPageRoute(builder: (context) => PerfilUser()));
      //CadastroProduto( id: id)));
    } else {
      // If Email or Password did not Matched.
      // Hiding the CircularProgressIndicator.
      setState(() {
        appData.id_usuario = null;
        appData.cidade = null;
        appData.nome_usuario = null;
        appData.telefone = null;
        visible = false;
      });
      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: false,
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
        body: Container(
          height: MediaQuery.of(context).size.height - 200,
          constraints: new BoxConstraints.expand(height: MediaQuery.of(context).size.height),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: ClipOval(
                        child: Image.asset(
                      teclado ? 'assets/avatar_expressions.gif' : 'assets/closing_eyes.gif',
                      gaplessPlayback: true,
                      fit: BoxFit.cover,
                      width: 100.0,
                      height: 100.0,
                    ))),
                Container(
                    width: 290,
                    height: 55,
                    child: TextField(
                      style: TextStyle(fontSize: 15, color: Colors.black, fontFamily: 'Raleway'),
                      controller: emailController,
                      autocorrect: true,
                      decoration: InputDecoration(
                        // hintText: 'e-mail',
                        labelText: 'Digite seu e-mail',
                      ),
                    )),
                Padding(padding: const EdgeInsets.only(top: 20)),
                Container(
                    width: 290,
                    height: 55,
                    child: TextField(
                      style: TextStyle(fontSize: 15, color: Colors.black, fontFamily: 'Raleway'),
                      controller: passwordController,
                      onChanged: (text) {
                        setState(() {
                          teclado = false;
                          //debugPrint(teclado.toString());
                        });
                      },
                      obscureText: true,
                      decoration: InputDecoration(
                        //hintText: 'Senha',
                        labelText: 'Senha',
                      ),
                    )),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
                    RaisedButton(
                      onPressed: () => {
                        userLogin(),
                        FocusScope.of(context).requestFocus(new FocusNode()),
                      },
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                      padding: EdgeInsets.all(0.0),
                      child: Ink(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.blue[800], Colors.blue[800]],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(5.0)),
                        child: Container(
                          constraints: BoxConstraints(maxWidth: 90.0, minHeight: 40.0),
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
                      onPressed: () => {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Cadastro2())),
                        setState(() {
                          teclado = true;
                          //debugPrint(teclado.toString());
                        })
                      },
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
                      padding: EdgeInsets.all(0.0),
                      child: Ink(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.blue[800], Colors.blue[800]],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(5.0)),
                        child: Container(
                          constraints: BoxConstraints(maxWidth: 90.0, minHeight: 40.0),
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
                      key: Key("botao"),
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Recover())),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
                      padding: EdgeInsets.all(0.0),
                      child: Ink(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.blue[800], Colors.blue[800]],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(5.0)),
                        child: Container(
                          constraints: BoxConstraints(maxWidth: 110.0, minHeight: 40.0),
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
                Container(height: 300)
              ],
            ),
          ),
        ));
  }
}
