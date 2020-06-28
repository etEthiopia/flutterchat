import 'package:chat_app/utils/socket_utils.dart';
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
  TextEditingController _textController = TextEditingController();
  List<Chat> _chatMessages;
  User _toChatUser;
  UserStatus _userStatus;

  @override
  void initState() {
    super.initState();
    _toChatUser = Global.toChatUser;
    _userStatus = UserStatus.connecting;
    _chatMessages = List();
    _initSocketListeners();
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

  sendMessageBtnTap() async {
    if (_textController.text.isEmpty) {
      return;
    }
    Chat chat = Chat(
        chatId: 0,
        to: _toChatUser.id,
        from: Global.loggedUser.id,
        toUserOnlineStatus: false,
        message: _textController.text,
        chatType: SocketUtils.SINGLE_CHAT);
    Global.socketUtils.sendSingleChatMessage(chat);

    print("Sending message to ${_toChatUser.name}, id: ${_toChatUser.id}");
    processMessage(chat);
  }

  _initSocketListeners() async {
    Global.socketUtils.setOnChatMessageReceiveListener(onChatMessageReceived);
  }

  onChatMessageReceived(data) {
    print("onChatMessageReceived $data");
    Chat chatRec = Chat.fromJson(data);
    processMessage(chatRec);
  }

  processMessage(Chat chatRec) {
    setState(() {
      _chatMessages.add(chatRec);
    });
  }

  void _ChatScreenBtnTap() {
    if (_textController.text.isEmpty) {
      return;
    }
    Global.initDummyUsers();
    User me = Global.dummyUsers[0];
    if (_textController.text != 'a') {
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
          IconButton(
              icon: Icon(Icons.send),
              onPressed: () async {
                await sendMessageBtnTap();
              })
        ],
      ),
    );
  }

  _chatTextArea() {
    return Expanded(
      child: TextField(
        controller: _textController,
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
