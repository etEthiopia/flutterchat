import 'dart:convert';

Chat chatFromJson(String str) => Chat.fromJson(json.decode(str));

String chatToJson(Chat data) => json.encode(data.toJson());

class Chat {
  Chat({
    this.chatId,
    this.to,
    this.from,
    this.message,
    this.chatType,
    this.toUserOnlineStatus,
  });

  int chatId;
  int to;
  int from;
  String message;
  String chatType;
  bool toUserOnlineStatus;

  factory Chat.fromJson(Map<String, dynamic> json) => Chat(
        chatId: json["chat_id"],
        to: json["to"],
        from: json["from"],
        message: json["message"],
        chatType: json["chat_type"],
        toUserOnlineStatus: json["to_user_online_status"],
      );

  Map<String, dynamic> toJson() => {
        "chat_id": chatId,
        "to": to,
        "from": from,
        "message": message,
        "chat_type": chatType,
        "to_user_online_status": toUserOnlineStatus,
      };
}
