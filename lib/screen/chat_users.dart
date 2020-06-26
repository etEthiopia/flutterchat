import 'package:flutter/material.dart';
import 'package:chat_app/model/user.dart';
import 'package:chat_app/global.dart';

class ChatUsers extends StatefulWidget {
  @override
  _ChatUsersState createState() => _ChatUsersState();
}

class _ChatUsersState extends State<ChatUsers> {
  List<User> _chatUsers;
  bool _connectedToSocket;
  String _errorConnectMessage;

  @override
  void initState() {
    super.initState();
    _chatUsers = Global.getUsersFor(Global.loggedUser);
    _errorConnectMessage = 'Connecting...';
    _connectedToSocket = false;
    _connectToSocket();
  }

  _connectToSocket() {
    print("Connecting, Logged In User: ${Global.loggedUser.name}");
    Global.initSocket();
    Global.socketUtils.initSocket(fromUser: Global.loggedUser);
    Global.socketUtils.connectToSocket();
    Global.socketUtils.SetOnConnectionListener(onConnect);
    Global.socketUtils.SetOnDisconnectListener(onDisconnect);
    Global.socketUtils.SetOnErrorListener(onError);
    Global.socketUtils.SetOnConnectionErrorListener(onConnectError);
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
                        onTap: () {
                          _openChatScreen(user);
                        },
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

  onConnectError(data) {
    print('onConnectError $data');
    setState(() {
      _connectedToSocket = false;
      _errorConnectMessage = 'Failed to Connect';
    });
  }

  onConnectTimeout(data) {
    print('onConnectTimeout $data');
    setState(() {
      _connectedToSocket = false;
      _errorConnectMessage = 'Connection timedout';
    });
  }

  onError(data) {
    print('onError $data');
    setState(() {
      _connectedToSocket = false;
      _errorConnectMessage = 'Connection Failed';
    });
  }

  onDisconnect(data) {
    print('onDisconnect $data');
    setState(() {
      _connectedToSocket = false;
      _errorConnectMessage = 'Disconnected';
    });
  }

  _openLoginScreen() async {
    await Navigator.pushReplacementNamed(context, '/login');
  }

  _openChatScreen(User user) async {
    Global.toChatUser = user;
    await Navigator.pushNamed(context, '/chat');
  }
}
