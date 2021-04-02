import 'package:chat_app/services/auth.dart';
import 'package:chat_app/services/constants.dart';
import 'package:chat_app/services/helperfunction.dart';
import 'package:flutter/material.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  getUserInfo() async {
    Constants.myname = await HelperFunction.getUserNameSharedPreference();
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/search');
        },
        child: Icon(Icons.search),
      ),
    );
  }
}
