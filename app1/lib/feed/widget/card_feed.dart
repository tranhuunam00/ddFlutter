import 'dart:convert';

import 'package:app1/chat-app/customs/avatar_card.dart';
import 'package:app1/feed/model/feed_model.dart';
import 'package:app1/feed/screen/comment.dart';
import 'package:app1/feed/screen/mainFeedScreen.dart';
import 'package:app1/main.dart';
import 'package:app1/model/user_model.dart';
import 'package:app1/provider/comment_provider.dart';
import 'package:app1/provider/user_provider.dart';
import 'package:app1/ui.dart';
import 'package:app1/widgets/card_video.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import 'package:http/http.dart' as http;

class CardFeedStyle extends StatefulWidget {
  final FeedBaseModel feed;
  CardFeedStyle({Key? key, required this.feed, required this.ownFeedUser})
      : super(key: key);

  final UserModel ownFeedUser;
  @override
  _CardFeedStyleState createState() => _CardFeedStyleState();
}

class _CardFeedStyleState extends State<CardFeedStyle> {
  final int totalLike = 0;
  final int totalComment = 0;
  FeedBaseModel feedApi = new FeedBaseModel(
      like: [], rule: [], comment: [], pathImg: [], tag: [], pathVideo: []);
  late bool isLike = false;
  late VideoPlayerController _videoPlayerController;
  @override
  void initState() {
    super.initState();
    feedApi = widget.feed;
    if (widget.feed.pathImg.length > 0) {
      for (int i = 0; i < widget.feed.pathImg.length; i++) {
        if (widget.feed.pathImg[i].toString().substring(
                    widget.feed.pathImg[i].toString().length - 3,
                    widget.feed.pathImg[i].toString().length) !=
                'png' ||
            widget.feed.pathImg[i].toString().substring(
                    widget.feed.pathImg[i].toString().length - 3,
                    widget.feed.pathImg[i].toString().length) !=
                'jpg' ||
            widget.feed.pathImg[i].toString().substring(
                    widget.feed.pathImg[i].toString().length - 3,
                    widget.feed.pathImg[i].toString().length) !=
                'gif') {
          _videoPlayerController = VideoPlayerController.network(
              SERVER_IP + "/upload/" + widget.feed.pathImg[0].toString())
            ..addListener(() {})
            ..setLooping(true)
            ..initialize().then((_) => _videoPlayerController.pause());
        }
      }
    }
    for (int i = 0; i < widget.feed.pathVideo.length; i++) {
      {
        _videoPlayerController = VideoPlayerController.network(
            SERVER_IP + "/upload/" + widget.feed.pathVideo[i].toString())
          ..addListener(() => {
                // if (mounted) {setState(() {})}
              })
          ..setLooping(true)
          ..initialize().then((_) => _videoPlayerController.pause());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final commentProvider =
        Provider.of<CommentProvider>(context, listen: false);

    Size size = MediaQuery.of(context).size;
    for (int i = 0; i < feedApi.like.length; i++) {
      if (feedApi.like[i] == userProvider.userP.id) {
        print("------đã like-------");
        isLike = true;
      }
    }
    Widget FeedVideosContainer(videosList) {
      switch (videosList.length) {
        case 1:
          return Container(
            width: size.width - 40,
            height: size.height - 300,
            child: Container(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  VideoPlayer(_videoPlayerController),
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
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (builder) => CardFeedVideoState(
                                      controller: _videoPlayerController)));
                        },
                        icon: Icon(Icons.play_circle_fill_outlined),
                      ),
                    ),
                  ), //position hiển thi icon video
                ],
              ),
            ),
          );
          break;
      }
      return Container();
    }

    Widget FeedImagesContainer(imagesList) {
      switch (imagesList.length) {
        case 1:
          return Container(
            color: Colors.black12,
            width: size.width - 40,
            height: size.height - 300,
            child: (imagesList[0].toString().substring(
                            imagesList[0].toString().length - 3,
                            imagesList[0].toString().length) ==
                        "png" ||
                    imagesList[0].toString().substring(
                            imagesList[0].toString().length - 3,
                            imagesList[0].toString().length) ==
                        "jpg" ||
                    imagesList[0].toString().substring(
                            imagesList[0].toString().length - 3,
                            imagesList[0].toString().length) ==
                        "gif")
                ? CachedNetworkImage(
                    imageUrl: SERVER_IP + "/upload/" + imagesList[0],
                    fit: BoxFit.fitWidth,
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  )
                : Container(
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        VideoPlayer(_videoPlayerController),
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
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (builder) =>
                                            CardFeedVideoState(
                                                controller:
                                                    _videoPlayerController)));
                              },
                              icon: Icon(Icons.play_circle_fill_outlined),
                            ),
                          ),
                        ), //position hiển thi icon video
                      ],
                    ),
                  ),
          );
          break;
        case 2:
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  color: Colors.black,
                  width: (size.width - 50) / 2,
                  height: (size.width - 50) / 2 * 5 / 3,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      CachedNetworkImage(
                        imageUrl: SERVER_IP + "/upload/" + imagesList[0],
                        fit: BoxFit.fitWidth,
                        placeholder: (context, url) =>
                            CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
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
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(builder: (builder) =>
                              //         ListImageFeed( feed: widget.feed ,ownFeedUser: widget.ownFeedUser,)));
                            },
                            icon: Icon(
                              Icons.photo_album_outlined,
                              size: 5,
                            ),
                          ),
                        ),
                      ), //position hiển thi icon video
                    ],
                  )),
              Container(
                  color: Colors.black,
                  height: (size.width - 50) / 2 * 5 / 3,
                  width: (size.width - 50) / 2,
                  child: CachedNetworkImage(
                    imageUrl: SERVER_IP + "/upload/" + imagesList[1],
                    fit: BoxFit.fitWidth,
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  )),
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
                  child: CachedNetworkImage(
                    imageUrl: SERVER_IP + "/upload/" + imagesList[0],
                    fit: BoxFit.fitWidth,
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  )),
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
                        child: CachedNetworkImage(
                          imageUrl: SERVER_IP + "/upload/" + imagesList[1],
                          fit: BoxFit.fitWidth,
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        )),
                    Container(
                        color: Colors.black38,
                        height: (size.width - 10) / 2,
                        width: (size.width - 50) / 2,
                        child: CachedNetworkImage(
                          imageUrl: SERVER_IP + "/upload/" + imagesList[2],
                          fit: BoxFit.fitWidth,
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        )),
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
                  child: CachedNetworkImage(
                    imageUrl: SERVER_IP + "/upload/" + imagesList[0],
                    fit: BoxFit.fitWidth,
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  )),
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
                        child: CachedNetworkImage(
                          imageUrl: SERVER_IP + "/upload/" + imagesList[1],
                          fit: BoxFit.fitWidth,
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        )),
                    Container(
                        color: Colors.black38,
                        height: (size.width - 10) / 3,
                        width: (size.width - 50) / 2,
                        child: CachedNetworkImage(
                          imageUrl: SERVER_IP + "/upload/" + imagesList[2],
                          fit: BoxFit.fitWidth,
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        )),
                    Container(
                        color: Colors.black38,
                        height: (size.width - 10) / 3,
                        width: (size.width - 50) / 2,
                        child: CachedNetworkImage(
                          imageUrl: SERVER_IP + "/upload/" + imagesList[3],
                          fit: BoxFit.fitWidth,
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        )),
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
                  child: CachedNetworkImage(
                    imageUrl: SERVER_IP + "/upload/" + imagesList[0],
                    fit: BoxFit.fitWidth,
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  )),
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
                        child: CachedNetworkImage(
                          imageUrl: SERVER_IP + "/upload/" + imagesList[1],
                          fit: BoxFit.fitWidth,
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        )),
                    Container(
                        color: Colors.black38,
                        height: (size.width - 10) / 3,
                        width: (size.width - 50) / 2,
                        child: CachedNetworkImage(
                          imageUrl: SERVER_IP + "/upload/" + imagesList[2],
                          fit: BoxFit.fitWidth,
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        )),
                    Stack(children: [
                      Container(
                          color: Colors.black38,
                          height: (size.width - 10) / 3,
                          width: (size.width - 50) / 2,
                          child: CachedNetworkImage(
                            imageUrl: SERVER_IP + "/upload/" + imagesList[3],
                            fit: BoxFit.fitWidth,
                            placeholder: (context, url) =>
                                CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          )),
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
                              " + " + (imagesList.length - 4).toString(),
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
        child: InkWell(
          onTap: () {
            print("ấn vào card");
            if (widget.feed.pathImg.length > 0 ||
                widget.feed.message.length > 50 ||
                widget.feed.pathVideo.length > 0) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (builder) => MainFeedScreen(
                          feed: widget.feed, ownFeedUser: widget.ownFeedUser)));
            }
          },
          child: Stack(children: [
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    color: Colors.blue[100],
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(mainAxisSize: MainAxisSize.max, children: [
                        CircleAvatar(
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
                        Container(
                            width: size.width - 180,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                new Text(" " + widget.ownFeedUser.realName,
                                    style: AppStyles.h4
                                        .copyWith(fontWeight: FontWeight.bold)),
                                Row(
                                  children: [
                                    Text(
                                      widget.feed.createdAt.substring(0, 10),
                                      style: AppStyles.h5,
                                    ),
                                  ],
                                ),
                              ],
                            )),
                      ]),
                    ),
                  ),
                  Divider(),
                  widget.feed.message != ""
                      ? Container(
                          constraints: BoxConstraints(minHeight: 100),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 30, bottom: 8),
                            child: SizedBox(
                              width: size.width,
                              child: AutoSizeText(
                                widget.feed.message,
                                maxLines: 5,
                                minFontSize: 18,
                                style: widget.feed.message.length > 30
                                    ? AppStyles.h3
                                    : AppStyles.h2,
                              ),
                            ),
                          ),
                        )
                      : Container(),
                  Divider(),
                  widget.feed.pathImg.length > 0
                      ? Center(
                          child: FeedImagesContainer(widget.feed.pathImg),
                        )
                      : Container(),
                  widget.feed.pathVideo.length > 0
                      ? Center(
                          child: FeedVideosContainer(widget.feed.pathVideo),
                        )
                      : Container(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      feedApi.like.length > 0
                          ? Row(
                              children: [
                                Text(
                                  "   " +
                                      feedApi.like.length.toString() +
                                      " like",
                                  style: TextStyle(color: Colors.red),
                                )
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
                          icon: isLike
                              ? Image.asset("assets/icons/likedIcon.png",
                                  height: 40)
                              : Image.asset("assets/icons/notLikeIcon.png",
                                  height: 40),
                          label: Text("",
                              style: TextStyle(
                                  color: isLike ? Colors.blue : Colors.grey))),
                      TextButton.icon(
                          onPressed: () async {
                            commentProvider.userFeedId(widget.feed.feedId);
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
                          icon: Image.asset("assets/icons/messageIcon.png",
                              height: 40),
                          label: Text(""))
                    ],
                  )
                ],
              ),
            ),
            Positioned(
              right: 24,
              child: Material(
                color: Colors.blue[100],
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
          ]),
        ));
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
        return FeedBaseModel(
            like: [],
            rule: [],
            comment: [],
            pathImg: [],
            tag: [],
            pathVideo: []);
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
}
