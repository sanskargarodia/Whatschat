import 'package:chat_app/services/auth.dart';
import 'package:chat_app/services/constants.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/services/helperfunction.dart';
import 'package:chat_app/user.dart';
import 'package:chat_app/views/conversation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  Stream stream;
  DatabaseMethods databaseMethods = DatabaseMethods();
  SharedPreferences sharedPreferences;
  @override
  void initState() {
    getUserInfo();

    super.initState();
  }

  getUserInfo() async {
    Constants.myname = await HelperFunction.getUserNameSharedPreference();
    databaseMethods.getChatRoom(Constants.myname).then((val) {
      setState(() {
        stream = val;
      });
    });
  }

  Widget chatRoomList() {
    return StreamBuilder(
        stream: stream,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemBuilder: (context, index) {
                    return ChatRoomTiles(
                        snapshot.data.documents[index].data["chatRoomId"]
                            .toString()
                            .replaceAll("_", "")
                            .replaceAll(Constants.myname, ""),
                        snapshot.data.documents[index].data["chatRoomId"]);
                  },
                  itemCount: snapshot.data.documents.length,
                )
              : Container();
        });
  }

  AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          RaisedButton(
              color: Colors.blue,
              onPressed: () async {
                _auth.signOut();
              },
              child: Icon(Icons.exit_to_app))
        ],
      ),
      body: chatRoomList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/search');
        },
        child: Icon(Icons.search),
      ),
    );
  }
}

class ChatRoomTiles extends StatelessWidget {
  final String userName;
  final String chatRoomId;
  ChatRoomTiles(this.userName, this.chatRoomId);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => Conversation(chatRoomId)));
      },
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: Colors.blue),
              child: Text(
                "${userName.substring(0, 1).toUpperCase()}",
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                userName,
                style: TextStyle(color: Colors.black, fontSize: 20),
              ),
            )
          ],
        ),
      ),
    );
  }
}
