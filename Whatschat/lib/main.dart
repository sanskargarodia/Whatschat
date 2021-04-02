import 'package:chat_app/services/auth.dart';
import 'package:chat_app/services/wrapper.dart';
import 'package:chat_app/user.dart';
import 'package:chat_app/views/chatroom.dart';
import 'package:chat_app/views/search.dart';
import 'package:chat_app/views/signin.dart';
import 'package:chat_app/views/signup.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
          child: MaterialApp(
        routes: {
          '/signin': (context) => SignIn(),
          '/signup': (context) => SignUp(),
          '/chatroom': (context) => ChatRoom(),'/search':(context)=>Search()
        },
        debugShowCheckedModeBanner: false,
        home:Wrapper(),
      ),
    );
  }
}
