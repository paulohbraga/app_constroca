import 'dart:io';
import 'package:app_constroca/appdata.dart';
import 'package:app_constroca/home_bar.dart';
import 'package:app_constroca/user_profile.dart';
import 'package:app_constroca/providers/ProdutosProvider.dart';
import 'package:dio/dio.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'constants.dart';

class Tipo {
  const Tipo(this.name, this.tipo);

  final String name;
  final String tipo;
}

class CadastroProduto extends StatelessWidget {
  final dynamic message = appData.message;

  CadastroProduto();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: TransfterData());
  }
}

class TransfterData extends StatefulWidget {
  TransfterDataWidget createState() => TransfterDataWidget();
  dynamic message;

  TransfterData({Key key, @required this.message}) : super(key: key);
}

class TransfterDataWidget extends State {
  dynamic message;

  TransfterDataWidget({Key key, @required this.message});

  Tipo selectedType;
  List<Tipo> users = <Tipo>[const Tipo('Troca', 'T'), const Tipo('Doação', 'D')];

  // Getting value from TextField widget.
  String tipoProduto = '';
  final nomeController = TextEditingController();
  final descricaoController = TextEditingController();
  final emailController = TextEditingController();
  final telefoneController = TextEditingController();
  final cidadeController = TextEditingController();
  final passwordController = TextEditingController();
  int contador;
  String nome_imagem = 'default.png';
  // Boolean variable for CircularProgressIndicator.
  bool visible = false;

  static final String uploadEndPoint = 'https://constroca-webservice-app.herokuapp.com/uploadftp';

  Future<File> file;
  String status = '';
  String base64Image;
  File tmpFile;

  Response res;
  String errMessage = 'Erro ao carregar imagem';

  Future<File> getImage() async {
    var file = await ImagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 50,
        maxHeight: 500, // <- reduce the image size
        maxWidth: 500);
    setState(() {
      status = file.path.split('/').last;
      tmpFile = file;
    });
    _upload(file);
  }

  Future<File> getImageGallery() async {
    var file = await ImagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 50,
        maxHeight: 500, // <- reduce the image size
        maxWidth: 500);
    setState(() {
      status = file.path.split('/').last;
      tmpFile = file;
    });
    _upload(file);
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
        .post("https://constroca-webservice-app.herokuapp.com/uploadftp", data: data)
        .then((response) => res = response)
        .catchError((error) => print(error));
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
    // Showing CircularProgressIndicator using State.
    setState(() {
      visible = true;
    });
    final appState = Provider.of<ProdutosProvider>(context, listen: false);
    final snackBar = SnackBar(
        content: Text('Produto cadastrado com sucesso!', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue[900]);
    WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var email_logado = prefs.getString('email');
    print(email_logado);
    //print(message['id']);

    // Getting value from Controller
    String nome = nomeController.text;
    String tipo = tipoProduto;
    String descricao = descricaoController.text;
    String telefone = telefoneController.text;
    String cidade = cidadeController.text;
    String password = passwordController.text;
    String id_user = appData.id_usuario;
    // API URL
    var url = 'https://constroca-webservice-app.herokuapp.com/usuarios/' + id_user + '/produtos';
    // Store all data with Param Name.
    var data = {
      'nome_produto': nome,
      'descricao_produto': descricao,
      'status': "A",
      'tipo': tipo,
      'imagem': nome_imagem,
    };

    // "nome_produto": "terra",
    //   "descricao_produto": "lalala",
    //   "status": "A",
    //   "tipo": "D",
    //   "imagem": "default.png",

    // Starting Web Call with data.
    var response = await http.post(url,
        body: json.encode(data), headers: {'Content-type': 'application/json', 'Accept': 'application/json'});

    // Getting Server response into variable.
    var message3 = jsonDecode(response.body);

    // If Web call Success than Hide the CircularProgressIndicator.
    if (response.statusCode == 200) {
      setState(() {
        visible = false;
      });
      Scaffold.of(context).showSnackBar(snackBar);
    }

    // Showing Alert Dialog with Response JSON.
    // showDialog(
    //   context: context,
    //   builder: (BuildContext context) {
    //     return AlertDialog(
    //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
    //       title: new Text(
    //         "Produto cadastrado com sucesso",
    //         textAlign: TextAlign.center,
    //       ),
    //       actions: <Widget>[
    //         FlatButton(
    //           child: new Text("OK"),
    //           onPressed: () =>
    //               {appState.fetchData(), Navigator.push(context, MaterialPageRoute(builder: (context) => Inicio()))},
    //         ),
    //       ],
    //     );
    //   },
    // );
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<ProdutosProvider>(context, listen: true);

    return Scaffold(
        resizeToAvoidBottomPadding: true,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          flexibleSpace: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft, end: Alignment.bottomRight, colors: APP_BAR_GRADIENT_COLOR))),
          leading: IconButton(
            icon: Icon(FeatherIcons.arrowLeftCircle, color: Colors.white),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PerfilUser())),
          ),
          title: Text('Cadastro de produtos'),
          centerTitle: true,
          backgroundColor: APP_BAR_COLOR,
        ),
        body: SingleChildScrollView(
            child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height + 200),
          child: Column(
            children: <Widget>[
              Divider(
                color: null,
              ),

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
                    color: Colors.blue[800],
                    onPressed: () => getImage(),
                    child: Icon(
                      FeatherIcons.camera,
                      color: Colors.white,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                  ),
                  RaisedButton(
                    color: Colors.blue[600],
                    onPressed: () => getImageGallery(),
                    child: Icon(
                      FeatherIcons.image,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20.0,
              ),
              // Text(
              //   status,
              //   textAlign: TextAlign.center,
              //   style: TextStyle(
              //     color: Colors.blue[900],
              //     fontWeight: FontWeight.w500,
              //     fontSize: 15.0,
              //   ),
              // ),

              Container(
                  width: MediaQuery.of(context).size.width / 1.2,
                  padding: EdgeInsets.all(10.0),
                  child: TextField(
                    //onSubmitted: startUpload(),
                    //onTap: startUpload(),
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
                  padding: EdgeInsets.all(10.0), //
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
              DropdownButton<Tipo>(
                  elevation: 10,
                  hint: new Text("                 Troca ou doação?                  "),
                  value: selectedType,
                  onChanged: (Tipo newValue) {
                    setState(() {
                      FocusScope.of(context).requestFocus(new FocusNode());
                      selectedType = newValue;
                      tipoProduto = selectedType.tipo;
                    });
                  },
                  items: users.map((Tipo user) {
                    return new DropdownMenuItem<Tipo>(
                      value: user,
                      child: new Text(
                        user.name,
                        style: new TextStyle(color: Colors.black, fontSize: 20),
                      ),
                    );
                  }).toList()),
              Padding(padding: EdgeInsets.only(bottom: 45, top: 20)),
              RaisedButton(
                onPressed: () => {
                  FocusScope.of(context).requestFocus(new FocusNode()),
                  cadastrar(),
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Perfil()))
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
                    constraints: BoxConstraints(maxWidth: 180.0, minHeight: 40.0),
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
                  child: Container(margin: EdgeInsets.only(bottom: 30, top: 10), child: CircularProgressIndicator())),
            ],
          ),
        )));
  }
}
