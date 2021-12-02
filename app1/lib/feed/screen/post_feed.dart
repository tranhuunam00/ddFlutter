import 'dart:convert';

import 'package:app1/feed/model/feed_model.dart';
import 'package:app1/main.dart';
import 'package:app1/provider/feed_provider.dart';
import 'package:app1/provider/user_provider.dart';
import 'package:app1/widgets/dismit_keybord.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class PostFeedScreen extends StatefulWidget {
  const PostFeedScreen({Key? key}) : super(key: key);

  @override
  _PostFeedScreenState createState() => _PostFeedScreenState();
}

class _PostFeedScreenState extends State<PostFeedScreen> {
  TextEditingController _textController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final feedProvider = Provider.of<FeedProvider>(context, listen: false);

    var urlPostFeed = Uri.parse(SERVER_IP + '/feed');

    Future<String> PostFeedFunction(FeedBaseModel feed) async {
      print("chạy funcin");
      http.Response response;
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      response = await http.post(urlPostFeed,
          headers: {
            'Content-type': 'application/json',
            'Accept': 'application/json',
            'cookie': "jwt=" + userProvider.jwtP,
          },
          body: jsonEncode({
            "sourceUserId": feed.sourceUserId,
            "sourceUserName": feed.sourceUserName,
            "pathImg": feed.pathImg,
            "messages": feed.message,
            "rule": feed.rule,
            "like": [],
            "comment": [],
            "createdAt": feed.createdAt,
          }));

      if (response.statusCode == 200 || response.statusCode == 201) {
        print(json.decode(response.body).toString());
        return json.decode(response.body).toString();
      } else {
        return "error";
      }
    }

    return DismissKeyboard(
      child: Scaffold(
        body: Container(
          child: Column(
            children: [
              SizedBox(
                height: 100,
              ),
              TextField(
                  controller: _textController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: InputDecoration(hintText: "bạn đang nghĩ gì")),
              SizedBox(
                height: 50,
              ),
              InkWell(
                child: Text("gửi"),
                onTap: () async {
                  FeedBaseModel feed = new FeedBaseModel(
                      like: [],
                      rule: [],
                      comment: [],
                      pathImg: [],
                      createdAt: DateTime.now().toString(),
                      sourceUserId: userProvider.userP.id,
                      message: _textController.text,
                      sourceUserName: userProvider.userP.userName);
                  print(_textController.text);
                  String newIdFeed = await PostFeedFunction(feed);
                  if (newIdFeed == "not jwt" || newIdFeed == "error") {
                    print(newIdFeed);
                  } else {
                    if (newIdFeed != "error") {
                      FeedBaseModel a = new FeedBaseModel(
                          like: [],
                          comment: [],
                          rule: [],
                          pathImg: [],
                          feedId: newIdFeed,
                          message: _textController.text,
                          sourceUserName: userProvider.userP.userName);
                      List<FeedBaseModel> b = feedProvider.listFeedsP;
                      b.insert(0, feed);
                      print("đã tạo mới bài viết rồi!");
                      feedProvider.userFeed(b);
                      Navigator.pop(context);
                    }
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
