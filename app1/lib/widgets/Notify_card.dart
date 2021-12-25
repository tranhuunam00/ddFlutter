import 'dart:convert';

import 'package:app1/Screen/FriendProfile.dart';
import 'package:app1/chat-app/model/chat_modal.dart';
import 'package:app1/chat-app/screens_chat/individual_chat.dart';
import 'package:app1/feed/model/feed_model.dart';
import 'package:app1/feed/screen/mainFeedScreen.dart';
import 'package:app1/main.dart';
import 'package:app1/model/user_model.dart';
import 'package:app1/provider/user_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class Notify_Card extends StatefulWidget {
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
  State<Notify_Card> createState() => _Notify_CardState();
}

class _Notify_CardState extends State<Notify_Card> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: InkWell(
            hoverColor: Colors.amber,
            onTap: () async {
              final userProvider =
                  Provider.of<UserProvider>(context, listen: false);
              print(widget.pathImgSource);
              print(widget.idUserSource);
              if (widget.type == "addFr") {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (builder) =>
                            FriendProfile(frId: widget.idUserSource)));
              }
              if (widget.type == "confirmFr") {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (builder) =>
                            FriendProfile(frId: widget.idUserSource)));
              }
              if (widget.type == "newFeed") {
                FeedBaseModel feed =
                    await getFeedApi(widget.content, userProvider.jwtP);
                if (mounted) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (builder) => MainFeedScreen(
                              feed: feed,
                              ownFeedUser: UserModel(
                                  friend: [],
                                  hadMessageList: [],
                                  coverImg: [],
                                  friendConfirm: [],
                                  friendRequest: [],
                                  avatarImg: [widget.pathImgSource],
                                  realName: widget.realNameSource,
                                  id: widget.idUserSource))));
                }
              }
              if (widget.type == "newMsg") {
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
                                id: widget.idUserSource,
                                realName: widget.realNameSource,
                                avatar: widget.pathImgSource,
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
                      backgroundImage: NetworkImage(
                          SERVER_IP + "/upload/" + widget.pathImgSource),
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
                  widget.realNameSource + " đã " + widget.type + " cho bạn",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                subtitle: Text(
                  widget.createdAt,
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

//--------------------------like và dislike-----------------
postApi(String jwt, data, String sourcePath) async {
  print("----chạy hàm get api feed---------------");
  try {
    http.Response response;
    String path = SERVER_IP + sourcePath;
    print(path);
    response = await http.post(Uri.parse(path),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'cookie': "jwt=" + jwt,
        },
        body: jsonEncode(data));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return "error";
    }
  } catch (e) {
    return "error";
  }
}

Future fetchApiFindFeed(String sourceFeedId, String jwt) async {
  print("----chạy hàm get api feed---------------");
  try {
    print("source feed id là ");
    print(sourceFeedId);

    http.Response response;
    String path = SERVER_IP + '/feed/' + sourceFeedId;
    print(path);
    response = await http.get(
      Uri.parse(path),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'cookie': "jwt=" + jwt,
      },
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      print("kết quả là feed ");
      print(json.decode(response.body));
      return json.decode(response.body);
    } else {
      return FeedBaseModel(
          like: [], rule: [], comment: [], pathImg: [], tag: [], pathVideo: []);
    }
  } catch (e) {
    return FeedBaseModel(
        like: [], rule: [], comment: [], tag: [], pathImg: [], pathVideo: []);
  }
}

//-----------------------like func------------
getFeedApi(sourceId, jwt) async {
  FeedBaseModel feedApi = FeedBaseModel(
      like: [], tag: [], rule: [], comment: [], pathImg: [], pathVideo: []);
  var data = await fetchApiFindFeed(sourceId, jwt);
  if (data == "not jwt") {
    return feedApi;
  } else {
    if (data != "error") {
      print("data:feed là");
      print(data);
      print(data["like"]);
      FeedBaseModel a = FeedBaseModel(
        like: data["like"],
        comment: data["comment"],
        pathImg: data["pathImg"],
        pathVideo: data["pathVideo"],
        tag: data["tag"],
        rule: data["rule"],
        feedId: data["_id"].toString(),
        message: data["messages"],
        createdAt: data["createdAt"],
      );
      return a;
    } else {
      return feedApi;
    }
  }
}
