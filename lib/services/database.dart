import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  uploadUserInfo(userMap) {
    Firestore.instance.collection("users").add(userMap);
  }

  getUserByUsername(String name) {
    return Firestore.instance
        .collection('users')
        .where("name", isEqualTo: name)
        .getDocuments();
  }
}
