import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_wastage/constants/colors.dart';
import 'package:food_wastage/models/chat.dart';
import 'package:food_wastage/models/message.dart';
import 'package:food_wastage/services/chat_service.dart';

import 'fr_chat_page.dart';

class FrChatsPage extends StatefulWidget {
  const FrChatsPage({Key? key}) : super(key: key);

  @override
  _FrChatsPageState createState() => _FrChatsPageState();
}

class _FrChatsPageState extends State<FrChatsPage> {
  List<Chat> _chats = [];
  bool _loadingDone = false;

  Future<void> _getChats() async {
    _chats = await ChatService().getMyChats();
    print('_chats geldi : $_chats');
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
                            element.accountUID == _chat.accounts['userUID'] &&
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
                                builder: (context) => FrChatPage(
                                    userUID: _chat.accounts['userUID'],
                                    username: _chat.accounts['userName']),
                              ),
                            );
                          },
                          title: Text(_chat.accounts['userName']!),
                          subtitle: Row(
                            children: [
                              _chat.messages.last.accountUID ==
                                      _chat.accounts['foodRecipientUID']
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
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 4.0),
                                    child: Text(
                                      _chat.messages.last.message,
                                      overflow: TextOverflow.ellipsis,
                                    ),
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
                              : null,
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
