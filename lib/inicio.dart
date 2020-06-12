import 'package:app_constroca/constants.dart';
import 'package:app_constroca/login.dart';
import 'package:flutter/material.dart';
import 'doacao.dart';
import 'produtos.dart';
import 'login.dart';
import 'cadastroProduto.dart';

/// This Widget is the main application widget.
class Inicio extends StatelessWidget {
  static const String _title = '';
  

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: _title,
      home: MyStatefulWidget(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  MyStatefulWidget({Key key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {

  int index = 0;

@override
Widget build(BuildContext context) {
  return new Scaffold(
    
    body: new Stack(
      children: <Widget>[
        new Offstage(
          offstage: index != 0,
          child: new TickerMode(
            enabled: index == 0,
            child: new MaterialApp(debugShowCheckedModeBanner: false, home: new MyApp()), // Ou Troca.() para voltar ao original
          ),
        ),
        new Offstage(
          offstage: index != 1,
          child: new TickerMode(
            enabled: index == 1,
            child: new MaterialApp(debugShowCheckedModeBanner: false, home: new Doacao()),
          ),
        ),
        new Offstage(
          offstage: index != 2,
          child: new TickerMode(
            enabled: index == 2,
            child: new MaterialApp(debugShowCheckedModeBanner: false, home: new CadastroProduto()),
          ),
        ),
        new Offstage(
          offstage: index != 3,
          child: new TickerMode(
            enabled: index == 3,
            child: new MaterialApp(debugShowCheckedModeBanner: false, home: new Logar()),
          ),
        ),
      ],
    ),
    bottomNavigationBar: new BottomNavigationBar(
        backgroundColor: APP_BAR_COLOR,
        unselectedItemColor: Colors.white,
        selectedItemColor: Colors.lightBlueAccent,
        type: BottomNavigationBarType.fixed,
      currentIndex: index,
      onTap: (int index) { setState((){ this.index = index; }); },
      items: <BottomNavigationBarItem>[
        new BottomNavigationBarItem(
          icon: new Icon(Icons.vertical_align_center),
          title: new Text("Troca", style: TextStyle(fontWeight: FontWeight.bold),),
        ),
        new BottomNavigationBarItem(
          icon: new Icon(Icons.vertical_align_top),
          title: new Text("Doações", style: TextStyle(fontWeight: FontWeight.bold),),
        ),
        new BottomNavigationBarItem(
          icon: new Icon(Icons.add),
          title: new Text("Novo item", style: TextStyle(fontWeight: FontWeight.bold),),  
        ),
        new BottomNavigationBarItem(
          icon: new Icon(Icons.face),
          title: new Text("Seu perfil", style: TextStyle(fontWeight: FontWeight.bold),),
        ),
      ],
    ),
  );
}
}