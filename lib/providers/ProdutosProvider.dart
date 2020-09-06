import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProdutosProvider extends ChangeNotifier {
  ProdutosProvider();

  String _produtosUrl = "http://localhost:8080/produtos/";
  String _jsonResponse = "";
  bool _isFetching = false;

  bool get isFetching => _isFetching;

  Future<void> fetchProdutos() async {
    //_isFetching = true;
    var response = await http.Client().get(_produtosUrl);
    if (response.statusCode == 200) {
      _jsonResponse = response.body;
    }
    // _isFetching = false;
    notifyListeners();
  }

  String get getResponse => _jsonResponse;

  List<String> getRespondeJson() {
    if (_jsonResponse.isNotEmpty) {
      Map<String, dynamic> json = jsonDecode(_jsonResponse);
      print(json);
      return json[""];
    }
    return null;
  }
}
