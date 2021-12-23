import 'package:app1/Screen/FriendProfile.dart';
import 'package:app1/chat-app/model/chat_modal.dart';
import 'package:app1/chat-app/screens_chat/individual_chat.dart';
import 'package:app1/main.dart';
import 'package:app1/model/user_model.dart';
import 'package:app1/provider/user_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Notify_Card extends StatelessWidget {
  const Notify_Card(
      {Key? key,
      required this.idUserSource,
      required this.pathImgSource,
      required this.realNameSource,
      required this.type,
      required this.isSeen,
      required this.createdAt,
      required this.content})
      : super(key: key);
  final String pathImgSource;
  final String realNameSource;
  final String idUserSource;
  final String type;
  final String content;
  final String createdAt;
  final bool isSeen;
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    return Column(
      children: [
        Container(
          child: InkWell(
            hoverColor: Colors.amber,
            onTap: () {
              print(pathImgSource);
              print(idUserSource);
              if (type == "addFr") {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (builder) =>
                            FriendProfile(frId: idUserSource)));
              }
              if (type == "newMsg") {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (builder) => IndividualChat(
                              sourceChat: ChatModel(
                                id: userProvider.userP.id,
                                avatar: userProvider.userP.avatarImg[
                                    userProvider.userP.avatarImg.length - 1],
                                realName: userProvider.userP.realName,
                              ),
                              chatModel: ChatModel(
                                id: idUserSource,
                                realName: realNameSource,
                                avatar: pathImgSource,
                              ),
                            )));
              }
            },
            child: ListTile(
                leading: CustomPaint(
                  child: CircleAvatar(
                    backgroundImage: AssetImage('assets/images/load.gif'),
                    radius: 26,
                    child: CircleAvatar(
                      radius: 26,
                      backgroundImage:
                          NetworkImage(SERVER_IP + "/upload/" + pathImgSource),
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                ),
                trailing: SizedBox(
                    height: 50,
                    width: 50,
                    child: InkWell(
                      onTap: () async {
                        print("xóa");
                        await showModalBottomSheet<String>(
                            context: context,
                            builder: (BuildContext context) {
                              return Container(
                                  height: 200,
                                  child: Center(
                                      child: SizedBox(
                                          height: 100,
                                          width: 100,
                                          child: InkWell(
                                              onTap: () {
                                                print("xóa");
                                              },
                                              child: Text("xóa",
                                                  textAlign:
                                                      TextAlign.center)))));
                            });
                      },
                      child: Text(
                        "...",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    )),
                title: Text(
                  realNameSource + " đã " + type + " cho bạn",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                subtitle: Text(
                  createdAt,
                  style: TextStyle(color: Colors.grey[900], fontSize: 11),
                )),
          ),
        ),
        Divider(
          height: 1,
          thickness: 2,
        )
      ],
    );
  }
}
