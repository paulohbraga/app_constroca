import 'package:app_constroca/cadastroProduto.dart';
import 'package:app_constroca/inicio.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'constants.dart';
import 'cadastro.dart';
import 'package:requests/requests.dart';
import 'appdata.dart';

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

  final appdata = AppData();

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
    var url = 'http://192.168.15.4/api/login/login.php';

    var url_id_usuario = 'http://192.168.15.4/api/usuario/getidusuario.php';
    var url_img_usuario = 'http://192.168.15.4/api/usuario/getimgusuario.php';

    // Store all data with Param Name.
    var data = {'email': email, 'password': password};

    // Starting Web API Call.
    var response = await http.post(url, body: json.encode(data));
    var response_id = await http.post(url_id_usuario, body: json.encode(data));
    var response_img =
        await http.post(url_img_usuario, body: json.encode(data));

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
      prefs.setString('id', id);

      // Navigate to Profile Screen & Sending Email to Next Screen.
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => CadastroProduto(id: id)));
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
            backgroundColor: APP_BAR_COLOR,
            centerTitle: true,
            title: Text('Perfil')),
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
            child: Center(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.width / 3.5),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      RaisedButton(
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    CadastroProduto(id: appdata.id_usuario))),
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
                              borderRadius: BorderRadius.circular(10.0)),
                          child: Container(
                            constraints: BoxConstraints(
                                maxWidth: 180.0, minHeight: 40.0),
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
                        onPressed: () => {
                          appData.id_usuario = null,
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      CadastroProduto(id: appdata.id_usuario))),
                        },
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
                              borderRadius: BorderRadius.circular(10.0)),
                          child: Container(
                            constraints: BoxConstraints(
                                maxWidth: 140.0, minHeight: 40.0),
                            alignment: Alignment.center,
                            child: Text(
                              "Sair",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ]),
              ),
              Visibility(
                  visible: visible,
                  child: Container(
                      margin: EdgeInsets.only(bottom: 30),
                      child: CircularProgressIndicator())),
            ],
          ),
        )));
  }
}

class ProfileScreen extends StatelessWidget {
// Creating String Var to Hold sent Email.
  final String email;

// Receiving Email using Constructor.
  ProfileScreen({Key key, @required this.email}) : super(key: key);

// User Logout Function.
  logout(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            appBar: AppBar(
                title: Text('Nova tela'), automaticallyImplyLeading: false),
            body: Center(
                child: Column(
              children: <Widget>[
                Container(
                    width: 280,
                    padding: EdgeInsets.all(10.0),
                    child: Text('Email = ' + '\n' + email,
                        style: TextStyle(fontSize: 20))),
                RaisedButton(
                  onPressed: () {
                    logout(context);
                  },
                  color: Colors.red,
                  textColor: Colors.white,
                  child: Text('Clique pra sair'),
                ),
              ],
            ))));
  }
}
