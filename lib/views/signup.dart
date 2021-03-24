import 'package:chat_app/services/auth.dart';
import 'package:chat_app/widgets/widget.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();

  final Function toggleView;
  SignUp({this.toggleView});
}

AuthService authmethods = AuthService();

class _SignUpState extends State<SignUp> {
  bool isLoading = false;
  final _formkey = GlobalKey<FormState>();

  TextEditingController usernameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  final AuthService _auth = AuthService();
  String error = '';

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
                            child: Column(children: [
                              TextFormField(
                                decoration: inputDecoration("Username"),
                                controller: usernameTextEditingController,
                                validator: (val) {
                                  return val.isEmpty
                                      ? "Please Enter Username"
                                      : null;
                                },
                              ),
                              TextFormField(
                                decoration: inputDecoration("Email"),
                                controller: emailTextEditingController,
                                validator: (val) {
                                  return RegExp(
                                              r"^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$")
                                          .hasMatch(val)
                                      ? null
                                      : "Please enter a valid Email";
                                },
                              ),
                              TextFormField(
                                obscureText: true,
                                controller: passwordTextEditingController,
                                decoration: inputDecoration("Password"),
                                validator: (val) {
                                  return val.length < 6
                                      ? "Please enter 6+ char Password"
                                      : null;
                                },
                              ),
                              GestureDetector(
                                onTap: () async {
                                  if (_formkey.currentState.validate()) {
                                    dynamic result =
                                        await _auth.signUpWithEmailAndPassword(
                                            usernameTextEditingController.text,
                                            emailTextEditingController.text,
                                            passwordTextEditingController.text);
                                    if (result == null) {
                                      setState(() {
                                        error =
                                            'This Email is already registered';
                                      });
                                    }
                                  }
                                },
                                child: Container(
                                  margin:
                                      EdgeInsets.only(top: size.height / 20),
                                  alignment: Alignment.center,
                                  width: size.width,
                                  height: size.height / 12,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      gradient: LinearGradient(colors: [
                                        Colors.blue,
                                        Colors.blueAccent
                                      ])),
                                  child: Text("Sign Up",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20)),
                                ),
                              ),
                              SizedBox(height: 10),
                              Container(
                                  color: Colors.blue,
                                  width: size.width,
                                  child: Text(error,
                                      style: TextStyle(color: Colors.red)))
                            ])),
                        SizedBox(height: size.height / 18),
                        Container(
                            height: size.height / 12,
                            alignment: Alignment.center,
                            width: size.width,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Colors.black),
                            child: RawMaterialButton(
                              constraints: BoxConstraints(
                                  minWidth: size.width, minHeight: size.height),
                              onPressed: () {},
                              child: Text("Sign Up with Google",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20)),
                            )),
                        Container(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Already have an account?"),
                                Container(
                                    child: RawMaterialButton(
                                  constraints: BoxConstraints(maxHeight: 20),
                                  onPressed: () {
                                    widget.toggleView();
                                  },
                                  child: Text(
                                    "SignIn Now",
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
