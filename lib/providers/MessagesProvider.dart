import 'dart:convert';
import 'package:app_constroca/appdata.dart';
import 'package:app_constroca/models/ChatMessageList.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MessageProvider extends ChangeNotifier {
  MessageProvider() {
    fetchMessages();
  }

  static AudioCache player = new AudioCache();

  String _jsonResonse = "";
  bool _isFetchingMyChat = false;
  List<ChatMessageList> items;
  bool get isFetchingMyChat => _isFetchingMyChat;

  dynamic get getItems => items;

  Future<void> fetchMessages([int id]) async {
    _isFetchingMyChat = true;
    //print(appData.id_usuario);

    var response = await http.get('https://constroca-webservice-app.herokuapp.com/mensagens/' + id.toString());
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
      // if (_jsonResonse.isNotEmpty) {
      //   if (items.length < parseProdutos.length) {
      //     const sentMessage = "pristine.mp3";
      //     player.play(sentMessage);
      //     print("novas");
      //   }
      // }
      //print(_jsonResonse);
      items = parseProdutos;
      return parseProdutos;
    }
    return null;
  }

  Future<void> sendMessage(int id_sender, int id_receiver, String message) async {
    var data = {'mensagem': message, 'sender': id_sender, 'receiver': id_receiver};
    //print(id_receiver);
    if (message.isEmpty) {
      return;
    } else {
      // print(appData.chat_id);
      final response = await http.Client().post(
          'https://constroca-webservice-app.herokuapp.com/chat/' + appData.chat_id.toString() + '/mensagens/',
          body: json.encode(data),
          headers: {'Content-type': 'application/json', 'Accept': 'application/json'});

      // const sentMessage = "pristine.mp3";
      // player.play(sentMessage);

      fetchMessages();
      getResponseJson();

      // Change ui listeners
      notifyListeners();
    }
  }

  Future<void> createRoom(int id_sender, int id_receiver) async {
    var data = {'sender': id_sender, 'receiver': id_receiver};

    final response = await http.Client().post('https://constroca-webservice-app.herokuapp.com/chat',
        body: json.encode(data), headers: {'Content-type': 'application/json', 'Accept': 'application/json'});

    print(json.decode(response.body)['id'].toString() + " json id room");
    const sentMessage = "pristine.mp3";
    appData.chat_id = json.decode(response.body)['id'];
    //player.play(sentMessage);
    fetchMessages();
    getResponseJson();

    // Change ui listeners
    notifyListeners();
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
