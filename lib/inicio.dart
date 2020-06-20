import 'package:app_constroca/appdata.dart';
import 'package:app_constroca/constants.dart';
import 'package:app_constroca/login.dart';
import 'package:app_constroca/perfil.dart';
import 'package:flutter/material.dart';
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
        // This is the proper place to make the async calls
        // This way they only get called once

        // During development, if you change this code,
        // you will need to do a full restart instead of just a hot reload
        
        // You can't use async/await here,
        // We can't mark this method as async because of the @override
        main().then((result) {
            // If we need to rebuild the widget with the resulting data,
            // make sure to use `setState`
            setState(() {

              print(appData.id_usuario);
                
            });
            
        });
    }

    Future<void> main() async {
      WidgetsFlutterBinding.ensureInitialized();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var email = prefs.getString('id');
      String result = (prefs.getString("id")) ?? "";
      email_logado = result;
      print(email_logado + "=================================");
      //runApp(MaterialApp(home: email == null ? Login() : Home()));
    }
  int index = 0;
  var email_logado; 


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
            child: new MaterialApp(debugShowCheckedModeBanner: false, home:  new MyApp2()),
          ),
        ),
        
        new Offstage(
          offstage: index != 2,
          child: new TickerMode(
            enabled: index == 2,
            child: new MaterialApp(debugShowCheckedModeBanner: false, home: appData.id_usuario == null ? Logar() : Perfil() ), // Agora deve ir para a pagina de perfil
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
          icon: new Icon(Icons.face),
          title: new Text("Perfil", style: TextStyle(fontWeight: FontWeight.bold),),
        ),
        
      ],
    ),
  );
}
}