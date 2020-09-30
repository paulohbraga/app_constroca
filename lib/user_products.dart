import 'package:app_constroca/providers/ProdutosProvider.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import 'constants.dart';

class MyProducts extends StatefulWidget {
  @override
  _MyProductsState createState() => _MyProductsState();
}

class _MyProductsState extends State<MyProducts> {
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<ProdutosProvider>(context);

    return Scaffold(
      appBar: AppBar(
          flexibleSpace: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft, end: Alignment.bottomRight, colors: APP_BAR_GRADIENT_COLOR))),
          leading: IconButton(
            icon: Icon(FeatherIcons.arrowLeftCircle, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          backgroundColor: APP_BAR_COLOR,
          centerTitle: true,
          title: Text('Meus produtos')),
      body: Container(
        padding: const EdgeInsets.all(5.0),
        child: appState.isFetchingMy
            ? Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Center(
                    child: SpinKitDualRing(
                  size: 40.0,
                  color: Colors.blue[200],
                )),
              )
            : appState.getResponseJsonMy() != null
                ? RefreshIndicator(
                    onRefresh: () => appState.fetchDataMy(),
                    child: ListView.builder(
                      primary: false,
                      shrinkWrap: true,
                      itemCount: appState.itemsMy.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage("http://www.someletras.com.br/paulo/" +
                                appState.getResponseJsonMy()[index].imagem +
                                ""),
                          ),
                          title: Text(
                            appState.getResponseJsonMy()[index].nomeProduto,
                          ),
                          trailing: Container(
                            margin: EdgeInsets.all(2),
                            width: 100,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                IconButton(
                                  onPressed: () => {},
                                  icon: Icon(Icons.edit),
                                ),
                                IconButton(
                                  onPressed: () => {
                                    _confirmDelete(appState.getResponseJsonMy()[index].id),
                                  },
                                  icon: Icon(Icons.delete),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  )
                : Text("Atualize a página recarregar"),
      ),
    );
  }

  void _confirmDelete(String id) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
            title: Text(
              "Confirma a exclusão do produto?",
              style: TextStyle(color: Colors.black, fontFamily: 'Raleway'),
              textAlign: TextAlign.center,
            ),
            actions: <Widget>[
              FlatButton(
                child: Text("Cancelar", style: TextStyle(color: Colors.red, fontFamily: 'Raleway')),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text(
                  "Deletar",
                  style: TextStyle(color: Colors.green[900], fontFamily: 'Raleway'),
                ),
                onPressed: () => {
                  Provider.of<ProdutosProvider>(context, listen: false).deleteUserProduct(id),
                  Navigator.pop(context)
                },
              )
            ],
          );
        });
  }
}
