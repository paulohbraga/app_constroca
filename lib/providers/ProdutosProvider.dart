import 'dart:convert';

import 'package:app_constroca/models/Produto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProdutosProvider extends ChangeNotifier {
  ProdutosProvider() {
    fetchData();
  }

  String _dataUrl = "http://192.168.15.10:8080/produtos/";
  String _jsonResonse = "";
  bool _isFetching = false;
  List<Produto> items;

  bool get isFetching => _isFetching;

  dynamic get getItems => items;

  Future<void> fetchData() async {
    _isFetching = true;
    notifyListeners();

    var response = await http.get(_dataUrl);
    //HACK to convert special chars from response
    if (response.statusCode == 200) {
      String source = Utf8Decoder().convert(response.bodyBytes);

      _jsonResonse = source;
    }
    items = getResponseJson();
    _isFetching = false;

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

  Future<void> deleteProduct(String id) async {
    final response = await http.Client().delete('http://192.168.15.10:8080/produtos/' + id);
    fetchData();
    // Use the compute function to run parsePhotos in a separate isolate
    notifyListeners();
  }
}
