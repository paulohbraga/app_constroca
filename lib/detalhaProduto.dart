import 'package:app_constroca/produtos.dart';
import 'package:flutter/material.dart';

import 'appdata.dart';
import 'constants.dart';

class DetalhaProduto extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Product page',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Montserrat'),
      home: MyHomePage(title: 'Flutter Product page'),
    );
  }
}

class MyHomePageDetail extends StatefulWidget {
  MyHomePageDetail({Key key, this.title}) : super(key: key);
  final appData = AppData();

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePageDetail> {
  String selected = "blue";
  bool favourite = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: APP_BAR_COLOR,
        title: Text("Informações do produto"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => MyApp())),
        ),
      ),
      //The whole application area
      body: SafeArea(
        child: Column(
          children: <Widget>[
            hero(),
            spaceVertical(2),
            //Center Items
            Expanded(
              child: sections(),
            ),

            //Bottom Button
            purchase()
          ],
        ),
      ),
    );
  }

  ///************** Hero   ***************************************************/
  Widget hero() {
    return Container(
      child: Stack(
        children: <Widget>[
          Hero(
            tag: 1,
            child: Image.asset(
              "imgs/cano.png",
            ),
          ), //This
          // should be a paged
          // view.
          Positioned(
            child: appBar(),
            top: 0,
          ),
        ],
      ),
    );
  }

  Widget appBar() {
    return Container(
      padding: EdgeInsets.all(16),
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                Text(
                  "Troco canos",
                  style: TextStyle(
                    fontWeight: FontWeight.w100,
                    fontSize: 14,
                  ),
                ),
                Text(
                  "José",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2F2F3E)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /***** End */

  ///************ SECTIONS  *************************************************/
  Widget sections() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        children: <Widget>[
          description(),
          spaceVertical(50),
          property(),
        ],
      ),
    );
  }

  Widget description() {
    return Text(
      "Aqui vai a descriçao do item para troca ou doação ",
      textAlign: TextAlign.justify,
      style: TextStyle(height: 1.5, color: Color(0xFF6F8398)),
    );
  }

  Widget property() {
    return Container(
      padding: EdgeInsets.only(right: 20, left: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "texto aqui texto aqui",
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2F2F3E)),
              ),
              spaceVertical(10),
              //colorSelector(),
            ],
          ),
          size()
        ],
      ),
    );
  }

  Widget size() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Teste",
          textAlign: TextAlign.left,
          style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2F2F3E)),
        ),
        spaceVertical(10),
        Container(
          width: 70,
          padding: EdgeInsets.all(10),
          color: Color(0xFFF5F8FB),
          child: Text(
            "teste",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2F2F3E)),
          ),
        )
      ],
    );
  }

  /***** End */

  ///************** BOTTOM BUTTON ********************************************/
  Widget purchase() {
    return Container(
      padding: EdgeInsets.all(5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          FlatButton(
            child: Text(
              "Adicionar os favoritos +",
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2F2F3E)),
            ),
            color: Colors.transparent,
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  /***** End */

  ///************** UTILITY WIDGET ********************************************/
  Widget spaceVertical(double size) {
    return SizedBox(
      height: size,
    );
  }

  Widget spaceHorizontal(double size) {
    return SizedBox(
      width: size,
    );
  }
  /***** End */
}

class ColorTicker extends StatelessWidget {
  final Color color;
  final bool selected;
  final VoidCallback selectedCallback;
  ColorTicker({this.color, this.selected, this.selectedCallback});

  @override
  Widget build(BuildContext context) {
    print(selected);
    return GestureDetector(
        onTap: () {
          selectedCallback();
        },
        child: Container(
          padding: EdgeInsets.all(7),
          margin: EdgeInsets.all(5),
          width: 30,
          height: 30,
          decoration: BoxDecoration(
              shape: BoxShape.circle, color: color.withOpacity(0.7)),
          child: selected ? Image.asset("imgs/checker.png") : Container(),
        ));
  }
}
