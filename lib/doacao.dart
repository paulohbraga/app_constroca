import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'detalhaProduto.dart';
import 'constants.dart';


class Doacao extends StatefulWidget {
  @override
  _DoacaoState createState() => _DoacaoState();
}

class _DoacaoState extends State<Doacao> {
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
          backgroundColor: APP_BAR_COLOR,
        ),
        body: Container(
            padding: EdgeInsets.all(16.0),
            child: GridView.count(
              crossAxisCount: 3,
              crossAxisSpacing: 4.0,
              mainAxisSpacing: 8.0,
              children: <Widget>[
                InkWell(
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) => DetalhaProduto())),
                  child: Image.network(
                    "http://186.224.101.193/paulo/assets/cano.png",
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes
                              : null,
                        ),
                      );
                    },
                  ),
                ),
                InkWell(
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) => DetalhaProduto())),
                  child: Image.network(
                    "http://186.224.101.193/paulo/assets/madeira.png",
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes
                              : null,
                        ),
                      );
                    },
                  ),
                ),
                Image.network(
                  "http://186.224.101.193/paulo/assets/areia.jpg",
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes
                            : null,
                      ),
                    );
                  },
                ),
                Image.network(
                  "http://186.224.101.193/paulo/assets/telhas.png",
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes
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
