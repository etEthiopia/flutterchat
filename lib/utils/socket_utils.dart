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

  connectToSocket() {
    if (null == _socket) {
      print("Socket is null");
      return;
    }
    _socket.connect();
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

  SetOnConnectionListener(Function onConnect) {
    _socket.onConnect((data) {
      onConnect(data);
    });
  }

  SetOnConnectionErrorTimeOutListener(Function onConnectionTimeout) {
    _socket.onConnectTimeout((data) {
      onConnectionTimeout(data);
    });
  }

  SetOnConnectionErrorListener(Function onConnectionError) {
    _socket.onConnectError((data) {
      onConnectionError(data);
    });
  }

  SetOnErrorListener(Function onError) {
    _socket.onError((data) {
      onError(data);
    });
  }

  SetOnDisconnectListener(Function onDisconnect) {
    _socket.onDisconnect((data) {
      onDisconnect(data);
    });
  }

  closeConnection() {
    if (null != _socket) {
      print("Closing Connection");
      _iomanager.clearInstance(_socket);
    }
  }
}
