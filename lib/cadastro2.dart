import 'dart:io';
import 'package:app_constroca/inicio.dart';
import 'package:crypto/crypto.dart' as crypto;
import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'constants.dart';
import 'package:cpfcnpj/cpfcnpj.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'login.dart';
import 'package:image_picker/image_picker.dart';

class Cadastro2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: TransfterData());
  }
}

class TransfterData extends StatefulWidget {
  TransfterDataWidget createState() => TransfterDataWidget();
}

class TransfterDataWidget extends State {
  GlobalKey<FormState> _key = new GlobalKey();

  // Getting value from TextField widget.
  String _valid_cpf = "";
  final cpfController = MaskedTextController(mask: '000.000.000-00');

  // Boolean variable for CircularProgressIndicator.
  bool visible = false;
  bool _validate = false;
  String nome, login_usuario, email, cpf, telefone, cidade, password;
  String nome_imagem = "default.png";
  // Boolean variable for CircularProgressIndicator.

  static final String uploadEndPoint = 'https://constroca-webservice-app.herokuapp.com/uploadimageuser';

  Future<File> file;
  String status = '';
  String base64Image;
  File tmpFile;
  var img;
  String errMessage = 'Erro ao carregar imagem';

  Future<File> getImage() async {
    var file = await ImagePicker.pickImage(
        source: ImageSource.gallery,
        maxHeight: 500, // <- reduce the image size
        maxWidth: 500);
    _upload(file);
    setState(() {
      status = file.path.split('/').last;
    });
  }

  void _upload(File file) async {
    String fileName = file.path.split('/').last;
    nome_imagem = fileName;

    FormData data = FormData.fromMap({
      "file": await MultipartFile.fromFile(
        file.path,
        filename: fileName,
      ),
    });

    Dio dio = new Dio();

    dio
        .post("https://constroca-webservice-app.herokuapp.com/uploadimageuser", data: data)
        .then((response) => print(response))
        .catchError((error) => print(error));
  }

  setStatus(String message) {
    setState(() {
      status = message;
    });
  }

  Widget showImage() {
    return Container(
      alignment: Alignment.center,
      child: status == ''
          ? Center(child: Text('Imagem não selecionada'))
          : Container(
              width: 150,
              height: 150.0,
              decoration: new BoxDecoration(
                shape: BoxShape.circle,
                image: new DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage('https://constroca-webservice-app.herokuapp.com/imagens/' + status)),
              )),
    );
  }

  Future cadastrar() async {
    // Showing CircularProgressIndicator using State.
    key:
    ValueKey("teste");
    setState(() {
      visible = true;
    });

    // Getting value from Controller

    // API URL
    var url = 'https://constroca-webservice-app.herokuapp.com/usuarios';

    // Store all data with Param Name.
    var data = {
      'nome': nome,
      'login_usuario': login_usuario,
      'email': email,
      'cpf': cpf,
      'telefone': telefone,
      'cidade': cidade,
      'password': password,
      'avatar': nome_imagem
    };

    // Starting Web Call with data.
    var response = await http.post(url,
        body: json.encode(data), headers: {'Content-type': 'application/json', 'Accept': 'application/json'});

    // Getting Server response into variable.
    var message = jsonDecode(response.body);

    // If Web call Success than Hide the CircularProgressIndicator.
    if (response.statusCode == 201) {
      setState(() {
        visible = false;
      });
    }

    // mostrar mensagem json na dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(
            "Usuário cadastrado com sucesso",
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            FlatButton(
              child: new Text("OK"),
              onPressed: () => Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Inicio())), // editado 10-06 - tinha erro de rota
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
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Logar())),
        ),
        title: Text("Cadastro de usuário", style: TextStyle(fontFamily: 'Raleway')),
        flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: <Color>[Colors.blue[800], Colors.blue]))),
        centerTitle: true,
        backgroundColor: APP_BAR_COLOR,
      ),
      body: new SingleChildScrollView(
        child: new Container(
          margin: new EdgeInsets.all(15.0),
          child: new Form(
            key: _key,
            autovalidate: _validate,
            child: _formUI(),
          ),
        ),
      ),
    );
  }

  Widget _formUI() {
    return new Column(
      children: <Widget>[
        OutlineButton(
          onPressed: () => getImage(),
          child: Text('Selecionar imagem'),
        ),
        SizedBox(
          height: 20.0,
        ),
        showImage(),
        SizedBox(
          height: 20.0,
        ),
        SizedBox(
          height: 20.0,
        ),

        new TextFormField(
          decoration: new InputDecoration(
            hintText: 'Nome Completo',
            labelText: 'Seu nome',
            border: OutlineInputBorder(),
          ),
          maxLength: 40,
          validator: _validarNome,
          onSaved: (String val) {
            nome = val;
          },
        ),
        new TextFormField(
            decoration: new InputDecoration(
              hintText: 'Login/Nickname',
              labelText: 'Login',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.text,
            maxLength: 11,
            validator: _validarNome,
            onSaved: (String val) {
              login_usuario = val;
            }),
        new TextFormField(
            decoration: new InputDecoration(
              hintText: 'DDD/Telefone',
              labelText: 'Telefone',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.phone,
            maxLength: 11,
            validator: _validarTelefone,
            onSaved: (String val) {
              telefone = val;
            }),
        new TextFormField(
            decoration: new InputDecoration(
              hintText: 'Email',
              labelText: 'Email',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.emailAddress,
            maxLength: 40,
            validator: _validarEmail,
            onSaved: (String val) {
              email = val;
            }),
        new TextFormField(
            decoration: new InputDecoration(
              hintText: 'CPF',
              labelText: 'CPF',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            maxLength: 14,
            controller: cpfController,
            validator: _validarCpf,
            onSaved: (String val) {
              cpf = val;
            }),

        new TextFormField(
            decoration: new InputDecoration(
              hintText: 'Cidade',
              labelText: 'Cidade',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.text,
            maxLength: 11,
            validator: _validarCidade,
            onSaved: (String val) {
              cidade = val;
            }),
        new TextFormField(
            decoration: new InputDecoration(
              hintText: 'Senha',
              labelText: 'Senha',
              border: OutlineInputBorder(),
            ),
            obscureText: true,
            keyboardType: TextInputType.text,
            maxLength: 11,
            validator: _validarSenha,
            onSaved: (String val) {
              password = val;
            }),
        new SizedBox(height: 100.0),
        new RaisedButton(
          onPressed: _sendForm,
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
              constraints: BoxConstraints(maxWidth: 200.0, minHeight: 40.0),
              alignment: Alignment.center,
              child: Text(
                "Cadastrar usuário",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontFamily: 'Raleway'),
              ),
            ),
          ),
        ),
        // new RaisedButton(
        //   onPressed: _sendForm,
        //   child: new Text('Enviar'),

        // ),
        new Container(
          margin: EdgeInsets.only(bottom: 200, top: 10),
        ),
      ],
    );
  }

  String _validarNome(String value) {
    String patttern = r'(^[a-zA-Z ]*$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return "Informe o nome";
    } else if (!regExp.hasMatch(value)) {
      return "O nome deve conter caracteres de a-z ou A-Z";
    }
    return null;
  }

  String _validarCidade(String value) {
    String patttern = r'(^[a-zA-Z ]*$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length < 2) {
      return "Informe o nome da cidade corretamente";
    } else if (!regExp.hasMatch(value)) {
      return "O nome da cidade deve conter caracteres de a-z ou A-Z";
    }
    return null;
  }

  String _validarCpf(String value) {
    String patttern = r'(^[a-zA-Z ]*$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return "Informe o cpf";
    } else if (!CPF.isValid(value)) {
      return "CPF Inválido";
    }
    return null;
  }

  String _validarTelefone(String value) {
    String patttern = r'(^[0-9]*$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return "Informe o celular";
    } else if (value.length != 11) {
      return "O celular deve ter 11 dígitos";
    } else if (!regExp.hasMatch(value)) {
      return "O número do celular so deve conter dígitos";
    }
    return null;
  }

  String _validarSenha(String value) {
    String patttern = r'(^[0-9]*$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return "Informe a senha";
    } else if (!regExp.hasMatch(value)) {
      return "Senha inválida";
    } else {
      return null;
    }
  }

  String _validarEmail(String value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "Informe o Email";
    } else if (!regExp.hasMatch(value)) {
      return "Email inválido";
    } else {
      return null;
    }
  }

  _sendForm() {
    if (_key.currentState.validate()) {
      // Sem erros na validação
      _key.currentState.save();
      print("Nome $nome");
      print("TEL $telefone");
      print("Email $email");
      print("nike $login_usuario");
      print("cpf $cpf");
      print("cidade $cidade");
      print("senha $password");
      cadastrar();
    } else {
      // erro de validação
      setState(() {
        _validate = true;
      });
    }
  }
}
