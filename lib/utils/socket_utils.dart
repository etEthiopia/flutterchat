import 'dart:io';
import 'package:chat_app/model/chat.dart';
import 'package:chat_app/model/user.dart';
import 'package:adhara_socket_io/adhara_socket_io.dart';

class SocketUtils {
  static String _serverIP = "http://192.168.1.3";
  static const int _port = 3000;

  static String _connectionURL = "$_serverIP:$_port";

  //Events
  static const String _ON_MESSAGE_RECEIVED = "receive_message";
  static const String _IS_USER_ONLINE_EVENT = "check_status";

  //Status
  static const int STATUS_MESSAGE_NOT_SENT = 10001;
  static const int STATUS_MESSAGE_SENT = 10002;

  //Type of chat
  static const String SINGLE_CHAT = 'single';

  User _fromUser;
  SocketIO _socket;
  SocketIOManager _iomanager;

  initSocket({User fromUser}) async {
    this._fromUser = fromUser;
    print("Connecting... ${fromUser.name}");
  }

  _init() async {
    _iomanager = SocketIOManager();
    _socket = await _iomanager.createInstance(_socketOptions());
  }

  _socketOptions() {
    final Map<String, String> userMap = {
      'from': _fromUser.id.toString(),
    };
    return SocketOptions(_connectionURL,
        enableLogging: true,
        transports: [Transports.WEB_SOCKET],
        query: userMap);
  }
}
