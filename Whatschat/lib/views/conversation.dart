import 'dart:io';

import 'package:chat_app/services/constants.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/widgets/widget.dart';
import 'package:flutter/material.dart';

class Conversation extends StatefulWidget {
  final String chatRoomId;
  Conversation(this.chatRoomId);
  @override
  _ConversationState createState() => _ConversationState();
}

String searchtext;

class _ConversationState extends State<Conversation> {
  DatabaseMethods databaseMethods = DatabaseMethods();
  Widget ChatMessageList() {
    return StreamBuilder(
        stream: chatMessageStream,
        builder: (context, snapshot) {
          return ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index) {
                return snapshot.hasData
                    ? snapshot.data.documents[index].data["sendBy"] ==
                            Constants.myname
                        ? Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 20),
                            margin: EdgeInsets.symmetric(vertical: 10),
                            alignment: Alignment.centerRight,
                            decoration: BoxDecoration(color: Colors.blue),
                            child: Text(
                              snapshot.data.documents[index].data["message"]
                                  .toString(),
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                        : Container(
                            child: Text(
                              snapshot.data.documents[index].data["message"]
                                  .toString(),
                              style: TextStyle(
                                color: Colors.blue,
                              ),
                            ),
                          )
                    : Container();
              });
        });
  }

  sendMessage() {
    if (searchtext != null) {
      Map<String, dynamic> messageMap = {
        "message": searchtext,
        "sendBy": Constants.myname,
        "time": DateTime.now().millisecondsSinceEpoch
      };
      databaseMethods.addConversation(widget.chatRoomId, messageMap);
    }
  }

  Stream chatMessageStream;
  @override
  void initState() {
    databaseMethods.getConversation(widget.chatRoomId).then((val) {
      chatMessageStream = val;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarMain(context),
        body: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Stack(children: [
              ChatMessageList(),
              Container(
                alignment: Alignment.bottomCenter,
                child: Container(
                  child: Row(
                    children: [
                      Expanded(
                          child: TextField(
                        onChanged: (val) {
                          setState(() {
                            searchtext = val;
                          });
                        },
                        decoration: InputDecoration(hintText: "Type a message"),
                      )),
                      FlatButton(
                        onPressed: () async {
                          sendMessage();
                        },
                        child: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                gradient: LinearGradient(
                                    colors: [Colors.blue, Colors.blueAccent])),
                            child: Icon(
                              Icons.search,
                              color: Colors.white,
                            )),
                      )
                    ],
                  ),
                ),
              ),
            ])));
  }
}
