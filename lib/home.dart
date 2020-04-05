import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
          title: Text("Doações"),
          centerTitle: true,
          backgroundColor: Colors.teal[900],
        ),
        body: Container(
            padding: EdgeInsets.all(16.0),
            child: GridView.count(
              crossAxisCount: 3,
              crossAxisSpacing: 4.0,
              mainAxisSpacing: 8.0,
              children: <Widget>[
                Image.network("http://www.someletras.com.br/paulo/assets/cano.png",
  loadingBuilder:(BuildContext context, Widget child,ImageChunkEvent loadingProgress) {
  if (loadingProgress == null) return child;
    return Center(
      child: CircularProgressIndicator(
      value: loadingProgress.expectedTotalBytes != null ? 
             loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes
             : null,
      ),
    );
  },
),
                Image.network("http://www.someletras.com.br/paulo/assets/madeira.png",
  loadingBuilder:(BuildContext context, Widget child,ImageChunkEvent loadingProgress) {
  if (loadingProgress == null) return child;
    return Center(
      child: CircularProgressIndicator(
      value: loadingProgress.expectedTotalBytes != null ? 
             loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes
             : null,
      ),
    );
  },
),
                Image.network("http://www.someletras.com.br/paulo/assets/areia.jpg",
  loadingBuilder:(BuildContext context, Widget child,ImageChunkEvent loadingProgress) {
  if (loadingProgress == null) return child;
    return Center(
      child: CircularProgressIndicator(
      value: loadingProgress.expectedTotalBytes != null ? 
             loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes
             : null,
      ),
    );
  },
),
                Image.network("http://www.someletras.com.br/paulo/assets/telhas.png",
  loadingBuilder:(BuildContext context, Widget child,ImageChunkEvent loadingProgress) {
  if (loadingProgress == null) return child;
    return Center(
      child: CircularProgressIndicator(
      value: loadingProgress.expectedTotalBytes != null ? 
             loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes
             : null,
      ),
    );
  },
),
              ],
            )),
      ),
    );
  }
}
