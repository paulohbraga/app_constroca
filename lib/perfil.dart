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
  PerfilUserState createState() => PerfilUserState();
}

class PerfilUserState extends State {
  // For CircularProgressIndicator.
  bool visible = false;

  // Getting value from TextField widget.
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final appData = AppData();

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

    // Store all data with Param Name.
    var data = {'email': email, 'password': password};

    // Starting Web API Call.
    var response = await http.post(url, body: json.encode(data));
    var response_id = await http.post(url_id_usuario, body: json.encode(data));
    var response_img = await http.post(url_img_usuario, body: json.encode(data));

    // Getting Server response into variable.
    var message = jsonDecode(response.body);
    var id = jsonDecode(response_id.body);
    var avatar = jsonDecode(response_img.body);
    appData.id_usuario = id;
    appData.avatar = avatar;

    // If the Response Message is Matched.
    if (message == 'Usuario existe') {
      // Hiding the CircularProgressIndicator.
      setState(() {
        visible = false;
      });

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('id', appData.id_usuario);

      // Navigate to Profile Screen & Sending Email to Next Screen.
      Navigator.push(context, MaterialPageRoute(builder: (context) => CadastroProduto(id: appData.id_usuario)));
    } else {
      // If Email or Password did not Matched.
      // Hiding the CircularProgressIndicator.
      setState(() {
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
                        'http://192.168.15.10/api/usuario/imagens/' + appData.avatar + "",
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                      ),
                    )),
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        appData.nome_usuario,
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
                          "Cidade: " + appData.cidade,
                          style: TextStyle(fontSize: 20, color: Colors.black),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 5, top: 25),
                        child: Text(
                          "Telefone: " + appData.telefone,
                          style: TextStyle(fontSize: 20, color: Colors.black),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 5, top: 25),
                        child: Text(
                          "e-mail: " + appData.email,
                          style: TextStyle(fontSize: 20, color: Colors.black),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 5, top: 25),
                        child: Text(
                          "Produtos cadastrados: " + appData.count_produtos,
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
                    onPressed: () => Navigator.push(
                        context, MaterialPageRoute(builder: (context) => CadastroProduto(id: appData.id_usuario))),
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
              Row(
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
            ],
          ),
        )));
  }
}
