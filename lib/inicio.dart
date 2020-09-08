import 'package:app_constroca/ListProduct.dart';
import 'package:app_constroca/appdata.dart';
import 'package:app_constroca/chat.dart';
import 'package:app_constroca/chat_placeholder.dart';
import 'package:app_constroca/constants.dart';
import 'package:app_constroca/login.dart';
import 'package:app_constroca/perfil.dart';
import 'package:app_constroca/providers/ProdutosProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'doacao.dart';
import 'produtos.dart';
import 'login.dart';
import 'perfil.dart';

/// This Widget is the main application widget.
class Inicio extends StatelessWidget {
  static const String _title = '';

  final appData = AppData();

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
  @override
  void initState() {
    main().then((result) {
      setState(() {
        print(appData.id_usuario);
      });
    });
  }

  Future<void> main() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var email = prefs.getString('id');
    String result = (prefs.getString("id")) ?? "";
    email_logado = result;
    print(email_logado + "=================================");
  }

  int index = 0;
  var email_logado;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    final produtos = Provider.of<ProdutosProvider>(context);
    return new Scaffold(
      body: new Stack(
        children: <Widget>[
          new Offstage(
            offstage: index != 0,
            child: new TickerMode(
              enabled: index == 0,
              child: new MaterialApp(
                  debugShowCheckedModeBanner: false, home: new ListProduct()), // Ou Troca.() para voltar ao original
            ),
          ),
          new Offstage(
            offstage: index != 1,
            child: new TickerMode(
              enabled: index == 1,
              child: new MaterialApp(debugShowCheckedModeBanner: false, home: new MyApp2()),
            ),
          ),
          new Offstage(
            offstage: index != 2,
            child: new TickerMode(
              enabled: index == 2,
              child: new MaterialApp(
                  debugShowCheckedModeBanner: false,
                  home: appData.id_usuario == null
                      ? Chat_Placeholder()
                      : Chat()), // Agora deve ir para a pagina de perfil
            ),
          ),
          new Offstage(
            offstage: index != 3,
            child: new TickerMode(
              enabled: index == 3,
              child: new MaterialApp(
                  debugShowCheckedModeBanner: false,
                  home: appData.id_usuario == null ? Logar() : Perfil()), // Agora deve ir para a pagina de perfil
            ),
          ),
        ],
      ),
      bottomNavigationBar: new BottomNavigationBar(
        backgroundColor: APP_BAR_COLOR,
        iconSize: 40,
        elevation: 1,
        unselectedItemColor: Colors.white,
        selectedItemColor: Colors.yellow[700],
        unselectedFontSize: 12,
        selectedFontSize: 12,
        type: BottomNavigationBarType.fixed,
        currentIndex: index,
        onTap: (int index) {
          if (index == 0) {
            produtos.fetchData();
          }
          if (index == 1) {
            produtos.fetchData();
          }

          setState(() {
            this.index = index;
          });
        },
        items: <BottomNavigationBarItem>[
          new BottomNavigationBarItem(
            icon: new Icon(Icons.vertical_align_center),
            title: new Text(
              "Trocas",
              style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Raleway'),
            ),
          ),
          new BottomNavigationBarItem(
            icon: new Icon(Icons.vertical_align_top),
            title: new Text(
              "Doações",
              style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Raleway'),
            ),
          ),
          new BottomNavigationBarItem(
            icon: new Icon(Icons.chat_bubble_outline),
            title: new Text(
              "Chat",
              style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Raleway'),
            ),
          ),
          new BottomNavigationBarItem(
            icon: new Icon(Icons.person_outline),
            title: new Text(
              "Perfil",
              style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Raleway'),
            ),
          ),
        ],
      ),
    );
  }
}
