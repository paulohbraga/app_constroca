import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'constants.dart';


class Troca extends StatefulWidget {
  @override
  _TrocaState createState() => _TrocaState();
}

class _TrocaState extends State<Troca> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text("Trocas"),
          centerTitle: true,
          backgroundColor: APP_BAR_COLOR,
        ),
        body: Container(
            padding: EdgeInsets.all(16.0),
            child: GridView.count( // Mudar para listview com constructor com base em itens da API.
              crossAxisCount: 3,
              crossAxisSpacing: 4.0,
              mainAxisSpacing: 8.0,
              children: <Widget>[

                Card(
          semanticContainer: true,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Image.network(
            'https://placeimg.com/640/480/any',
            fit: BoxFit.fill,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 5,
          margin: EdgeInsets.all(10),
        ),



           Card(
          semanticContainer: true,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Image.network(
            'https://placeimg.com/640/480/any',
            fit: BoxFit.fill,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 5,
          margin: EdgeInsets.all(10),
        ),     




          Card(
          semanticContainer: true,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Image.network(
            'http://186.224.101.193/paulo/assets/telhas.png',
            fit: BoxFit.fill,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 5,
          margin: EdgeInsets.all(10),
        ),     



      
              ],
            )),
      ),
    );
  }
}
