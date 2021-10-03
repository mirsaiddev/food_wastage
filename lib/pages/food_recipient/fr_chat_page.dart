import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_wastage/models/message.dart';
import 'package:food_wastage/services/auth_service.dart';
import 'package:food_wastage/services/chat_service.dart';
import 'package:food_wastage/services/firestore_service.dart';
import 'package:food_wastage/widgets/message_widget.dart';

class FrChatPage extends StatefulWidget {
  const FrChatPage({Key? key, required this.userUID, required this.username})
      : super(key: key);
  final String userUID, username;

  @override
  _FrChatPageState createState() => _FrChatPageState(userUID, username);
}

class _FrChatPageState extends State<FrChatPage> {
  final String _userUsername, userUID;

  _FrChatPageState(this.userUID, this._userUsername);

  late String _foodRecipientUsername, foodRecipientUID;

  bool _namesLoaded = false;
  bool _chatIsCreatedBefore = false;

  TextEditingController _controller = TextEditingController();
  ScrollController _scrollController = ScrollController();

  Future<void> _getUsernames() async {
    foodRecipientUID = await AuthService().getCurrentUser()!.uid;
    _foodRecipientUsername =
        await FirestoreService().getUsernameByUID(foodRecipientUID);
    _namesLoaded = true;
    setState(() {});
  }

  Future<void> checkIsChatCreated() async {
    _chatIsCreatedBefore = await ChatService().isChatCreatedBefore(
        foodRecipientUID: foodRecipientUID, userUID: userUID);
    if (!_chatIsCreatedBefore) {
      await ChatService().createChat(
          foodRecipientUID: foodRecipientUID,
          userUID: userUID,
          foodRecipientName: _foodRecipientUsername,
          userName: _userUsername);
    }
  }

  Future<void> _sendMessage(String message) async {
    _controller.clear();
    FocusScope.of(context).unfocus();
    Message _message = Message(
        accountUID: foodRecipientUID,
        username: _foodRecipientUsername,
        message: message,
        createdAt: DateTime.now(),
        seenByOpponent: false);
    await ChatService().sendMessage(_message, '$foodRecipientUID$userUID');
  }

  @override
  void initState() {
    super.initState();
    _getUsernames().then((value) {
      if (_namesLoaded) {
        checkIsChatCreated();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(_userUsername),
        ),
        body: _namesLoaded
            ? Column(
                children: [
                  Expanded(
                    child: Container(
                      child: StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection(
                                  'chats/$foodRecipientUID$userUID/messages')
                              .orderBy('createdAt', descending: true)
                              .snapshots(),
                          builder: (context, snapshot) {
                            switch (snapshot.connectionState) {
                              case ConnectionState.waiting:
                                return Center(
                                    child: CircularProgressIndicator());
                              default:
                                if (snapshot.hasError) {
                                  return buildText(
                                      'Something Went Wrong Try later');
                                } else {
                                  QuerySnapshot<Map<String, dynamic>> data =
                                      snapshot.data as QuerySnapshot<
                                          Map<String, dynamic>>;

                                  final List messages = [];
                                  data.docs.forEach((element) {
                                    messages
                                        .add(Message.fromJson(element.data()));

                                    if (Message.fromJson(element.data())
                                            .accountUID ==
                                        userUID) {
                                      ChatService().setMessageIsSeen(
                                        chatID: '$foodRecipientUID$userUID',
                                        messageID: element.id,
                                      );
                                    }
                                  });
                                  return messages.isEmpty
                                      ? buildText('Say Hi..')
                                      : ListView.builder(
                                          reverse: true,
                                          controller: _scrollController,
                                          physics: BouncingScrollPhysics(),
                                          itemCount: messages.length,
                                          itemBuilder: (context, index) {
                                            final message = messages[index];
                                            ChatService().saveMessageIsSeen(
                                                chatID:
                                                    '$foodRecipientUID$userUID',
                                                message: message,
                                                myUID: foodRecipientUID);
                                            return MessageWidget(
                                              message: message,
                                              isMe: message.accountUID ==
                                                  foodRecipientUID,
                                            );
                                          },
                                        );
                                }
                            }
                          }),
                    ),
                  ),
                  Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _controller,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16))),
                            ),
                          ),
                          IconButton(
                              onPressed: () async {
                                await _sendMessage(_controller.text);
                              },
                              icon: Icon(Icons.send))
                        ],
                      )),
                ],
              )
            : SizedBox());
  }

  Widget buildText(String text) => Center(
        child: Text(
          text,
          style: TextStyle(fontSize: 24),
        ),
      );
}
