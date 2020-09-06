import 'dart:convert';

import 'package:app_constroca/models/Produto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProdutosProvider extends ChangeNotifier {
  ProdutosProvider();

  String _dataUrl = "http://localhost:8080/produtos/";
  String _jsonResonse = "";
  bool _isFetching = false;

  bool get isFetching => _isFetching;

  Future<void> fetchData() async {
    _isFetching = true;
    notifyListeners();

    var response = await http.get(_dataUrl);
    if (response.statusCode == 200) {
      _jsonResonse = response.body;
    }

    _isFetching = false;
    notifyListeners();
  }

  String get getResponseText => _jsonResonse;

  List<Produto> getResponseJson() {
    if (_jsonResonse.isNotEmpty) {
      List<Produto> parseProdutos = List<Produto>.from(json.decode(_jsonResonse).map((x) => Produto.fromJson(x)));
      return parseProdutos;
    }
    return null;
  }

  Future<String> deleteProduct(String id) async {
    final response = await http.Client().delete('http://localhost:8080/produtos/' + id);
    fetchData();
    // Use the compute function to run parsePhotos in a separate isolate
    notifyListeners();
    return response.body;
  }
}
