import 'dart:io';
import 'package:app_constroca/home_bar.dart';
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
  String _valid_tel = "";
  final telController = MaskedTextController(mask: '(00)00000-0000');

  bool visible = false;
  bool _validate = false;
  String nome, login_usuario, email, cpf, telefone, cidade, password;
  String nome_imagem = "default.png";

  static final String uploadEndPoint = 'https://constroca-webservice-app.herokuapp.com/uploadftp';

  Future<File> file;
  String status = '';
  String base64Image;
  File tmpFile;
  var img;
  Response res;
  String errMessage = 'Erro ao carregar imagem';

  Future<File> getImage() async {
    var file = await ImagePicker.pickImage(
      imageQuality: 50,
      source: ImageSource.camera,
    );
    setState(() {
      tmpFile = file;
      status = file.path.split('/').last;
    });
    print(file.path);
    _upload(file);
  }

  Future<File> getImageGallery() async {
    var file = await ImagePicker.pickImage(
      imageQuality: 50,
      source: ImageSource.gallery,
    );
    setState(() {
      tmpFile = file;
      status = file.path.split('/').last;
    });
    print(file.path);
    _upload(file);
  }

  void _upload(File file) async {
    String fileName = file.path.split('/').last;
    nome_imagem = fileName;

    setState(() {
      visible = true;
      res = null;
    });
    FormData data = FormData.fromMap({
      "file": await MultipartFile.fromFile(
        file.path,
        filename: fileName,
      ),
    });

    Dio dio = new Dio();

    dio
        .post("https://constroca-webservice-app.herokuapp.com/uploadftp", data: data)
        .then((response) => {
              res = response,
              setState(() => {
                    visible = false,
                  }),
            })
        .catchError((error) => print(error));
  }

  setStatus(String message) {
    setState(() {
      status = message;
    });
  }

  Widget showImage() {
    return GestureDetector(
      onTap: () => getImage(),
      child: Container(
          alignment: Alignment.center,
          child: tmpFile != null
              ? Container(
                  child: Container(
                  width: 120,
                  height: 120,
                  decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(image: FileImage(tmpFile.absolute), fit: BoxFit.cover)),
                ))
              : Container(
                  width: 120,
                  height: 120,
                  decoration: new BoxDecoration(
                    shape: BoxShape.circle,
                    image: new DecorationImage(fit: BoxFit.cover, image: AssetImage('assets/camera.png')),
                  ))),
    );
  }

  Future cadastrar() async {
    key:
    ValueKey("teste");
    setState(() {
      visible = true;
    });

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
        SizedBox(
          height: 20.0,
        ),
        showImage(),
        SizedBox(
          height: 20.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              onPressed: () => getImage(),
              child: Icon(Icons.camera_enhance),
            ),
            Padding(
              padding: EdgeInsets.all(10),
            ),
            RaisedButton(
              onPressed: () => getImageGallery(),
              child: Icon(Icons.image),
            ),
          ],
        ),
        SizedBox(
          height: 20.0,
        ),

        Container(
          height: 70,
          child: new TextFormField(
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
        ),
        Padding(padding: EdgeInsets.only(top: 2)),
        Container(
          height: 70,
          child: new TextFormField(
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
        ),
        Padding(padding: EdgeInsets.only(top: 2)),
        Container(
          height: 70,
          child: new TextFormField(
              decoration: new InputDecoration(
                hintText: 'DDD/Telefone',
                labelText: 'Telefone celular',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
              maxLength: 11,
              validator: _validarTelefone,
              onSaved: (String val) {
                telefone = val;
              }),
        ),
        Padding(padding: EdgeInsets.only(top: 2)),
        Container(
          height: 70,
          child: new TextFormField(
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
        ),
        Padding(padding: EdgeInsets.only(top: 2)),
        Container(
          height: 70,
          child: new TextFormField(
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
        ),
        Padding(padding: EdgeInsets.only(top: 2)),
        Container(
          height: 70,
          child: new TextFormField(
              decoration: new InputDecoration(
                hintText: 'Cidade',
                labelText: 'Cidade',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.text,
              maxLength: 30,
              validator: _validarCidade,
              onSaved: (String val) {
                cidade = val;
              }),
        ),
        Padding(padding: EdgeInsets.only(top: 2)),
        Container(
          height: 70,
          child: new TextFormField(
              decoration: new InputDecoration(
                hintText: 'Senha',
                labelText: 'Senha',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
              keyboardType: TextInputType.text,
              maxLength: 20,
              validator: _validarSenha,
              onSaved: (String val) {
                password = val;
              }),
        ),
        new SizedBox(height: 50.0),
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
    String patttern = r'(^[ã-õâ-ûá-ú a-zA-Z ]*$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return "Informe o nome";
    } else if (!regExp.hasMatch(value)) {
      return "O nome deve conter caracteres de a-z ou A-Z";
    }
    return null;
  }

  String _validarCidade(String value) {
    String patttern = r'(^[a-zA-Z à-úÀ-Ú0-9]*$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length < 1) {
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
      //} else if (!CPF.isValid(value)) {
    } else if (value.length != 14) {
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
    String patttern = r'(^[a-zA-Z à-úÀ-Ú0-9\\!\\@\\#\\$\\%\\&\\*\\(\\)\\<\\>\\,\\.\\?\\/\\:\\;\\\\\|\\]\\*\\]$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return "Informe a senha";
    } else if (value.length < 8) {
      return "Senha deve ter pelo menos 8 caracteres";
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
