import 'dart:async';

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
  ScrollController _chatListController;

  @override
  void initState() {
    super.initState();
    _toChatUser = Global.toChatUser;
    _userStatus = UserStatus.connecting;
    _chatMessages = List();
    _chatListController = ScrollController(initialScrollOffset: 0.0);
    _initSocketListeners();
    _checkOnline();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _removeListeners();
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
                  controller: _chatListController,
                  itemBuilder: (context, index) {
                    Chat message = _chatMessages[index];
                    bool fromMe = message.isFromMe;
                    return Container(
                        // decoration: BoxDecoration(boxShadow: [
                        //   BoxShadow(
                        //       color: fromMe ? Colors.green : Colors.grey[300],
                        //       spreadRadius: 3)
                        // ], borderRadius: BorderRadius.circular(15)),
                        // padding: EdgeInsets.all(20.0),
                        // margin: EdgeInsets.all(20.0),
                        alignment: fromMe
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Container(
                                decoration: BoxDecoration(boxShadow: [
                                  BoxShadow(
                                      color: fromMe
                                          ? Colors.green[400]
                                          : Colors.grey[300],
                                      spreadRadius: 3)
                                ], borderRadius: BorderRadius.circular(15)),
                                padding: EdgeInsets.all(15.0),
                                margin: EdgeInsets.all(20.0),
                                child: Text(
                                  message.message,
                                  style: TextStyle(
                                    color: fromMe ? Colors.white : Colors.black,
                                  ),
                                )),
                          ],
                        ));
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
        isFromMe: true,
        chatType: SocketUtils.SINGLE_CHAT);
    Global.socketUtils.sendSingleChatMessage(chat);

    print("Sending message to ${_toChatUser.name}, id: ${_toChatUser.id}");
    processMessage(chat);
    _chatListScrollBottom();
  }

  _initSocketListeners() async {
    Global.socketUtils.setOnChatMessageReceiveListener(onChatMessageReceived);
    Global.socketUtils.setOnlineUserStatusListener(onUserStatus);
  }

  _removeListeners() async {
    Global.socketUtils.setOnChatMessageReceiveListener(null);
    Global.socketUtils.setOnlineUserStatusListener(null);
  }

  onUserStatus(data) {
    print("onUserStatus $data");
    Chat chm = Chat.fromJson(data);
    setState(() {
      if (chm.toUserOnlineStatus) {
        _userStatus =
            chm.toUserOnlineStatus ? UserStatus.online : UserStatus.offline;
      }
    });
  }

  _checkOnline() {
    Chat chat = Chat(
        chatId: 0,
        to: _toChatUser.id,
        from: Global.loggedUser.id,
        toUserOnlineStatus: false,
        message: '',
        chatType: SocketUtils.SINGLE_CHAT);
    Global.socketUtils.checkOnline(chat);
    print("emitted");
  }

  onChatMessageReceived(data) {
    print("onChatMessageReceived $data");
    Chat chatRec = Chat.fromJson(data);
    chatRec.isFromMe = false;
    processMessage(chatRec);
    _chatListScrollBottom();
  }

  processMessage(Chat chatRec) {
    setState(() {
      _chatMessages.add(chatRec);
    });
  }

  _chatListScrollBottom() {
    Timer(Duration(milliseconds: 100), () {
      if (_chatListController.hasClients) {
        _chatListController.animateTo(
          _chatListController.position.maxScrollExtent,
          duration: Duration(milliseconds: 100),
          curve: Curves.decelerate,
        );
      }
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
