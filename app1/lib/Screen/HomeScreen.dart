import 'dart:convert';

import 'package:app1/feed/model/feed_model.dart';
import 'package:app1/feed/screen/post_feed.dart';
import 'package:app1/main.dart';
import 'package:app1/model/user_model.dart';
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
  Future fetchApiFeedInit(String sourceId, String jwt) async {
    try {
      http.Response response;
      List<FeedBaseModel> data1 = [];
      //tim tin nhan cua nguoi gui cho ban
      String query = '?limit=15&offset=0&sourceId=' + sourceId;
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

      return json.decode(response.body);
    } catch (e) {
      return [];
    }
  }

  //lay tin nhan ban dau................
  getFeedInit(sourceId, jwt) async {
    List<FeedBaseModel> listFeedsInit = [];

    List data = await Future.wait([
      fetchApiFeedInit(sourceId, jwt),
      //  fetchData(targetId, sourceId)
    ]);
    if (data[0] == "not jwt") {
      return listFeedsInit;
    } else {
      print(data[0]);

      for (int i = 0; i < data[0].length; i++) {
        FeedBaseModel a = FeedBaseModel(
          feedId: data[0][i]["_id"].toString(),
          message: data[0][i]["messages"],
          like: data[0][i]["like"],
          sourceUserId: data[0][i]["sourceId"].toString(),
          createdAt: data[0][i]["createdAt"],
          sourceUserName: data[0][i]["sourceUserName"].toString(),
        );
        listFeedsInit.add(a);
        // messages.add(a);
        // }
        // for (i = 0; i < data[1].length; i++) {
        //   MessageModel a = MessageModel(
        //     type: "",
        //     message: data[1][i]["message"],
        //     path: data[1][i]["path"],
        //     sourceId: data[1][i]["sourceId"].toString(),
        //     targetId: data[1][i]["targetId"].toString(),
        //     time: data[1][i]["time"],
        //   );

        //   messages.add(a);
        // }
        // messages.sort((a, b) => a.time.compareTo(b.time));
        // print("get init message done .....................");
        // if (mounted) setState(() {});
      }
      return listFeedsInit;
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      List<FeedBaseModel> listFeedsInit =
          await getFeedInit(userProvider.userP.id, userProvider.jwtP);

      userProvider.userFeed(listFeedsInit);
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
    Size size = MediaQuery.of(context).size;
    ScrollController _scrollController = new ScrollController();
    return Container(
      padding: const EdgeInsets.all(8.0),
      height: size.height,
      child: ListView.builder(
          shrinkWrap: true,
          controller: _scrollController,
          itemCount: userProvider.listFeedsP.length + 2,
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
            return index % 2 == 0
                ? Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: CardFeedStyle(
                        feed: userProvider.listFeedsP[index - 2],
                        userOwnUse: userProvider.userP),
                  )
                : Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: CardFeedStyle(
                        feed: userProvider.listFeedsP[index - 2],
                        userOwnUse: userProvider.userP),
                  );
          }),
    );
  }
}
