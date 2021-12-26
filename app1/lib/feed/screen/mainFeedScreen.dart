import 'dart:convert';

import 'package:app1/feed/model/feed_model.dart';
import 'package:app1/feed/screen/comment.dart';
import 'package:app1/main.dart';
import 'package:app1/model/user_model.dart';
import 'package:app1/provider/user_provider.dart';
import 'package:app1/widgets/card_video.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:video_player/video_player.dart';

class MainFeedScreen extends StatefulWidget {
  const MainFeedScreen(
      {Key? key, required this.feed, required this.ownFeedUser})
      : super(key: key);
  final FeedBaseModel feed;
  final UserModel ownFeedUser;

  @override
  _MainFeedScreenState createState() => _MainFeedScreenState();
}

class _MainFeedScreenState extends State<MainFeedScreen> {
  List listPathAll = [];
  final int totalLike = 0;
  final int totalComment = 0;
  FeedBaseModel feedApi = new FeedBaseModel(
      like: [], rule: [], comment: [], pathImg: [], tag: [], pathVideo: []);
  late bool isLike = false;
  VideoPlayerController? _videoPlayerController;
  @override
  void initState() {
    super.initState();
    feedApi = widget.feed;

    for (int i = 0; i < widget.feed.pathVideo.length; i++) {
      {
        _videoPlayerController = VideoPlayerController.network(
            SERVER_IP + "/upload/" + widget.feed.pathVideo[i].toString())
          ..addListener(() => {
                // if (mounted) {setState(() {})}
              })
          ..setLooping(true)
          ..initialize().then((_) => _videoPlayerController!.pause());
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (_videoPlayerController != null) {
      _videoPlayerController!.pause();
    }
  }

  Widget FeedImagesContainer(imagesPath) {
    return Container(
      width: MediaQuery.of(context).size.width - 40,
      height: MediaQuery.of(context).size.height - 300,
      child: (imagesPath.toString().substring(imagesPath.toString().length - 3,
                      imagesPath.toString().length) ==
                  "png" ||
              imagesPath.toString().substring(imagesPath.toString().length - 3,
                      imagesPath.toString().length) ==
                  "jpg" ||
              imagesPath.toString().substring(imagesPath.toString().length - 3,
                      imagesPath.toString().length) ==
                  "gif")
          ? CachedNetworkImage(
              imageUrl: SERVER_IP + "/upload/" + imagesPath,
              fit: BoxFit.fitWidth,
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Icon(Icons.error),
            )
          : Container(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  _videoPlayerController != null
                      ? VideoPlayer(_videoPlayerController!)
                      : Container(),
                  Positioned(
                    top: 0,
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      color: Color.fromRGBO(255, 255, 255, 0.4),
                      child: IconButton(
                        onPressed: () async {
                          print("hí");
                          _videoPlayerController != null
                              ? Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (builder) => CardFeedVideoState(
                                          controller: _videoPlayerController!)))
                              : null;
                        },
                        icon: Icon(Icons.play_circle_fill_outlined),
                      ),
                    ),
                  ), //position hiển thi icon video
                ],
              ),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    for (int i = 0; i < feedApi.like.length; i++) {
      if (feedApi.like[i] == userProvider.userP.id) {
        print("------đã like-------");
        isLike = true;
      }
    }
    if (widget.feed.pathImg.length > 0) {
      listPathAll = widget.feed.pathImg;
    } else {
      listPathAll = widget.feed.pathVideo;
    }
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: ListView.builder(
            itemCount: listPathAll.length + 3,
            itemBuilder: (context, index) {
              if (index == 0) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.red,
                    radius: 23,
                    backgroundImage: AssetImage('assets/images/load.gif'),
                    child: CircleAvatar(
                      radius: 23,
                      backgroundImage: NetworkImage(SERVER_IP +
                          "/upload/" +
                          widget.ownFeedUser.avatarImg[
                              widget.ownFeedUser.avatarImg.length - 1]),
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                  title: Text(widget.ownFeedUser.realName),
                  subtitle: Text(widget.feed.createdAt),
                );
              }
              if (index == 1) {
                return Text(widget.feed.message);
              }
              if (index == listPathAll.length + 2) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 30.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton.icon(
                          onPressed: () async {
                            print(feedApi.like.length);
                            print("tên người đang dùng là : " +
                                userProvider.userP.userName);
                            print(widget.feed.feedId);
                            if (isLike == false) {
                              List result = await Future.wait([
                                //lấy feed mới để hiển thị số like.........
                                getFeedApi(
                                    widget.feed.feedId, userProvider.jwtP),
                                //like bài viết
                                postApi(
                                    userProvider.jwtP,
                                    {
                                      "feedId": widget.feed.feedId,
                                      "event": "like",
                                      "createdAt": DateTime.now().toString()
                                    },
                                    "/feed/likeFeed")
                              ]);
                              if (mounted) {
                                setState(() {
                                  isLike = !isLike;
                                  feedApi.like = result[0].like;
                                  feedApi.like.add(userProvider.userP.id);
                                });
                              }
                            } else {
                              List result = await Future.wait([
                                //lấy feed mới để hiển thị số like.........
                                getFeedApi(
                                    widget.feed.feedId, userProvider.jwtP),
                                //like bài viết
                                postApi(
                                    userProvider.jwtP,
                                    {
                                      "feedId": widget.feed.feedId,
                                      "event": "dislike",
                                      "createdAt": DateTime.now().toString()
                                    },
                                    "/feed/likeFeed")
                              ]);
                              if (mounted) {
                                setState(() {
                                  isLike = !isLike;
                                  feedApi.like = result[0].like;
                                  feedApi.like.remove(userProvider.userP.id);
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
                            print('Số lượng ảnh hoặc video là' +
                                listPathAll.length.toString());
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (builder) =>
                                        CommentScreen(feed: widget.feed)));
                          },
                          icon: Icon(Icons.message_outlined, color: Colors.red),
                          label: Text("Bình luận"))
                    ],
                  ),
                );
              }

              return Column(
                children: [
                  Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 3 / 5,
                      child: FeedImagesContainer(listPathAll[index - 2])),
                  Divider()
                ],
              );
            }),
      ),
    );
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
