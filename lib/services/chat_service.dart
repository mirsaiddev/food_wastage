import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_wastage/models/chat.dart';
import 'package:food_wastage/models/message.dart';
import 'package:food_wastage/services/auth_service.dart';
import 'package:food_wastage/services/firestore_service.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> isChatCreatedBefore(
      {required String foodRecipientUID, required String userUID}) async {
    QuerySnapshot _querySnapshot = await _firestore
        .collection('chats')
        .where('accounts', isEqualTo: {
      'foodRecipientUID': foodRecipientUID,
      'userUID': userUID
    }).get();
    return _querySnapshot.docs.length != 0;
  }

  Future<void> createChat(
      {required String foodRecipientUID,
      required String userUID,
      required String foodRecipientName,
      required String userName}) async {
    await _firestore.collection('chats').doc('$foodRecipientUID$userUID').set({
      'chatID': '$foodRecipientUID$userUID',
      'accounts': {
        'foodRecipientUID': foodRecipientUID,
        'userUID': userUID,
        'foodRecipientName': foodRecipientName,
        'userName': userName,
      },
      'UIDs': [foodRecipientUID, userUID]
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getMessages(String chatID) {
    return FirebaseFirestore.instance
        .collection('chats/$chatID/messages')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Future<void> sendMessage(Message message, String chatID) async {
    await FirebaseFirestore.instance.collection('chats/$chatID/messages').add({
      'accountUID': message.accountUID,
      'createdAt': message.createdAt,
      'message': message.message,
      'seenByOpponent': message.seenByOpponent,
      'username': message.username,
    });
  }

  Future saveMessageIsSeen(
      {required String chatID,
      required Message message,
      required String myUID}) async {
    late String id;
    await _firestore
        .collection('chats/$chatID/messages')
        .where('seenByOpponent', isEqualTo: false)
        .where('message', isEqualTo: message.message)
        .where('createdAt', isEqualTo: Timestamp.fromDate(message.createdAt))
        .where('accountUID', isNotEqualTo: myUID)
        .get()
        .then((value) => id = value.docs.first.id);
    await _firestore
        .collection('chats/$chatID/messages')
        .doc(id)
        .update({'seenByOpponent': true});
  }

  Future<List<Chat>> getMyChats() async {
    User? _user = AuthService().getCurrentUser();
    String uid = _user!.uid;
    List<String> _chatIDs = [];
    List<Chat> _chats = [];

    var _query = await _firestore
        .collection('chats')
        .where('UIDs', arrayContains: uid)
        .get();

    _query.docs.forEach((element) {
      _chatIDs.add(element.id);
    });

    for (var element in _chatIDs) {
      late Map<dynamic, dynamic> _accounts;
      late List<dynamic> _UIDs;
      late List<Message> _messages = [];

      await _firestore.collection('chats').doc(element).get().then((value) {
        _accounts = (value.data() as Map)['accounts'] as Map;
        _UIDs = (value.data() as Map)['UIDs'];
      });

      var _messagesList = await _firestore
          .collection('chats')
          .doc(element)
          .collection('messages')
          .get();

      _messagesList.docs.forEach((element) {
        _messages.add(Message.fromJson(element.data()));
      });

      _chats.add(Chat(
          chatID: element,
          accounts: _accounts,
          UIDs: _UIDs,
          messages: _messages));
    }
    _chats.sort(
      (a, b) => b.messages
          .map((e) => e.createdAt.microsecondsSinceEpoch)
          .reduce(max)
          .compareTo(
            a.messages
                .map((e) => e.createdAt.microsecondsSinceEpoch)
                .reduce(max),
          ),
    );
    return _chats;
  }

  Future<void> setMessageIsSeen({
    required String chatID,
    required String messageID,
  }) async {
    await _firestore
        .collection('chats/$chatID/messages')
        .doc(messageID)
        .update({'seenByOpponent': true});
  }

  Future<bool> isThereANewMessage() async {
    User? _user = AuthService().getCurrentUser();
    String uid = _user!.uid;
    List<String> _chatIDs = [];
    late List<Message> _messages = [];
    var _query = await _firestore
        .collection('chats')
        .where('UIDs', arrayContains: uid)
        .get();

    _query.docs.forEach((element) {
      _chatIDs.add(element.id);
    });

    for (var element in _chatIDs) {
      // ignore: unused_local_variable
      late Map<dynamic, dynamic> _accounts;
      // ignore: unused_local_variable
      late List<dynamic> _UIDs;

      await _firestore.collection('chats').doc(element).get().then((value) {
        _accounts = (value.data() as Map)['accounts'] as Map;
        _UIDs = (value.data() as Map)['UIDs'];
      });

      var _messagesList = await _firestore
          .collection('chats')
          .doc(element)
          .collection('messages')
          .get();

      _messagesList.docs.forEach((element) {
        _messages.add(Message.fromJson(element.data()));
      });
    }
    return _messages.any((element) =>
        element.accountUID != uid && element.seenByOpponent == false);
  }
}
