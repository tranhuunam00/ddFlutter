import 'package:app1/chat-app/customs/button_card.dart';
import 'package:app1/chat-app/model/chat_modal.dart';
import 'package:app1/chat-app/screens_chat/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatLoginScreen extends StatefulWidget {
  const ChatLoginScreen({Key? key}) : super(key: key);

  @override
  _ChatLoginScreenState createState() => _ChatLoginScreenState();
}

class _ChatLoginScreenState extends State<ChatLoginScreen> {
  ChatModel? sourceChat;
  List<ChatModel> chatmodels = [
    ChatModel(
        id: 1,
        name: "Dev",
        icon: "person",
        isGroup: false,
        time: "4.00",
        currentMessage: "hi everyone"),
    ChatModel(
        id: 2,
        name: "Dev-1",
        icon: "person",
        isGroup: true,
        time: "9.00",
        currentMessage: "hi 1"),
    ChatModel(
        id: 3,
        name: "Dev-2",
        icon: "person",
        isGroup: false,
        time: "1.00",
        currentMessage: "hi 2"),
    ChatModel(
        id: 4,
        name: "Dev-3",
        icon: "person",
        isGroup: false,
        time: "4.00",
        currentMessage: "hi 3"),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
          itemCount: chatmodels.length,
          itemBuilder: (context, index) {
            return InkWell(
                onTap: () {
                  sourceChat = chatmodels.removeAt(index);
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (builder) => HomeChatScreen(
                                chatmodels: chatmodels,
                                sourceChat: sourceChat,
                              )));
                },
                child: ButtonCard(
                    name: chatmodels[index].name, icon: Icons.person));
          }),
    );
  }
}
