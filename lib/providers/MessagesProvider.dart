import 'dart:convert';

import 'package:app_constroca/appdata.dart';
import 'package:app_constroca/models/Chat.dart';
import 'package:app_constroca/models/ChatMessageList.dart';
import 'package:app_constroca/models/Produto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MessageProvider extends ChangeNotifier {
  MessageProvider() {
    fetchMessages();
  }

  String _jsonResonse = "";
  bool _isFetchingMyChat = false;
  List<ChatMessageList> items;

  bool get isFetchingMyChat => _isFetchingMyChat;

  dynamic get getItems => items;

  Future<void> fetchMessages() async {
    _isFetchingMyChat = true;
    print(appData.id_usuario);

    notifyListeners();

    var response = await http.get('https://constroca-webservice-app.herokuapp.com/mensagens/1');
    print(response.body);
    //HACK to convert special chars from response
    if (response.statusCode == 200) {
      String source = Utf8Decoder().convert(response.bodyBytes);

      _jsonResonse = source;
    }

    items = getResponseJson();

    _isFetchingMyChat = false;
    notifyListeners();
  }

  String get getResponseText => _jsonResonse;

  List<ChatMessageList> getResponseJson() {
    if (_jsonResonse.isNotEmpty) {
      List<ChatMessageList> parseProdutos =
          List<ChatMessageList>.from(json.decode(_jsonResonse).map((x) => ChatMessageList.fromJson(x)));
      items = parseProdutos;
      return parseProdutos;
    }
    return null;
  }

  Future<void> deleteProduct(String id) async {
    final response = await http.Client().delete('https://constroca-webservice-app.herokuapp.com/produtos/' + id);
    fetchMessages();
    // Use the compute function to run parsePhotos in a separate isolate
    notifyListeners();
  }

  Future<void> deleteUserProduct(String id) async {
    final response = await http.Client().delete('https://constroca-webservice-app.herokuapp.com/produtos/' + id);
    // Use the compute function to run parsePhotos in a separate isolate
    notifyListeners();
  }
}
