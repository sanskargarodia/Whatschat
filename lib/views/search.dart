import 'package:chat_app/services/database.dart';
import 'package:chat_app/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

DatabaseMethods databaseMethods = DatabaseMethods();
QuerySnapshot searchsnapshot;

class _SearchState extends State<Search> {
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

class SearchTile extends StatelessWidget {
  final String name;
  final String email;
  SearchTile({this.name, this.email});

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}
