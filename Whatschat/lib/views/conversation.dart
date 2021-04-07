import 'package:chat_app/services/constants.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/widgets/widget.dart';
import 'package:flutter/cupertino.dart';
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
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    return snapshot.hasData
                        ? MessageTile(
                            snapshot.data.documents[index].data["message"],
                            snapshot.data.documents[index].data["sendBy"] ==
                                Constants.myname)
                        : Container();
                  })
              : Container();
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
      searchtext = null;
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
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
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

class MessageTile extends StatelessWidget {
  final String message;
  final bool isSendByMe;
  MessageTile(this.message, this.isSendByMe);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      width: MediaQuery.of(context).size.width,
      alignment: isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          color: isSendByMe ? Colors.blueAccent : Colors.black87,
          borderRadius: (isSendByMe
              ? BorderRadius.only(
                  topLeft: Radius.circular(23),
                  topRight: Radius.circular(23),
                  bottomLeft: Radius.circular(23))
              : BorderRadius.only(
                  topLeft: Radius.circular(23),
                  topRight: Radius.circular(23),
                  bottomRight: Radius.circular(23))),
        ),
        child: Text(message),
      ),
    );
  }
}
