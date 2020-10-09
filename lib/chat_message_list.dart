import 'dart:async';

import 'package:app_constroca/appdata.dart';
import 'package:app_constroca/providers/MessagesProvider.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'constants.dart';

class Messages extends StatefulWidget {
  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  static AudioCache player = new AudioCache();
  static const sentMessage = "pristine.mp3";
  final _controller = ScrollController();
  final messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Timer(
      Duration(milliseconds: 100),
      () => _controller.jumpTo(_controller.position.maxScrollExtent),
    );

    final messageState = Provider.of<MessageProvider>(context, listen: true);

    void send() {
      messageState.sendMessage(int.parse(appData.id_usuario), 1, messageController.text);
      setState(() => messageController.text = "");
    }

    return Scaffold(
      appBar: AppBar(
          backgroundColor: APP_BAR_COLOR,
          centerTitle: true,
          title: Text(
            "Conversa",
            style: TextStyle(fontFamily: 'Raleway'),
          ),
          flexibleSpace: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: <Color>[Colors.blue[800], Colors.blue])))),
      body: Padding(
        padding: const EdgeInsets.all(0),
        child: SingleChildScrollView(
            child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height - 200,
              child: ListView.builder(
                controller: _controller,
                shrinkWrap: true,
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
                                    Text(
                                      messageState.getResponseJson()[index].mensagem,
                                      style: TextStyle(fontSize: 18, fontFamily: 'Raleway', color: Colors.black87),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(15.0),
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
                                          borderRadius: BorderRadius.circular(30)),
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onSubmitted: (e) => send(),
                decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(30))),
                controller: messageController,
              ),
            ),
            Padding(padding: EdgeInsets.all(5)),
            RaisedButton(
              key: Key("botao"),
              onPressed: () => send(),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
              padding: EdgeInsets.all(0.0),
              child: Ink(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue[800], Colors.blue[800]],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(5.0)),
                child: Container(
                  constraints: BoxConstraints(maxWidth: 110.0, minHeight: 40.0),
                  alignment: Alignment.center,
                  child: Text(
                    "Enviar",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontFamily: 'Raleway'),
                  ),
                ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height - 400,
            )
          ],
        )),
      ),
    );
  }
}
