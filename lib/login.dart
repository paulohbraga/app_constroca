import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'cadastro.dart';


class Logar extends StatelessWidget {
@override
Widget build(BuildContext context) {
return MaterialApp(
          debugShowCheckedModeBanner: false,

  home: Scaffold(
    
      appBar: AppBar(
        backgroundColor: Colors.teal[900],
        centerTitle: true,
        title: Text('Login do usuário'
        
      )),
      body: Center(
        child: LoginUser()
        )
      )
    );
}
}

class LoginUser extends StatefulWidget {

LoginUserState createState() => LoginUserState();

}

class LoginUserState extends State {

  // For CircularProgressIndicator.
  bool visible = false ;

  // Getting value from TextField widget.
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

Future userLogin() async{

  // Showing CircularProgressIndicator.
  setState(() {
  visible = true ; 
  });

  // Getting value from Controller
  String email = emailController.text;
  String password = passwordController.text;

  // SERVER LOGIN API URL
  var url = 'http://192.168.15.2/api/login/login.php';

  // Store all data with Param Name.
  var data = {'email': email, 'password' : password};

  // Starting Web API Call.
  var response = await http.post(url, body: json.encode(data));

  // Getting Server response into variable.
  var message = jsonDecode(response.body);

  // If the Response Message is Matched.
  if(message == 'OK')
  {

    // Hiding the CircularProgressIndicator.
      setState(() {
      visible = false; 
      });

    // Navigate to Profile Screen & Sending Email to Next Screen.
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProfileScreen(email : emailController.text) )
      );
  }else{

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
    );}

}

@override
Widget build(BuildContext context) {
return Scaffold(
  body: SingleChildScrollView(
    child: Center(
    child: Column(
      children: <Widget>[

        
        Divider(),          

        Container(
        width: 280,
        padding: EdgeInsets.all(10.0),
        child: TextField(
            controller: emailController,
            autocorrect: true,
            decoration: InputDecoration(hintText: 'Email'),
          )
        ),

        Container(
        width: 280,
        padding: EdgeInsets.all(10.0),
        child: TextField(
            controller: passwordController,
            autocorrect: true,
            obscureText: true,
            decoration: InputDecoration(hintText: 'Senha'),
          )
        ),

        Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              
              children:
             <Widget>[
                        RaisedButton(
                          color: Colors.orange,
                          child: Text("Entrar"),
                          onPressed: userLogin,
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
            margin: EdgeInsets.only(bottom: 30),
            child: CircularProgressIndicator()
            )
          ),

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
logout(BuildContext context){

  Navigator.pop(context);

}

@override
Widget build(BuildContext context) {
return MaterialApp(
  home: Scaffold(
      appBar: AppBar(title: Text('Nova tela'),
      automaticallyImplyLeading: false),
      body: Center(
        child: Column(children: <Widget>[

          Container(
          width: 280,
          padding: EdgeInsets.all(10.0),
          child: Text('Email = ' + '\n' + email, 
                style: TextStyle(fontSize: 20))
            ),

          RaisedButton(
          onPressed: () {
            logout(context);
          },
          color: Colors.red,
          textColor: Colors.white,
          child: Text('Clique pra sair'),
        ),

        ],)
        )
      )
    );
}
}