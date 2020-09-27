import 'package:app_constroca/providers/ProdutosProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import 'constants.dart';

class MyProducts extends StatelessWidget {
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
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          backgroundColor: APP_BAR_COLOR,
          centerTitle: true,
          title: Text('Meus produtos')),
      body: Container(
        padding: const EdgeInsets.all(16.0),
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
                ? RefreshIndicator(
                    onRefresh: () => appState.fetchData(),
                    child: ListView.builder(
                      primary: false,
                      shrinkWrap: true,
                      itemCount: appState.items.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                                "http://www.someletras.com.br/paulo/" + appState.getResponseJson()[index].imagem + ""),
                          ),
                          title: Text(
                            appState.getResponseJson()[index].nomeProduto,
                          ),
                          trailing: Container(
                            width: 50,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                IconButton(
                                  onPressed: () => {
                                    Provider.of<ProdutosProvider>(context, listen: false)
                                        .deleteProduct(appState.getResponseJson()[index].id),
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
}
