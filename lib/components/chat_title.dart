import 'package:chat_app/model/user.dart';
import 'package:flutter/material.dart';

enum UserStatus { connecting, online, offline }

class ChatTitle extends StatelessWidget {
  const ChatTitle({Key key, this.toChatUser, this.userStatus});

  final User toChatUser;
  final UserStatus userStatus;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(toChatUser.name),
          Text(
            _getStatusText(),
            style: TextStyle(fontSize: 14.0, color: Colors.white70),
          )
        ],
      ),
    );
  }

  _getStatusText() {
    return userStatus.toString().split(".")[1];
  }
}
