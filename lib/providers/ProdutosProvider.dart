import 'dart:convert';

import 'package:app_constroca/appdata.dart';
import 'package:app_constroca/models/Chat.dart';
import 'package:app_constroca/models/Produto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProdutosProvider extends ChangeNotifier {
  ProdutosProvider() {
    fetchData();
    fetchMyChat();
  }

  String _jsonResonse = "";
  bool _isFetching = false;
  bool _isFetchingMy = false;
  bool _isFetchingMyChat = false;
  List<Produto> items;
  String _jsonResonseMy = "";
  String _jsonResonseMyChat = "";
  List<Produto> itemsMy;
  List<Chat> itemsMyChat;

  bool get isFetching => _isFetching;
  bool get isFetchingMy => _isFetchingMy;
  bool get isFetchingMyChat => _isFetchingMyChat;

  dynamic get getItems => items;
  dynamic get getItemsMy => itemsMy;
  dynamic get getItemsMyChat => itemsMyChat;

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

  Future<void> fetchMyChat() async {
    _isFetchingMyChat = true;
    notifyListeners();

    var responseMy = await http.get("https://constroca-webservice-app.herokuapp.com/chat/");
    print(responseMy.body);
    //HACK to convert special chars from response
    if (responseMy.statusCode == 200) {
      String source2 = Utf8Decoder().convert(responseMy.bodyBytes);

      _jsonResonseMyChat = source2;
    }

    itemsMyChat = getResponseJsonMyChat();

    _isFetchingMyChat = false;

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

  String get getResponseTextMyChat => _jsonResonseMyChat;

  List<Chat> getResponseJsonMyChat() {
    if (_jsonResonseMyChat.isNotEmpty) {
      List<Chat> parseProdutosMyChat = List<Chat>.from(json.decode(_jsonResonseMyChat).map((x) => Chat.fromJson(x)));
      itemsMyChat = parseProdutosMyChat;
      //print(parseProdutosMyChat);
      return parseProdutosMyChat;
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
