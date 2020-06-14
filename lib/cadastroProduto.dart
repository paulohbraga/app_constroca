import 'dart:io';

import 'package:app_constroca/login.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'constants.dart';

class CadastroProduto extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false, home: TransfterData());
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
  int contador;
  String nome_imagem;
  // Boolean variable for CircularProgressIndicator.
  bool visible = false;

  static final String uploadEndPoint =
      'http://192.168.15.2/api/produto/image_save.php';

  Future<File> file;
  String status = '';
  String base64Image;
  File tmpFile;
  String errMessage = 'Erro ao carregar imagem';

  chooseImage() {
    setState(() {
      file = ImagePicker.pickImage(source: ImageSource.gallery);
    });
    setStatus('');
  }

  setStatus(String message) {
    setState(() {
      status = message;
    });
  }

  startUpload() {
    
    setStatus('Enviando imagem...');
    if (null == tmpFile) {
      setStatus(errMessage);
      return;
    }
    String fileName = tmpFile.path.split('/').last;
    nome_imagem = fileName;

    upload(fileName);
  }

  upload(String fileName) {
    nome_imagem = fileName;
    http.post(uploadEndPoint, body: {
      "image": base64Image,
      "name": fileName,
    }).then((result) {
      setStatus(result.statusCode == 200 ? result.body : errMessage);
    }).catchError((error) {
      setStatus(error);
    });
  }

  Widget showImage() {
    return FutureBuilder<File>(
      future: file,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            null != snapshot.data) {
          tmpFile = snapshot.data;
          base64Image = base64Encode(snapshot.data.readAsBytesSync());
          return Container(
              width: 150.0,
              height: 150.0,
              decoration: new BoxDecoration(
                  shape: BoxShape.rectangle,
                  image: new DecorationImage(
                    fit: BoxFit.cover,
                    image: new FileImage(snapshot.data),
                  )));

          // return Flexible(
          //   child: Image.file(
          //     snapshot.data,
          //     fit: BoxFit.fill,
          //   ),
          // );
        } else if (null != snapshot.error) {
          return const Text(
            'Erro ao carregar image',
            textAlign: TextAlign.center,
          );
        } else {
          return const Text(
            'Não foi selecionada uma imagem',
            textAlign: TextAlign.center,
          );
        }
      },
    );
  }

  Future cadastrar() async {
    // Showing CircularProgressIndicator using State.
    setState(() {
      visible = true;
    });

    // Getting value from Controller
    String nome = nomeController.text;
    String login_usuario = loginUsuarioController.text;
    String email = emailController.text;
    String telefone = telefoneController.text;
    String cidade = cidadeController.text;
    String password = passwordController.text;

    // API URL
    var url = 'http://192.168.15.2/api/produto/create.php';

    // Store all data with Param Name.
    var data = {
      'nome_produto': nome,
      'imagem': nome_imagem

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
                  context, MaterialPageRoute(builder: (context) => Logar())),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: true,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Text('Cadastro de produtos'),
          centerTitle: true,
          backgroundColor: APP_BAR_COLOR,
        ),
        body: SingleChildScrollView(
            reverse: true,
            child: Center(
              child: Column(
                children: <Widget>[
                  Divider(
                    color: null,
                  ),
                  Container(
                      width: MediaQuery.of(context).size.width / 1.2,
                      padding: EdgeInsets.all(10.0),
                      child: TextField(
                        style: TextStyle(fontSize: 20, color: Colors.black),
                        controller: nomeController,
                        autocorrect: true,
                        decoration: InputDecoration(
                          hintText: 'Produto',
                          labelText: 'Nome do produto',
                          border: OutlineInputBorder(),
                        ),
                      )),
                  // Container(
                  //     width: MediaQuery.of(context).size.width / 1.2,
                  //     padding: EdgeInsets.all(10.0),
                  //     child: TextField(
                  //       style: TextStyle(fontSize: 20, color: Colors.black),
                  //       controller: loginUsuarioController,
                  //       autocorrect: true,
                  //       maxLines: null,
                  //       decoration: InputDecoration(
                  //         hintText: 'Descrição',
                  //         labelText: 'Detalhe seu produto',
                  //         border: OutlineInputBorder(),
                  //       ),
                  //     )),
                  // Container(
                  //     width: MediaQuery.of(context).size.width / 1.2,
                  //     padding: EdgeInsets.all(10.0),
                  //     child: TextField(
                  //       style: TextStyle(fontSize: 20, color: Colors.black),
                  //       controller: emailController,
                  //       autocorrect: true,
                  //       decoration: InputDecoration(
                  //         hintText: 'Doação ou troca',
                  //         labelText: 'será um campo combobox',
                  //         border: OutlineInputBorder(),
                  //       ),
                  //     )),
                  Padding(
                    padding: EdgeInsets.only(top: 50),
                  ),
                  OutlineButton(
                    onPressed: chooseImage,
                    child: Text('Selecionar imagem'),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  showImage(),
                  SizedBox(
                    height: 20.0,
                  ),
                  OutlineButton(
                    onPressed: startUpload,
                    child: Text('Enviar'),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    status,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.blue[900],
                      fontWeight: FontWeight.w500,
                      fontSize: 15.0,
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
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
                          "Cadastrar novo item",
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
                  Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom)),
                ],
              ),
            )));
  }
}
