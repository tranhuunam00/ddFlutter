import 'dart:convert';
import 'dart:math';

import 'package:app1/feed/model/feed_model.dart';
import 'package:app1/feed/screen/post_feed.dart';
import 'package:app1/main.dart';
import 'package:app1/model/user_model.dart';
import 'package:app1/provider/feed_provider.dart';
import 'package:app1/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../ui.dart';
import '../feed/widget/card_feed.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<FeedBaseModel> listFeeds = [];
  Map<String, UserModel> listUsers = {};
  ScrollController _scrollController = new ScrollController();
  List<FeedBaseModel> listFeedAll = [];
  List<FeedBaseModel> listFeedVision = [];
  final _random = new Random();
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController.offset == 0) {
          print("bằng");
        }
        print("offset = ${_scrollController.offset}");
        if (_scrollController.offset ==
            _scrollController.position.maxScrollExtent) {
          print("max rồi");
          print(listFeedVision.length);
          print(listFeedAll.length);
          // if (listFeedAll.length > 5) {
          //   for (int i = 0; i < 5; i++) {
          //     FeedBaseModel f =
          //         listFeedAll[_random.nextInt(listFeedAll.length)];
          //     listFeedAll.remove(f);
          //     listFeedVision.add(f);
          //   }
          // } else {
          //   listFeedVision.addAll(listFeedAll);
          // // }
          setState(() {});
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final feedProvider = Provider.of<FeedProvider>(context, listen: false);

    Size size = MediaQuery.of(context).size;

    listUsers = userProvider.listFriendsP;
    listUsers[userProvider.userP.id] = userProvider.userP;
    return Consumer<FeedProvider>(builder: (context, feedProvider, child) {
      listFeedAll = [];
      if (feedProvider.listFeedsFrP.length > 0) {
        listFeedAll.addAll(feedProvider.listFeedsFrP);
      }
      if (feedProvider.listFeedsP.length > 0 &&
          feedProvider.listFeedsP.length < 3) {
        listFeedAll.addAll(feedProvider.listFeedsP);
      }

      if (feedProvider.listFeedsP.length >= 3) {
        listFeedAll.add(feedProvider.listFeedsP[0]);

        listFeedAll.add(feedProvider.listFeedsP[1]);

        listFeedAll.add(feedProvider.listFeedsP[2]);
      }

      listFeedAll.sort((a, b) => a.createdAt.compareTo(b.createdAt));

      if (listFeedVision.length > 0) {
        for (int i = 0; i < listFeedVision.length; i++) {
          listFeedAll.remove(listFeedVision[i]);
          listFeedAll.remove(listFeedVision[i]);
          print("giảm k");
          print(listFeedAll.length);
        }
      }
      print(listFeedVision.length);
      print(listFeedAll.length);
      if (listFeedAll.length > 6) {
        for (int i = 0; i < 5; i++) {
          print("length");
          print(listFeedAll.length);
          int num = 0;
          while (num == -1) {
            num = _random.nextInt(listFeedAll.length - 1);
          }
          FeedBaseModel f = listFeedAll[num];
          listFeedAll.remove(f);

          listFeedVision.add(f);
        }
      } else {
        listFeedVision.addAll(listFeedAll);
      }
      feedProvider.listFeedsVisionFrP = listFeedVision;
      return Container(
        padding: const EdgeInsets.all(8.0),
        height: size.height,
        child: ListView.builder(
            shrinkWrap: true,
            controller: _scrollController,
            itemCount: listFeedVision.length + 2,
            itemBuilder: (context, index) {
              if (index == 0) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Gốc gạo", style: AppStyles.h2),
                      Icon(Icons.message_sharp)
                    ],
                  ),
                );
              }
              if (index == 1) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 8, right: 8.0),
                        child: CircleAvatar(
                          backgroundColor: Colors.red,
                          radius: 23,
                          backgroundImage: AssetImage('assets/images/load.gif'),
                          child: CircleAvatar(
                            radius: 23,
                            backgroundImage: NetworkImage(SERVER_IP +
                                "/upload/" +
                                userProvider.userP.avatarImg[
                                    userProvider.userP.avatarImg.length - 1]),
                            backgroundColor: Colors.transparent,
                          ),
                        ),
                      ),
                      SizedBox(
                          width: size.width - 150,
                          child: InkWell(
                              child: Text("Bạn đang nghĩ gì"),
                              onTap: () {
                                print(listFeedAll.length);
                                Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (builder) =>
                                                PostFeedScreen()))
                                    .then((value) => setState(() {}));
                              }))
                    ],
                  ),
                );
              }
              if (listFeedVision.length != 0) {
                return index % 2 == 0
                    ? Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: CardFeedStyle(
                            feed: listFeedVision[index - 2],
                            ownFeedUser: listUsers[listFeedVision[index - 2]
                                        .sourceUserId] !=
                                    null
                                ? listUsers[
                                    listFeedVision[index - 2].sourceUserId]!
                                : userProvider.userP),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: CardFeedStyle(
                          feed: listFeedVision[index - 2],
                          ownFeedUser: listUsers[
                                      listFeedVision[index - 2].sourceUserId] !=
                                  null
                              ? listUsers[
                                  listFeedVision[index - 2].sourceUserId]!
                              : userProvider.userP,
                        ),
                      );
              } else {
                return Container(
                    height: 300,
                    color: Colors.amber,
                    child: Text("Chưa có bài viết nào"));
              }
            }),
      );
    });
  }
}
