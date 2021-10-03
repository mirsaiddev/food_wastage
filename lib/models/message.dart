import 'dart:convert';

import '../utils.dart';

class Message {
  final String accountUID;
  final String username;
  final String message;
  final DateTime createdAt;
  final bool seenByOpponent;

  const Message({
    required this.accountUID,
    required this.username,
    required this.message,
    required this.createdAt,
    required this.seenByOpponent,
  });

  static Message fromJson(Map<String, dynamic> json) => Message(
        accountUID: json['accountUID'],
        username: json['username'],
        message: json['message'],
        createdAt: Utils.toDateTime(json['createdAt']),
        seenByOpponent: json['seenByOpponent'],
      );

  static List<Message> messagesFromJson(String str) => List<Message>.from(json.decode(str).map((x) => Message.fromJson(x)));

  Map<String, dynamic> toJson() => {
        'accountUID': accountUID,
        'username': username,
        'message': message,
        'createdAt': Utils.fromDateTimeToJson(createdAt),
        'seenByOpponent': seenByOpponent,
      };
}
