import 'dart:async';

import 'package:app_constroca/appdata.dart';
import 'package:app_constroca/providers/MessagesProvider.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'constants.dart';

class Messages extends StatefulWidget {
  Messages();

  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  Timer timer;
  static AudioCache player = new AudioCache();
  static const sentMessage = "pristine.mp3";
  final _controller = ScrollController();
  final messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final messageState = Provider.of<MessageProvider>(context, listen: true); // change to false
    // Timer(
    //   Duration(seconds: 1),
    //   () => _controller.jumpTo(_controller.position.maxScrollExtent),
    // );
    Timer(
      Duration(seconds: 2),
      () => messageState.fetchMessages(appData.chat_id),
    );

    void _send() {
      var x = _controller.jumpTo(_controller.position.maxScrollExtent);
      setState(() => _controller.jumpTo(_controller.position.maxScrollExtent));

      messageState.sendMessage(int.parse(appData.id_usuario), 1, messageController.text);

      setState(() => messageController.text = "");
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
          backgroundColor: APP_BAR_COLOR,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(FeatherIcons.arrowLeftCircle, color: Colors.white),
            onPressed: () => {
              Navigator.of(context).pop(),
              appData.chat_id = null,
            },
          ),
          title: Text(
            "Conversas",
            style: TextStyle(fontFamily: 'Raleway'),
          ),
          flexibleSpace: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: <Color>[Colors.blue[800], Colors.blue])))),
      body: SingleChildScrollView(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height - 270,
            child: ListView.builder(
              controller: _controller,
              itemCount: messageState.items.length,
              itemBuilder: (context, index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    InkWell(
                        splashColor: Colors.amber,
                        //onTap: () => {print(appData.id_usuario)},
                        child: messageState.getResponseJson()[index].sender.toString() == appData.id_usuario
                            ? Row(
                                // Sender
                                children: <Widget>[
                                  Spacer(),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.rectangle,
                                        color: Colors.blue[100],
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(30),
                                            topRight: Radius.circular(30),
                                            bottomLeft: Radius.circular(30))),
                                    height: 40,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        messageState.getResponseJson()[index].mensagem,
                                        style: TextStyle(fontSize: 18, fontFamily: 'Raleway', color: Colors.black87),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: CircleAvatar(backgroundImage: AssetImage("assets/avatar.png")),
                                  ),
                                ],
                              )
                            //Receiver
                            : Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: CircleAvatar(backgroundImage: AssetImage("assets/girl-avatar.png")),
                                  ),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.rectangle,
                                        color: Colors.green[300],
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(30),
                                            topRight: Radius.circular(30),
                                            bottomRight: Radius.circular(30))),
                                    height: 40,
                                    width: MediaQuery.of(context).size.width - 100,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        messageState.getResponseJson()[index].mensagem,
                                        style: TextStyle(fontSize: 18, fontFamily: 'Raleway', color: Colors.black87),
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                  ],
                );
              },
            ),
          ),
          Padding(padding: EdgeInsets.all(5)),
          Container(
            margin: EdgeInsets.all(10.0),
            height: 61,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(35.0),
                      boxShadow: [BoxShadow(offset: Offset(0, 3), blurRadius: 5, color: Colors.grey)],
                    ),
                    child: Row(
                      children: [
                        IconButton(icon: Icon(Icons.face), onPressed: () {}),
                        Expanded(
                          child: TextField(
                            controller: messageController,
                            onTap: () => _controller.jumpTo(_controller.position.maxScrollExtent),
                            onSubmitted: (e) => _send(),
                            decoration: InputDecoration(hintText: "Digite a mensagem...", border: InputBorder.none),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 15),
                Container(
                  padding: const EdgeInsets.all(15.0),
                  decoration: BoxDecoration(color: Colors.green, shape: BoxShape.circle),
                  child: InkWell(
                    child: Icon(
                      Icons.send,
                      color: Colors.white,
                    ),
                    onTap: () => {_send(), () => _controller.jumpTo(_controller.position.maxScrollExtent)},
                  ),
                )
              ],
            ),
          ),
        ],
      )),
    );
  }

  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 2), (timer) {
      if (mounted) {
        timer.cancel();
      } else {
        _controller.jumpTo(_controller.position.maxScrollExtent);
      }
    });
  }

  @override
  void dispose() {
    timer.cancel();
  }
}
