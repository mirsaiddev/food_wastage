import 'package:food_wastage/models/message.dart';

class Chat {
  final String chatID;
  final Map<dynamic, dynamic> accounts;
  final List<dynamic> UIDs;
  final List<Message> messages;

  Chat(
      {required this.chatID,
      required this.accounts,
      required this.UIDs,
      required this.messages});
}
