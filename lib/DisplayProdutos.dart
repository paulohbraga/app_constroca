import 'package:app_constroca/providers/ProdutosProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

import 'appdata.dart';
import 'detalhaProduto.dart';

class DisplayProdutos extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<ProdutosProvider>(context);

    return Container(
      padding: const EdgeInsets.all(0),
      child: appState.isFetching
          ? Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Center(
                  child: SpinKitDualRing(
                size: 100.0,
                color: Colors.blue[200],
              )),
            )
          : appState.getResponseJson() != null
              ? Container(
                  child: ListView.builder(
                    itemCount: appState.getResponseJson().length,
                    itemBuilder: (context, index) {
                      return Column(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              // image: DecorationImage(
                              //     image: AssetImage("imgs/5.jpg"), fit: BoxFit.cover)
                            ),
                            //constraints: BoxConstraints.expand(
                            //   height: MediaQuery.of(context).size.height - 120),
                            alignment: Alignment.center,
                            child: InkWell(
                              onTap: () => {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MyHomePageDetail(
                                            appState.getResponseJson()[index].descricaoProduto,
                                            appState.getResponseJson()[index].id,
                                            appState.getResponseJson()[index].nomeProduto,
                                            appState.getResponseJson()[index].imagem,
                                            appState.getResponseJson()[index].usuario.avatar))),
                                appData.id_produto = appState.getResponseJson()[index].id,
                                appData.name_produto = appState.getResponseJson()[index].nomeProduto,
                                appData.img_produto = appState.getResponseJson()[index].imagem,
                                appData.descricao_produto = appState.getResponseJson()[index].descricaoProduto,
                                appData.email_client = appState.getResponseJson()[index].usuario.email,
                                appData.avatar_client = appState.getResponseJson()[index].usuario.avatar,
                                appData.telefone_client = appState.getResponseJson()[index].usuario.telefone.toString()
                              },
                              child: Stack(
                                children: <Widget>[
                                  Card(
                                    semanticContainer: true,
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    child: Hero(
                                      tag: appState.getResponseJson()[index].id,
                                      child: FadeInImage.memoryNetwork(
                                        fadeInDuration: const Duration(milliseconds: 400),
                                        image: "http://192.168.15.10/api/produto/imagens/" +
                                            appState.getResponseJson()[index].imagem +
                                            "",
                                        fit: BoxFit.fill,
                                        placeholder: kTransparentImage,
                                        height: 280,
                                        width: MediaQuery.of(context).size.width,
                                      ),
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    elevation: 5,
                                    margin: EdgeInsets.all(10),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Center(
                                      child: Container(
                                        width: MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                              colors: <Color>[Color(0x499999), Colors.black87]),
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(10), topLeft: Radius.circular(10)),
                                        ),
                                        child: Row(
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.all(15),
                                              child: ButtonTheme(
                                                buttonColor: Colors.white,
                                                minWidth: 35,
                                                height: 45,
                                                child: RaisedButton(
                                                  onPressed: () => {
                                                    Provider.of<ProdutosProvider>(context, listen: false)
                                                        .deleteProduct(appState.getResponseJson()[index].id)
                                                  },
                                                  child: Icon(
                                                    Icons.delete,
                                                    size: 20,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(15),
                                              child: Text(appState.getResponseJson()[index].nomeProduto,
                                                  textAlign: TextAlign.end,
                                                  style: TextStyle(
                                                      fontFamily: 'Raleway',
                                                      fontSize: 15,
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.bold)),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                )
              : Text(""),
    );
  }
}