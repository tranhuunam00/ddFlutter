import 'dart:convert';

import 'package:app1/chat-app/customs/avatar_card.dart';
import 'package:app1/feed/model/feed_model.dart';
import 'package:app1/feed/screen/comment.dart';
import 'package:app1/main.dart';
import 'package:app1/model/user_model.dart';
import 'package:app1/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import "../ui.dart";
import 'package:http/http.dart' as http;

class CardFeedStyle extends StatefulWidget {
  final List<String> imagesList = [
    "assets/images/nature1.jpg",
    "assets/images/nature2.jpg",
    "assets/images/nature2.jpg",
    "assets/images/nature2.jpg",
    "assets/images/nature2.jpg",
    "assets/images/nature2.jpg",
  ];
  final FeedBaseModel feed;
  CardFeedStyle(
      {Key? key,
      required this.feed,
      required this.userOwnUse,
      required this.ownFeedUser})
      : super(key: key);
  final UserModel userOwnUse;
  final UserModel ownFeedUser;
  @override
  _CardFeedStyleState createState() => _CardFeedStyleState();
}

class _CardFeedStyleState extends State<CardFeedStyle> {
  final int totalLike = 0;
  final int totalComment = 0;
  FeedBaseModel feedApi =
      new FeedBaseModel(like: [], rule: [], comment: [], pathImg: []);
  late bool isLike = false;
  @override
  void initState() {
    super.initState();
    feedApi = widget.feed;
    for (int i = 0; i < feedApi.like.length; i++) {
      if (feedApi.like[i] == widget.userOwnUse.id) {
        print("------đã like-------");
        isLike = true;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    Size size = MediaQuery.of(context).size;

    Widget FeedImagesContainer(imagesList) {
      switch (imagesList.length) {
        case 1:
          return Container(
              width: size.width - 40,
              height: size.height - 300,
              child: Image.asset("assets/images/nature1.jpg",
                  fit: BoxFit.contain));
          break;
        case 2:
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  color: Colors.black,
                  width: (size.width - 50) / 2,
                  height: (size.width - 50) / 2 * 5 / 3,
                  child: Image.asset("assets/images/nature5.jpg",

                      // color: Color.fromRGBO(255, 255, 255, 0.7),
                      colorBlendMode: BlendMode.modulate,
                      fit: BoxFit.contain)),
              Container(
                  color: Colors.black,
                  height: (size.width - 50) / 2 * 5 / 3,
                  width: (size.width - 50) / 2,
                  child: Image.asset("assets/images/nature2.jpg",
                      fit: BoxFit.fitHeight)),
            ],
          );
          break;
        case 3:
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  color: Colors.black38,
                  width: (size.width - 50) / 2,
                  height: size.width,
                  child: Image.network(
                      'https://image.winudf.com/v2/image/Y29tLmRldi5jdWlhcHAubmF0dXJlX3NjcmVlbnNob3RzXzFfYTM0ZjAyMTI/screen-1.jpg?fakeurl=1&type=.jpg',
                      fit: BoxFit.fitHeight, loadingBuilder:
                          (BuildContext context, Widget child,
                              ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    }
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  })),
              Container(
                width: (size.width - 50) / 2,
                height: size.width,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        color: Colors.black38,
                        height: (size.width - 10) / 2,
                        width: (size.width - 50) / 2,
                        child: Image.asset("assets/images/nature1.jpg",
                            fit: BoxFit.fitWidth)),
                    Container(
                        color: Colors.black38,
                        height: (size.width - 10) / 2,
                        width: (size.width - 50) / 2,
                        child: Image.asset("assets/images/nature2.jpg",
                            fit: BoxFit.contain)),
                  ],
                ),
              )
            ],
          );
          break;
        case 4:
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  color: Colors.black38,
                  width: (size.width - 50) / 2,
                  height: size.width,
                  child: Image.network(
                      'https://image.winudf.com/v2/image/Y29tLmRldi5jdWlhcHAubmF0dXJlX3NjcmVlbnNob3RzXzFfYTM0ZjAyMTI/screen-1.jpg?fakeurl=1&type=.jpg',
                      fit: BoxFit.fitHeight, loadingBuilder:
                          (BuildContext context, Widget child,
                              ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    }
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  })),
              Container(
                width: (size.width - 50) / 2,
                height: size.width,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        color: Colors.black38,
                        height: (size.width - 10) / 3,
                        width: (size.width - 50) / 2,
                        child: Image.asset("assets/images/nature1.jpg",
                            fit: BoxFit.fitWidth)),
                    Container(
                        color: Colors.black38,
                        height: (size.width - 10) / 3,
                        width: (size.width - 50) / 2,
                        child: Image.asset("assets/images/nature6.jpg",
                            fit: BoxFit.fitWidth)),
                    Container(
                        color: Colors.black38,
                        height: (size.width - 10) / 3,
                        width: (size.width - 50) / 2,
                        child: Image.asset("assets/images/nature2.jpg",
                            fit: BoxFit.fitWidth)),
                  ],
                ),
              )
            ],
          );
          break;
        default:
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  color: Colors.black38,
                  width: (size.width - 42) / 2,
                  height: size.width,
                  child: Image.network(
                      'https://image.winudf.com/v2/image/Y29tLmRldi5jdWlhcHAubmF0dXJlX3NjcmVlbnNob3RzXzFfYTM0ZjAyMTI/screen-1.jpg?fakeurl=1&type=.jpg',
                      fit: BoxFit.fitHeight, loadingBuilder:
                          (BuildContext context, Widget child,
                              ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    }
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  })),
              Container(
                width: (size.width - 50) / 2,
                height: size.width,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        color: Colors.black38,
                        height: (size.width - 10) / 3,
                        width: (size.width - 50) / 2,
                        child: Image.asset("assets/images/nature1.jpg",
                            fit: BoxFit.fitWidth)),
                    Container(
                        color: Colors.black38,
                        height: (size.width - 10) / 3,
                        width: (size.width - 50) / 2,
                        child: Image.asset("assets/images/nature6.jpg",
                            fit: BoxFit.fitWidth)),
                    Stack(children: [
                      Container(
                          color: Colors.black38,
                          height: (size.width - 10) / 3,
                          width: (size.width - 50) / 2,
                          child: Image.asset("assets/images/nature2.jpg",
                              fit: BoxFit.fitWidth)),
                      Container(
                        color: Colors.black45,
                        height: (size.width - 10) / 3,
                        width: (size.width - 50) / 2,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Center(
                                child: Text(
                              "+3",
                              style: TextStyle(
                                  fontSize: 32, fontWeight: FontWeight.bold),
                            )),
                          ],
                        ),
                      ),
                    ]),
                  ],
                ),
              )
            ],
          );
          break;
      }
      return Container();
    }

    return Container(
        margin: const EdgeInsets.only(bottom: 40),
        decoration: BoxDecoration(
          color: Colors.orange[50],
          // border: Border.all(
          //   width: 1, //                   <--- border width here
          // ),
          borderRadius: BorderRadius.all(Radius.circular(16)),
          boxShadow: [
            BoxShadow(
              color: Colors.black26.withOpacity(0.5),
              blurRadius: 4,
              offset: Offset(3, 6), // changes position of shadow
            )
          ],
        ),
        child: Stack(children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(mainAxisSize: MainAxisSize.max, children: [
                  CircleAvatar(
                    radius: 24,
                  ),
                  Container(
                      width: size.width - 180,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          new Text(widget.ownFeedUser.id,
                              style: AppStyles.h3
                                  .copyWith(fontWeight: FontWeight.bold)),
                          new Text("    23/09"),
                        ],
                      )),
                ]),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30, bottom: 8),
                child: SizedBox(
                  width: size.width - 150,
                  child: Text(
                    widget.feed.message,
                    maxLines: 4,
                    overflow: TextOverflow.fade,
                    softWrap: false,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0),
                  ),
                ),
              ),
              widget.imagesList.length == 0
                  ? Center(
                      child: FeedImagesContainer(widget.imagesList),
                    )
                  : Container(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  feedApi.like.length > 0
                      ? Row(
                          children: [
                            CircleAvatar(
                              radius: 12,
                            ),
                            Text(feedApi.like.length.toString() + " like")
                          ],
                        )
                      : Container(),
                  totalComment != 0
                      ? Text(totalComment.toString() + " comment")
                      : Container()
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton.icon(
                      onPressed: () async {
                        print(feedApi.like.length);
                        print("tên người đang dùng là : " +
                            widget.userOwnUse.userName);
                        print(widget.feed.feedId);
                        if (isLike == false) {
                          List result = await Future.wait([
                            //lấy feed mới để hiển thị số like.........
                            getFeedApi(widget.feed.feedId, userProvider.jwtP),
                            //like bài viết
                            postApi(
                                userProvider.jwtP,
                                {"feedId": widget.feed.feedId, "event": "like"},
                                "/feed/likeFeed")
                          ]);
                          if (mounted) {
                            setState(() {
                              isLike = !isLike;
                              feedApi.like = result[0].like;
                              feedApi.like.add(widget.userOwnUse.id);
                            });
                          }
                        } else {
                          List result = await Future.wait([
                            //lấy feed mới để hiển thị số like.........
                            getFeedApi(widget.feed.feedId, userProvider.jwtP),
                            //like bài viết
                            postApi(
                                userProvider.jwtP,
                                {
                                  "feedId": widget.feed.feedId,
                                  "event": "dislike"
                                },
                                "/feed/likeFeed")
                          ]);
                          if (mounted) {
                            setState(() {
                              isLike = !isLike;
                              feedApi.like = result[0].like;
                              feedApi.like.remove(widget.userOwnUse.id);
                            });
                          }
                        }
                      },
                      icon: Icon(Icons.tag,
                          color: isLike ? Colors.blue : Colors.grey),
                      label: Text("Yêu thích",
                          style: TextStyle(
                              color: isLike ? Colors.blue : Colors.grey))),
                  TextButton.icon(
                      onPressed: () async {
                        print(widget.ownFeedUser.id);
                        print("bình luận");
                        FeedBaseModel feed1 = widget.feed;
                        print(widget.feed);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (builder) =>
                                    CommentScreen(feed: widget.feed)));
                      },
                      icon: Icon(Icons.message_outlined, color: Colors.red),
                      label: Text("Bình luận"))
                ],
              )
            ],
          ),
          Positioned(
            right: 24,
            child: Material(
              color: Colors.orange[50],
              child: Container(
                  alignment: Alignment.center,
                  width: 40,
                  height: 40,
                  child: InkWell(
                    onTap: () {
                      print("hi");
                    },
                    overlayColor: MaterialStateProperty.all(Colors.blue),
                    child: Container(
                        width: 40,
                        child: Text(
                          "...",
                          style: TextStyle(
                            fontSize: 24,
                          ),
                          textAlign: TextAlign.center,
                        )),
                  )),
            ),
          ),
        ]));
  }

  //-------------------GetApi init----------------------------------------
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
        return FeedBaseModel(like: [], rule: [], comment: [], pathImg: []);
      }
    } catch (e) {
      return FeedBaseModel(like: [], rule: [], comment: [], pathImg: []);
    }
  }

  //-----------------------like func------------
  getFeedApi(sourceId, jwt) async {
    FeedBaseModel feedApi =
        FeedBaseModel(like: [], rule: [], comment: [], pathImg: []);
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
          rule: data["rule"],
          message: data["messages"],
          createdAt: data["createdAt"],
        );
        return a;
      } else {
        return feedApi;
      }
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
}
