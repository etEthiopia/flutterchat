import 'package:flutter/material.dart';
import 'package:chat_app/global.dart';
import 'package:chat_app/model/user.dart';
import 'package:chat_app/model/chat.dart';
import 'package:chat_app/components/chat_title.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController _usernameController = TextEditingController();
  List<Chat> _chatMessages;
  User _toChatUser;
  UserStatus _userStatus;

  @override
  void initState() {
    super.initState();
    _toChatUser = Global.toChatUser;
    _userStatus = UserStatus.connecting;
    _chatMessages = List();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: ChatTitle(
            toChatUser: _toChatUser,
            userStatus: _userStatus,
          ),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                  itemCount: _chatMessages.length,
                  itemBuilder: (context, index) {
                    Chat message = _chatMessages[index];
                    return Text(message.message);
                  }),
            ),
            _bottomChatArea()
          ],
        ));
  }

  void _ChatScreenBtnTap() {
    if (_usernameController.text.isEmpty) {
      return;
    }
    Global.initDummyUsers();
    User me = Global.dummyUsers[0];
    if (_usernameController.text != 'a') {
      me = Global.dummyUsers[1];
    }

    Global.loggedUser = me;
    _openChatUsersList(context);
  }

  _openChatUsersList(context) async {
    await Navigator.pushReplacementNamed(context, '/chat_users');
  }

  _bottomChatArea() {
    return Container(
      padding: EdgeInsets.all(20.0),
      child: Row(
        children: <Widget>[
          _chatTextArea(),
          IconButton(icon: Icon(Icons.send), onPressed: () {})
        ],
      ),
    );
  }

  _chatTextArea() {
    return Expanded(
      child: TextField(
        autocorrect: true,
        decoration: InputDecoration(
            enabledBorder:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.all(10.0),
            hintText: "Type your Message"),
      ),
    );
  }
}
