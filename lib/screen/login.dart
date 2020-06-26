import 'package:flutter/material.dart';
import 'package:chat_app/global.dart';
import 'package:chat_app/model/user.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Let's Chat"),
      ),
      body: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(30.0),
          child: Center(
            child: Column(
              children: <Widget>[
                TextField(
                  controller: _usernameController,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.all(20.0),
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(20.0)))),
                ),
                SizedBox(
                  height: 20.0,
                ),
                OutlineButton(
                    child: Text("Login"),
                    onPressed: () {
                      _loginBtnTap();
                    })
              ],
            ),
          )),
    );
  }

  void _loginBtnTap() {
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
}
