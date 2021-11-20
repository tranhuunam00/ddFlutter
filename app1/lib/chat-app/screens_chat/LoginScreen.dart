import 'package:app1/chat-app/customs/avatar_card.dart';
import 'package:app1/chat-app/customs/button_card.dart';
import 'package:app1/chat-app/customs/contact_card.dart';
import 'package:app1/chat-app/model/chat_modal.dart';
import 'package:app1/chat-app/screens_chat/home.dart';
import 'package:app1/provider/user_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatLoginScreen extends StatefulWidget {
  const ChatLoginScreen({Key? key}) : super(key: key);
  @override
  _ChatLoginScreenState createState() => _ChatLoginScreenState();
}

class _ChatLoginScreenState extends State<ChatLoginScreen> {
  ChatModel? sourceChat;
  List<ChatModel> chatFriend = [];

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    for (int i = 0; i < userProvider.userP.friend!.length; i++) {
      chatFriend.add(ChatModel(
          id: userProvider.userP.friend![i],
          userName: i.toString(),
          icon: "person",
          isGroup: false,
          time: "4.00",
          currentMessage: "hi 3"));
    }
    return Scaffold(
        appBar: AppBar(),
        body: Stack(children: [
          ListView.builder(
              itemCount: userProvider.userP.friend!.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Container(
                      height: userProvider.userP.friend!.length > 0 ? 90 : 10);
                }
                return InkWell(
                    onTap: () {
                      if (userProvider.userP.friend![index - 1].isSelect ==
                          false) {
                        setState(() {
                          print("--- chon avatar----");

                          // userProvider.userP.friend![index - 1].isSelect = true;
                          // groups.add(userProvider.userP.friend!.[index - 1]);
                        });
                      } else {
                        setState(() {
                          print("--- chon avatar----");

                          // userProvider.userP.friend![index - 1].isSelect = false;
                          // groups.remove(userProvider.userP.friend!.[index - 1]);
                        });
                      }
                    },
                    child: ContactCard(
                        contact: ChatModel(
                            userName: userProvider.userP.friend![index - 1])));
              }),
          //head list
          userProvider.userP.friend!.length > 0
              ? Column(
                  children: [
                    Container(
                        height: 75,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.white,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: userProvider.userP.friend!.length,
                            itemBuilder: (context, index) {
                              if (true)
                                return InkWell(
                                    onTap: () {
                                      setState(() {
                                        print("--- chon avatar----");
                                        // userProvider.userP.friend![index].isSelect =
                                        //     false;
                                        // groups.remove(userProvider.userP.friend!.[index]);
                                      });
                                    },
                                    child: AvatarCard(
                                        contact: ChatModel(
                                            userName: userProvider
                                                .userP.friend![index])));
                              else
                                return Container();
                            })),
                    Divider(
                      thickness: 1,
                    )
                  ],
                )
              : Container(
                  height: 0,
                ),
        ]));
  }
}
