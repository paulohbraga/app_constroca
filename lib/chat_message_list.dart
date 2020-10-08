import 'package:app_constroca/appdata.dart';
import 'package:app_constroca/models/ChatMessageList.dart';
import 'package:app_constroca/providers/MessagesProvider.dart';
import 'package:app_constroca/providers/ProdutosProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'constants.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final messageState = Provider.of<MessageProvider>(context, listen: true);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: SingleChildScrollView(
          child: messageState.isFetchingMyChat
              ? RaisedButton(onPressed: () => messageState.fetchMessages())
              : messageState.getResponseJson() != null
                  ? Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height - 200,
                          child: ListView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.all(6.0),
                            itemCount: messageState.items.length,
                            itemBuilder: (context, index) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  InkWell(
                                      splashColor: Colors.amber,
                                      onTap: () => {print(appData.id_usuario)},
                                      child: messageState.getResponseJson()[index].sender.toString() ==
                                              appData.id_usuario
                                          ? Row(
                                              // Sender
                                              children: <Widget>[
                                                Spacer(),
                                                Text(
                                                  messageState.getResponseJson()[index].mensagem,
                                                  style: TextStyle(
                                                      fontSize: 15, fontFamily: 'Raleway', color: Colors.black87),
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
                                                  padding: const EdgeInsets.all(15.0),
                                                  child: CircleAvatar(
                                                      backgroundImage: AssetImage("assets/girl-avatar.png")),
                                                ),
                                                Text(
                                                  messageState.getResponseJson()[index].mensagem,
                                                  style: TextStyle(
                                                      fontSize: 15, fontFamily: 'Raleway', color: Colors.black87),
                                                ),
                                              ],
                                            )),
                                ],
                              );
                            },
                          ),
                        ),
                        TextField(),
                        Padding(padding: EdgeInsets.all(2)),
                        RaisedButton(
                          key: Key("botao"),
                          onPressed: () => {},
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
                    )
                  : RaisedButton(onPressed: () => messageState.fetchMessages()),
        ),
      ),
    );
  }
}
