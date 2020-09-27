import 'package:app_constroca/display_products.dart';
import 'package:app_constroca/providers/ProdutosProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'constants.dart';

class ListProduct extends StatefulWidget {
  @override
  _ListProductState createState() => _ListProductState();
}

class _ListProductState extends State<ListProduct> {
  @override
  Widget build(BuildContext context) {
    //final produtos = Provider.of<ProdutosProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Produtos',
      home: Scaffold(
        appBar: AppBar(
          elevation: 5,
          automaticallyImplyLeading: false,
          centerTitle: true,
          backgroundColor: APP_BAR_COLOR,
          title: Text(
            "Produtos",
            style: TextStyle(fontFamily: 'Raleway', fontWeight: FontWeight.bold),
          ),
          flexibleSpace: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft, end: Alignment.bottomRight, colors: APP_BAR_GRADIENT_COLOR))),
        ),
        body: DisplayProdutos(),
      ),
    );
  }
}
