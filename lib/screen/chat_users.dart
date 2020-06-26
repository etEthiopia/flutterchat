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
    Future.delayed(Duration(seconds: 2), () async {
      print("Connecting, Logged In User: ${Global.loggedUser.name}");
      Global.initSocket();
      Global.socketUtils.initSocket(fromUser: Global.loggedUser);
      Global.socketUtils.connectToSocket();
      Global.socketUtils.SetOnConnectionListener(onConnect);
      Global.socketUtils.SetOnDisconnectListener(onDisconnect);
      Global.socketUtils.SetOnErrorListener(onError);
      Global.socketUtils.SetOnConnectionErrorListener(onConnectError);
    });
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
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(_connectedToSocket ? 'Connected' : _errorConnectMessage),
              SizedBox(
                height: 20.0,
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: _chatUsers.length,
                    itemBuilder: (_, index) {
                      User user = _chatUsers[index];
                      return GestureDetector(
                        onTap: () {
                          Global.toChatUser = user;
                          _openChatScreen();
                        },
                        child: ListTile(
                          title: Text(user.name),
                          subtitle: Text('ID: ${user.id}, ${user.email}'),
                        ),
                      );
                    }),
              )
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

  onConnect(data) {
    print('Connected $data');
    setState(() {
      _connectedToSocket = true;
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

  _openChatScreen() async {
    await Navigator.pushNamed(context, '/chat');
  }
}
