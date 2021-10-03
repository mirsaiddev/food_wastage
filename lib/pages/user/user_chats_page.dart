import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_wastage/constants/colors.dart';
import 'package:food_wastage/models/chat.dart';
import 'package:food_wastage/pages/food_recipient/fr_chat_page.dart';
import 'package:food_wastage/pages/user/user_chat_page.dart';
import 'package:food_wastage/services/chat_service.dart';

class UserChatsPage extends StatefulWidget {
  const UserChatsPage({Key? key}) : super(key: key);

  @override
  _UserChatsPageState createState() => _UserChatsPageState();
}

class _UserChatsPageState extends State<UserChatsPage> {
  List<Chat> _chats = [];
  bool _loadingDone = false;

  Future<void> _getChats() async {
    _chats = await ChatService().getMyChats();
    _loadingDone = true;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _getChats();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _loadingDone
            ? ListView.builder(
                itemCount: _chats.length,
                itemBuilder: (context, index) {
                  Chat _chat = _chats[index];
                  _chat.messages
                      .sort((a, b) => a.createdAt.compareTo(b.createdAt));
                  int _newMessages = _chat.messages
                      .where(
                        (element) =>
                            element.accountUID ==
                                _chat.accounts['foodRecipientUID'] &&
                            !element.seenByOpponent,
                      )
                      .toList()
                      .length;
                  return Column(
                    children: [
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(),
                        margin: EdgeInsets.all(8),
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UserChatPage(
                                    foodRecipientUID:
                                        _chat.accounts['foodRecipientUID'],
                                    foodRecipientname:
                                        _chat.accounts['foodRecipientName']),
                              ),
                            );
                          },
                          title: Text(_chat.accounts['foodRecipientName']!),
                          subtitle: Row(
                            children: [
                              _chat.messages.last.accountUID ==
                                      _chat.accounts['userUID']
                                  ? _chat.messages.last.seenByOpponent
                                      ? Padding(
                                          padding:
                                              const EdgeInsets.only(right: 4.0),
                                          child: Image.asset(
                                            'assets/double-check.png',
                                            color: Colors.red,
                                            scale: 2,
                                          ),
                                        )
                                      : Padding(
                                          padding:
                                              const EdgeInsets.only(right: 4.0),
                                          child: Image.asset(
                                            'assets/check.png',
                                            color: Colors.red,
                                            scale: 2.5,
                                          ),
                                        )
                                  : SizedBox(),
                              Flexible(
                                child: Container(
                                  child: Text(
                                    _chat.messages.last.message,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          trailing: _newMessages != 0
                              ? CircleAvatar(
                                  backgroundColor: MyColors.red,
                                  child: Text(_newMessages.toString()),
                                )
                              : SizedBox(),
                        ),
                      ),
                      Divider(endIndent: 14, indent: 14)
                    ],
                  );
                },
              )
            : Center(
                child: CircularProgressIndicator(),
              ));
  }
}
