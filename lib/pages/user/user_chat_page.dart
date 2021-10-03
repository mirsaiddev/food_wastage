import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_wastage/models/message.dart';
import 'package:food_wastage/services/auth_service.dart';
import 'package:food_wastage/services/chat_service.dart';
import 'package:food_wastage/services/firestore_service.dart';
import 'package:food_wastage/widgets/message_widget.dart';
import 'package:ntp/ntp.dart';

class UserChatPage extends StatefulWidget {
  const UserChatPage(
      {Key? key,
      required this.foodRecipientUID,
      required this.foodRecipientname})
      : super(key: key);
  final String foodRecipientUID, foodRecipientname;

  @override
  _UserChatPageState createState() =>
      _UserChatPageState(foodRecipientUID, foodRecipientname);
}

class _UserChatPageState extends State<UserChatPage> {
  final String foodRecipientname, foodRecipientUID;

  _UserChatPageState(this.foodRecipientUID, this.foodRecipientname);

  late String _userName, _userUID;

  bool _namesLoaded = false;
  bool _chatIsCreatedBefore = false;

  TextEditingController _controller = TextEditingController();
  ScrollController _scrollController = ScrollController();

  Future<void> _getUsernames() async {
    _userUID = await AuthService().getCurrentUser()!.uid;
    _userName = await FirestoreService().getUsernameByUID(_userUID);
    _namesLoaded = true;
    setState(() {});
  }

  Future<void> checkIsChatCreated() async {
    _chatIsCreatedBefore = await ChatService().isChatCreatedBefore(
        foodRecipientUID: foodRecipientUID, userUID: _userUID);
    if (!_chatIsCreatedBefore) {
      await ChatService().createChat(
          foodRecipientUID: foodRecipientUID,
          userUID: _userUID,
          foodRecipientName: foodRecipientname,
          userName: _userName);
    }
  }

  Future<void> _sendMessage(String message) async {
    _controller.clear();
    FocusScope.of(context).unfocus();
    Message _message = Message(
        accountUID: _userUID,
        username: _userName,
        message: message,
        createdAt: await NTP.now(),
        seenByOpponent: false);
    await ChatService().sendMessage(_message, '$foodRecipientUID$_userUID');
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
          title: Text(foodRecipientname),
        ),
        body: _namesLoaded
            ? Column(
                children: [
                  Expanded(
                    child: Container(
                      child: StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection(
                                  'chats/$foodRecipientUID$_userUID/messages')
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
                                        foodRecipientUID) {
                                      ChatService().setMessageIsSeen(
                                        chatID: '$foodRecipientUID$_userUID',
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
                                                    '$foodRecipientUID$_userUID',
                                                message: message,
                                                myUID: _userUID);
                                            return MessageWidget(
                                              message: message,
                                              isMe: message.accountUID ==
                                                  _userUID,
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
