import 'package:chat_app/model/user.dart';
import 'utils/socket_utils.dart';

class Global {
  static List<User> dummyUsers;

  static User loggedUser;

  static User toChatUser;

  static SocketUtils socketUtils;

  static void initDummyUsers() {
    User userA = User(id: 1000, name: "David De Gea", email: "degea@gmail.com");
    User userB = User(
        id: 2000, name: "Aaron Wan-Bissaka", email: "wan-bissaka@gmail.com");

    dummyUsers = List();
    dummyUsers.add(userA);
    dummyUsers.add(userB);
  }

  static List<User> getUsersFor(User user) {
    List<User> filteredUsers =
        dummyUsers.where((u) => (u.id != user.id)).toList();
    return filteredUsers;
  }

  static initSocket() {
    if (socketUtils == null) {
      socketUtils = SocketUtils();
    }
  }
}
