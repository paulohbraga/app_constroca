import 'dart:convert';

import 'package:app_constroca/appdata.dart';
import 'package:app_constroca/models/Produto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProdutosProvider extends ChangeNotifier {
  ProdutosProvider() {
    fetchData();
  }

  String _jsonResonse = "";
  bool _isFetching = false;
  bool _isFetchingMy = false;
  List<Produto> items;
  String _jsonResonseMy = "";
  List<Produto> itemsMy;

  bool get isFetching => _isFetching;
  bool get isFetchingMy => _isFetchingMy;

  dynamic get getItems => items;
  dynamic get getItemsMy => itemsMy;

  Future<void> fetchData() async {
    _isFetching = true;
    print(appData.id_usuario);

    notifyListeners();

    var response = await http.get('https://constroca-webservice-app.herokuapp.com/produtos/');
    //HACK to convert special chars from response
    if (response.statusCode == 200) {
      String source = Utf8Decoder().convert(response.bodyBytes);

      _jsonResonse = source;
    }

    items = getResponseJson();

    _isFetching = false;
    notifyListeners();
  }

  Future<void> fetchDataMy() async {
    _isFetchingMy = true;
    notifyListeners();

    var responseMy =
        await http.get("https://constroca-webservice-app.herokuapp.com/usuarios/" + appData.id_usuario + "/produtos");

    //HACK to convert special chars from response
    if (responseMy.statusCode == 200) {
      String source2 = Utf8Decoder().convert(responseMy.bodyBytes);

      _jsonResonseMy = source2;
    }

    itemsMy = getResponseJsonMy();

    _isFetchingMy = false;

    notifyListeners();
  }

  String get getResponseText => _jsonResonse;

  List<Produto> getResponseJson() {
    if (_jsonResonse.isNotEmpty) {
      List<Produto> parseProdutos = List<Produto>.from(json.decode(_jsonResonse).map((x) => Produto.fromJson(x)));
      items = parseProdutos;
      return parseProdutos;
    }
    return null;
  }

  String get getResponseTextMy => _jsonResonseMy;

  List<Produto> getResponseJsonMy() {
    if (_jsonResonseMy.isNotEmpty) {
      List<Produto> parseProdutosMy = List<Produto>.from(json.decode(_jsonResonseMy).map((x) => Produto.fromJson(x)));
      itemsMy = parseProdutosMy;
      return parseProdutosMy;
    }
    return null;
  }

  Future<void> deleteProduct(String id) async {
    final response = await http.Client().delete('https://constroca-webservice-app.herokuapp.com/produtos/' + id);
    fetchData();
    // Use the compute function to run parsePhotos in a separate isolate
    notifyListeners();
  }

  Future<void> deleteUserProduct(String id) async {
    final response = await http.Client().delete('https://constroca-webservice-app.herokuapp.com/produtos/' + id);
    fetchDataMy();
    // Use the compute function to run parsePhotos in a separate isolate
    notifyListeners();
  }
}
