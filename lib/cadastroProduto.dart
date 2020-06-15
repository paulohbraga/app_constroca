import 'dart:io';

import 'package:app_constroca/inicio.dart';
import 'package:app_constroca/login.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'constants.dart';
import 'package:crypto/crypto.dart' as crypto;

class User {
  const User(this.name, this.tipo);

  final String name;
  final String tipo;
}

class CadastroProduto extends StatelessWidget {
    
    final String id;

    CadastroProduto({Key key, @required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false, home: TransfterData(id: id));
  }
}

class TransfterData extends StatefulWidget {

  TransfterDataWidget createState() => TransfterDataWidget(id: id);
  
  var id;

  TransfterData({Key key, @required this.id}) : super(key: key);
  
}

class TransfterDataWidget extends State {

  String id;

  TransfterDataWidget({Key key, @required this.id});

  User selectedUser;
  List<User> users = <User>[const User('Troca','T'), const User('Doação','D')];
  
  // Getting value from TextField widget.
  String tipoProduto = '';
  final nomeController = TextEditingController();
  final descricaoController = TextEditingController();
  final emailController = TextEditingController();
  final telefoneController = TextEditingController();
  final cidadeController = TextEditingController();
  final passwordController = TextEditingController();
  int contador;
  String nome_imagem;
  // Boolean variable for CircularProgressIndicator.
  bool visible = false;

  static final String uploadEndPoint =
      'http://192.168.15.4/api/produto/image_save.php';

  Future<File> file;
  String status = '';
  String base64Image;
  File tmpFile;
  String errMessage = 'Erro ao carregar imagem';

  chooseImage() {
    print(id);
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
    var md5 = crypto.md5;
    var digest = md5.convert(utf8.encode(fileName)).toString();

    upload(digest);
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

    WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var email_logado = prefs.getString('email');
    print(email_logado);

    // Getting value from Controller
    String nome = nomeController.text;
    String tipo = tipoProduto;
    String descricao = descricaoController.text;
    String telefone = telefoneController.text;
    String cidade = cidadeController.text;
    String password = passwordController.text;

    // API URL
    var url = 'http://192.168.15.4/api/produto/create.php';
    // Store all data with Param Name.
    var data = {
      'nome_produto': nome,
      'descricao_produto': descricao,
      'imagem': nome_imagem,
      'tipo': tipo,
      'fk_id_usuario': id

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
          context,
          MaterialPageRoute(
              builder: (context) =>
                  Inicio())),
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
            child: ConstrainedBox(
          constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height + 200),
              child: Column(
                children: <Widget>[
                  Divider(
                    color: null,
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
                  Container(
                      width: MediaQuery.of(context).size.width / 1.2,
                      padding: EdgeInsets.all(10.0),
                      child: TextField(
                        style: TextStyle(fontSize: 20, color: Colors.black),
                        controller: descricaoController,
                        autocorrect: true,
                        keyboardType: TextInputType.multiline,
                        maxLength: 200,
                        maxLines: null,
                        decoration: InputDecoration(  
                          labelText: 'Descrição do produto',
                          border: OutlineInputBorder(),
                        ),
                      )),
                      DropdownButton<User>(
                        
            hint: new Text("Troca ou doação?"),
            value: selectedUser,
            onChanged: (User newValue) {
              setState(() {
                
                selectedUser = newValue;
              tipoProduto = selectedUser.tipo;
              });
            },
            items: users.map((User user) {
              return new DropdownMenuItem<User>(
                value: user,
                child: new Text(
                  user.name,
                  style: new TextStyle(color: Colors.black),
                ),
              );
            }).toList()),
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
