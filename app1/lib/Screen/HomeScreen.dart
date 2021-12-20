import 'dart:convert';

import 'package:app1/feed/model/feed_model.dart';
import 'package:app1/feed/screen/post_feed.dart';
import 'package:app1/main.dart';
import 'package:app1/model/user_model.dart';
import 'package:app1/provider/feed_provider.dart';
import 'package:app1/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../ui.dart';
import '../widgets/card_feed.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<FeedBaseModel> listFeeds = [];
  Map<String, UserModel> listUsers = {};

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final feedProvider = Provider.of<FeedProvider>(context, listen: false);

    Size size = MediaQuery.of(context).size;
    ScrollController _scrollController = new ScrollController();
    List<FeedBaseModel> listFeedAll = [];
    listUsers = userProvider.listFriendsP;
    listUsers[userProvider.userP.id] = userProvider.userP;
    return Consumer<FeedProvider>(builder: (context, feedProvider, child) {
      if (feedProvider.listFeedsP.length > 0) {
        listFeedAll.addAll(feedProvider.listFeedsP);
      }
      if (feedProvider.listFeedsFrP.length > 0) {
        listFeedAll.addAll(feedProvider.listFeedsFrP);
      }
      listFeedAll.sort((a, b) => a.createdAt.compareTo(b.createdAt));
      return Container(
        padding: const EdgeInsets.all(8.0),
        height: size.height,
        child: ListView.builder(
            shrinkWrap: true,
            controller: _scrollController,
            itemCount: listFeedAll.length + 2,
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
                          radius: 24,
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
              if (listFeedAll.length != 0) {
                return index % 2 == 0
                    ? Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: CardFeedStyle(
                            feed: listFeedAll[index - 2],
                            ownFeedUser: listUsers[
                                        listFeedAll[index - 2].sourceUserId] !=
                                    null
                                ? listUsers[
                                    listFeedAll[index - 2].sourceUserId]!
                                : userProvider.userP),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: CardFeedStyle(
                          feed: listFeedAll[index - 2],
                          ownFeedUser: listUsers[
                                      listFeedAll[index - 2].sourceUserId] !=
                                  null
                              ? listUsers[listFeedAll[index - 2].sourceUserId]!
                              : UserModel(
                                  friend: [],
                                  hadMessageList: [],
                                  coverImg: [],
                                  friendConfirm: [],
                                  friendRequest: [],
                                  avatarImg: []),
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
