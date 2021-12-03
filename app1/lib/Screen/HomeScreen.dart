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
  Future fetchApiFeedInit(
      String sourceId, String jwt, String limit, String offset) async {
    try {
      http.Response response;
      List<FeedBaseModel> data1 = [];
      //tim tin nhan cua nguoi gui cho ban
      String query =
          '?limit=' + limit + '&offset=' + offset + '&sourceId=' + sourceId;
      String path = SERVER_IP + '/feed/limitFeedOwn' + query;
      print(query);
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
        return json.decode(response.body);
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  //lay tin nhan ban dau................
  getFeedInit(sourceId, jwt, List listFr) async {
    List<FeedBaseModel> listFeedsInit = [];
    List<Future> fetchAllFeedFr = [];
    for (var i = 0; i < listFr.length; i++) {
      fetchAllFeedFr.add(
        fetchApiFeedInit(listFr[i], jwt, 20.toString(), 0.toString()),
      );
    }
    List data = await Future.wait([
      fetchApiFeedInit(sourceId, jwt, 3.toString(), 0.toString()),
      ...fetchAllFeedFr
      //  fetchData(targetId, sourceId)
    ]);
    if (data[0] == "not jwt" || data[0] == "error") {
      return listFeedsInit;
    } else {
      print("data 0");
      print(data[0]);
      for (int k = 0; k <= listFr.length; k++) {
        if (data[k].length > 0) {
          for (int i = 0; i < data[k].length; i++) {
            if (data[k] != []) {
              FeedBaseModel a = FeedBaseModel(
                pathImg: data[k][i]["pathImg"],
                rule: data[k][i]["rule"],
                comment: data[k][i]["comment"],
                feedId: data[k][i]["_id"].toString(),
                message: data[k][i]["messages"],
                like: data[k][i]["like"],
                sourceUserId: data[k][i]["sourceUserId"].toString(),
                createdAt: data[k][i]["createdAt"],
                sourceUserName: data[k][i]["sourceUserName"].toString(),
              );
              listFeedsInit.add(a);
            }
          }
        }
      }

      listFeedsInit.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return listFeedsInit;
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final feedProvider = Provider.of<FeedProvider>(context, listen: false);

      List<FeedBaseModel> listFeedsInit = await getFeedInit(
          userProvider.userP.id, userProvider.jwtP, userProvider.userP.friend);
      List<FeedBaseModel> newListFeedOwnInit = [];
      List<FeedBaseModel> newListFeedFrInit = [];

      for (int i = 0; i < listFeedsInit.length; i++) {
        if (listFeedsInit[i].sourceUserId == userProvider.userP.id) {
          newListFeedOwnInit.add(listFeedsInit[i]);
        } else {
          newListFeedFrInit.add(listFeedsInit[i]);
        }
      }
      feedProvider.userFeed(newListFeedOwnInit);
      feedProvider.userFrFeed(newListFeedFrInit);

      if (mounted) {
        setState(() {});
      }
    });
    // if (widget.newFeed!.sourceUserName != "") {
    //   widget.listFeeds.add(widget.newFeed!);
    //   if (mounted) {
    //     setState(() {});
    //   }
    // }
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
                                : UserModel(
                                    friend: [],
                                    hadMessageList: [],
                                    coverImg: [],
                                    friendConfirm: [],
                                    friendRequest: [],
                                    avatarImg: []),
                            userOwnUse: userProvider.userP),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: CardFeedStyle(
                            feed: listFeedAll[index - 2],
                            ownFeedUser: listUsers[
                                        listFeedAll[index - 2].sourceUserId] !=
                                    null
                                ? listUsers[
                                    listFeedAll[index - 2].sourceUserId]!
                                : UserModel(
                                    friend: [],
                                    hadMessageList: [],
                                    coverImg: [],
                                    friendConfirm: [],
                                    friendRequest: [],
                                    avatarImg: []),
                            userOwnUse: userProvider.userP),
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
