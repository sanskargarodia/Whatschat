import 'package:chat_app/services/constants.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'conversation.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  DatabaseMethods databaseMethods = DatabaseMethods();
  QuerySnapshot searchsnapshot;

  initiateState() {
    databaseMethods.getUserByUsername(searchtext).then((val) {
      searchsnapshot = val;
    });
  }

  createChatRoomAndStartConversation({String userName}) {
    if (userName != Constants.myname) {
      String chatRoomId = getChatRoomId(userName, Constants.myname);
      List<String> users = [userName, Constants.myname];
      Map<String, dynamic> chatRoomMap = {
        "users": users,
        "chatRoomId": chatRoomId
      };

      DatabaseMethods().createChatRoom(chatRoomId, chatRoomMap);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Conversation(chatRoomId)));
    } else {
      print("You cannot chat with yourself");
    }
  }

  Widget SearchTile({String name, String email}) {
    return GestureDetector(
      onTap: () {
        createChatRoomAndStartConversation(userName: name);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        height: 50,
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name),
                Text(
                  email,
                  overflow: TextOverflow.ellipsis,
                )
              ],
            ),
            Spacer(),
            Container(
              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              width: 100,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue),
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.blue),
              child: Center(
                  child: Text(
                "Message",
                style: TextStyle(color: Colors.white),
              )),
            ),
          ],
        ),
      ),
    );
  }

  Widget searchlist() {
    return searchsnapshot != null
        ? ListView.builder(
            itemCount: searchsnapshot.documents.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return SearchTile(
                name: searchsnapshot.documents[index].data["name"],
                email: searchsnapshot.documents[index].data["email"],
              );
            })
        : Container();
  }

  String searchtext;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: Container(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                    onChanged: (val) {
                      setState(() {
                        searchtext = val;
                      });
                    },
                    decoration: InputDecoration(hintText: "Search Name"),
                  )),
                  FlatButton(
                    onPressed: () async {
                      databaseMethods.getUserByUsername(searchtext).then((val) {
                        searchsnapshot = val;
                      });
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
            searchlist()
          ],
        ),
      ),
    );
  }
}

getChatRoomId(String a, String b) {
  if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    return "$b\_$a";
  } else {
    return "$a\_$b";
  }
}
