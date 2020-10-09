import 'package:app_constroca/providers/ProdutosProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final chatState = Provider.of<ProdutosProvider>(context, listen: true);

    return RefreshIndicator(
      onRefresh: () => chatState.fetchMyChat(),
      child: chatState.isFetchingMyChat
          ? Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Center(
                child: RaisedButton(
                  child: Text("botao"),
                ),
              ),
            )
          : chatState.getResponseJsonMyChat() != null
              ? Center(
                  child: Container(
                    margin: EdgeInsets.all(15),
                    height: MediaQuery.of(context).size.height,
                    color: Colors.grey[300],
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: chatState.itemsMyChat.length,
                      itemBuilder: (context, index) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            // ignore: unrelated_type_equality_checks
                            chatState.getResponseJsonMyChat()[index].sender == 50
                                ? Row(
                                    children: <Widget>[
                                      Spacer(),
                                      Text(
                                        chatState.getResponseJsonMyChat()[index].sender.toString(),
                                        style: TextStyle(fontSize: 20, fontFamily: 'Raleway', color: Colors.black87),
                                      ),
                                      CircleAvatar(backgroundImage: AssetImage("assets/avatar.png")),
                                    ],
                                  )
                                : Row(
                                    children: <Widget>[
                                      CircleAvatar(backgroundImage: AssetImage("assets/avatar.png")),
                                      Text(
                                        chatState.getResponseJsonMyChat()[index].sender.toString(),
                                        style: TextStyle(fontSize: 20, fontFamily: 'Raleway', color: Colors.black87),
                                      ),
                                      Spacer(),
                                    ],
                                  )
                          ],
                        );
                      },
                    ),
                  ),
                )
              : Text("fffff"),
    );
  }
}
