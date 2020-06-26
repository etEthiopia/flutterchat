import 'package:flutter/material.dart';
import 'package:chat_app/model/user.dart';
import 'package:chat_app/global.dart';

class ChatUsers extends StatefulWidget {
  @override
  _ChatUsersState createState() => _ChatUsersState();
}

class _ChatUsersState extends State<ChatUsers> {
  List<User> _chatUsers;

  @override
  void initState() {
    super.initState();
    _chatUsers = Global.getUsersFor(Global.loggedUser);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Let's Chat"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              _openLoginScreen();
            },
          )
        ],
      ),
      body: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(30.0),
          child: Column(
            children: <Widget>[
              Expanded(
                child: ListView.builder(
                  itemCount: _chatUsers.length,
                  itemBuilder: (context, index) {
                    User user = _chatUsers[index];
                    return ListTile(
                        title: Text(user.name),
                        subtitle: Text("ID: ${user.id}, Email: ${user.email}"));
                  },
                ),
              )
              // Expanded(child: ListView.builder(itemCount: _chatUsers.length,
              // itemBuilder: (context, index),
              // ){
              //   User user = _chatUsers(index);
              // },)
            ],
          )),
    );
  }

  _openLoginScreen() async {
    await Navigator.pushReplacementNamed(context, '/login');
  }
}
