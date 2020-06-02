import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'constants.dart';


Future<List<Photo>> fetchPhotos(http.Client client) async {
  final response =
      await client.get('http://192.168.15.8/api/produto/read.php');

  // Use the compute function to run parsePhotos in a separate isolate
  return compute(parsePhotos, response.body);
}

// A function that will convert a response body into a List<Photo>
List<Photo> parsePhotos(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Photo>((json) => Photo.fromJson(json)).toList();
}

class Photo {
  final String id_produto;
  final String fk_id_usuario;
  final String nome_produto;
  final String descricao_produto;
  final String imagem;

  Photo({this.id_produto, this.fk_id_usuario, this.nome_produto, this.descricao_produto, this.imagem});

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      id_produto: json['id_produto'] as String,
      fk_id_usuario: json['fk_id_usuario'] as String,
      nome_produto: json['nome_produto'] as String,
      descricao_produto: json['descricao_produto'] as String,
      imagem: json['imagem'] as String,
    );
  }
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'Troca';

    return MaterialApp(
      
      debugShowCheckedModeBanner: false,
      title: appTitle,
      home: MyHomePage(title: appTitle),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;

  MyHomePage({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: APP_BAR_COLOR,
        title: Text(title),
      ),
      body: Padding(
        child: FutureBuilder<List<Photo>>(
          future: fetchPhotos(http.Client()),
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);

            return snapshot.hasData
                ? PhotosList(photos: snapshot.data)
                : Center(child: CircularProgressIndicator());
          },
        ),
        padding: EdgeInsets.fromLTRB(1.0, 10.0, 1.0, 10.0),
      ),
    );
  }
}

class PhotosList extends StatelessWidget {
  final List<Photo> photos;

  PhotosList({Key key, this.photos}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: photos.length,
      itemBuilder: (context, index) {
        return Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("imgs/4.png"), fit: BoxFit.cover)),
                constraints: BoxConstraints.expand(
                  height: Theme.of(context).textTheme.display1.fontSize * 1.1 +
                      200.0,
                ),
                alignment: Alignment.center,
                child: Card(
                  color: Color.fromARGB(200, 255, 255, 255),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      ListTile(
                        leading: Image.network(
                          'https://amgestoroutput.s3.amazonaws.com/jcmateriais/img_produtos/1005-08391925.jpg',
                          fit: BoxFit.fitHeight,
                        ),
                        title: Text(photos[index].nome_produto),
                        subtitle: Text(photos[index].descricao_produto),
                      ),
                      ButtonTheme.bar(
                        // make buttons use the appropriate styles for cards
                        child: ButtonBar(
                          children: <Widget>[                         
                            FlatButton(
                              child: const Text('Abrir'),
                              onPressed: () {/* ... */},
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        );
      },
    );
  }
}