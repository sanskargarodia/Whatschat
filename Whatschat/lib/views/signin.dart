import 'package:chat_app/services/auth.dart';
import 'package:chat_app/widgets/widget.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
  final Function toggleView;
  SignIn({this.toggleView});
}

class _SignInState extends State<SignIn> {
  final _formkey = GlobalKey<FormState>();
  bool isLoading = false;
  final AuthService _auth = AuthService();
  String error = '';

  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: appBarMain(context),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.height / 20),
                    child: Column(
                      children: [
                        SizedBox(
                          height: size.height / 4,
                        ),
                        Form(
                          key: _formkey,
                          child: Column(
                            children: [
                              TextFormField(
                                decoration: inputDecoration("Email"),
                                controller: emailTextEditingController,
                                validator: (val) {
                                  return val.isEmpty
                                      ? "Please enter Email"
                                      : null;
                                },
                              ),
                              TextFormField(
                                obscureText: true,
                                decoration: inputDecoration("Password"),
                                controller: passwordTextEditingController,
                                validator: (val) {
                                  return val.length < 6
                                      ? "Please enter 6+ Password"
                                      : null;
                                },
                              ),
                            ],
                          ),
                        ),
                        Container(
                            margin: EdgeInsets.symmetric(
                                vertical: size.height * 0.025),
                            alignment: Alignment.centerRight,
                            child: Text("Forgot Password?")),
                        GestureDetector(
                          onTap: () async {
                            if (_formkey.currentState.validate()) {
                              dynamic result =
                                  await _auth.signInWithEmailAndPassword(
                                      emailTextEditingController.text,
                                      passwordTextEditingController.text);
                              if (result == null) {
                                setState(() {
                                  error =
                                      "could not sign in with those credentials";
                                });
                              }
                            }
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: size.width,
                            height: size.height / 12,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                gradient: LinearGradient(
                                    colors: [Colors.blue, Colors.blueAccent])),
                            child: Text("Sign In",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20)),
                          ),
                        ),
                        Container(
                          child: Text(
                            error,
                          ),
                        ),
                        SizedBox(height: size.height / 18),
                        Container(
                          height: size.height / 12,
                          alignment: Alignment.center,
                          width: size.width,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Colors.black),
                          child: Text("Sign In with Google",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20)),
                        ),
                        Container(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Don't have an account?"),
                                Container(
                                    child: RawMaterialButton(
                                  onPressed: () {
                                    widget.toggleView();
                                  },
                                  child: Text(
                                    "Register Now",
                                    style: TextStyle(
                                        decoration: TextDecoration.underline),
                                  ),
                                ))
                              ],
                            ))
                      ],
                    )),
              ));
  }
}
