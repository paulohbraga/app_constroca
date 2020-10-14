import 'package:app_constroca/list_products.dart';
import 'package:app_constroca/appdata.dart';
import 'package:app_constroca/chat_placeholder.dart';
import 'package:app_constroca/constants.dart';
import 'package:app_constroca/login.dart';
import 'package:app_constroca/user_profile.dart';
import 'package:app_constroca/providers/ProdutosProvider.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';
import 'user_profile.dart';

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
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    final produtos = Provider.of<ProdutosProvider>(context);
    return new Scaffold(
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
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
          // new Offstage(
          //   offstage: index != 1,
          //   child: new TickerMode(
          //     enabled: index == 1,
          //     child: new MaterialApp(debugShowCheckedModeBanner: false, home: new MyApp2()),
          //   ),
          // ),
          new Offstage(
            offstage: index != 1,
            child: new TickerMode(
              enabled: index == 1,
              child: new MaterialApp(
                  debugShowCheckedModeBanner: false,
                  home: appData.id_usuario == null
                      //? Chat_Placeholder()
                      ? Chat_Placeholder()
                      : Chat_Placeholder()), // Agora deve ir para a pagina de perfil
            ),
          ),
          new Offstage(
            offstage: index != 2,
            child: new TickerMode(
              enabled: index == 2,
              child: new MaterialApp(
                  debugShowCheckedModeBanner: false,
                  home:
                      appData.id_usuario == null ? LoginUser() : PerfilUser()), // Agora deve ir para a pagina de perfil
            ),
          ),
        ],
      ),
      bottomNavigationBar: new BottomNavigationBar(
        backgroundColor: APP_BAR_COLOR,
        iconSize: 30,
        elevation: 100,
        unselectedItemColor: Colors.white,
        selectedItemColor: Colors.limeAccent,
        unselectedFontSize: 12,
        selectedFontSize: 12,
        type: BottomNavigationBarType.fixed,
        currentIndex: index,
        onTap: (int index) {
          if (index == 0) {
            produtos.fetchData();
          }
          if (index == 1) {
            produtos.fetchMyChat();
          }

          setState(() {
            this.index = index;
          });
        },
        items: <BottomNavigationBarItem>[
          new BottomNavigationBarItem(
            icon: new Icon(FeatherIcons.refreshCcw),
            title: new Text(
              "Trocas",
              style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Raleway'),
            ),
          ),
          // new BottomNavigationBarItem(
          //   icon: new Icon(Icons.vertical_align_top),
          //   title: new Text(
          //     "Doações",
          //     style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Raleway'),
          //   ),
          // ),
          new BottomNavigationBarItem(
            icon: new Icon(FeatherIcons.messageCircle),
            title: new Text(
              "Chat",
              style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Raleway'),
            ),
          ),
          new BottomNavigationBarItem(
            icon: new Icon(FeatherIcons.user),
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
