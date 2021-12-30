import 'dart:convert';

import 'package:app1/user/screen/All_Fr_Screen.dart';
import 'package:app1/chat-app/model/chat_modal.dart';
import 'package:app1/chat-app/screens_chat/individual_chat.dart';
import 'package:app1/feed/model/feed_model.dart';
import 'package:app1/main.dart';
import 'package:app1/model/user_model.dart';
import 'package:app1/provider/feed_provider.dart';
import 'package:app1/provider/notifi_provider.dart';
import 'package:app1/provider/user_provider.dart';
import 'package:app1/ui.dart';
import 'package:app1/widgets/app_button.dart';
import 'package:app1/feed/widget/card_feed.dart';
import 'package:app1/user/screen/friend_avatar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class FriendProfile extends StatefulWidget {
  const FriendProfile({Key? key, required this.frId}) : super(key: key);
  final String frId;

  @override
  _FriendProfileState createState() => _FriendProfileState();
}

class _FriendProfileState extends State<FriendProfile> {
  UserModel inforFr = UserModel(
      friend: [],
      friendConfirm: [],
      feedImg: [],
      feedVideo: [],
      friendRequest: [],
      coverImg: [],
      avatarImg: [],
      hadMessageList: []);
  List<FeedBaseModel> listFeedsInit = [];
  ScrollController _scrollController = new ScrollController();
  Map<String, UserModel> frOfFr = {};
  String isFr = "Kết bạn";
  bool isTontai = true;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final feedProvider = Provider.of<FeedProvider>(context, listen: false);
      String query = '?limit=15&offset=0&sourceId=' + widget.frId;
      String path = '/feed/limitFeedOwn' + query;
      var result = await Future.wait([
        getApi(userProvider.jwtP, path),
        getApi(userProvider.jwtP, "/user/" + widget.frId)
      ]);
      listFeedsInit = getFeedInit(result[0]);
      inforFr = getInforFr(result[1]);

      if (inforFr.userName != "") {
        frOfFr = await getFriendUser(userProvider.jwtP,
            "/user/allAvatarFr/" + inforFr.id, inforFr.friend);
        if (mounted) {
          bool isHadFeed;
          userProvider.inforFrP = inforFr;
          // for(var i=0;i<=listFeedsInit.length;i++) {
          //   for(var i=0;i<=feedProvider.listFeedsFrP.length;i++) {

          //     if(feedProvider.listFeedsFrP[i]!=null){
          //       if(feedProvider.listFeedsFrP[i].feedId==listFeedsInit[i].feedId){
          //         bool
          //       }
          //     }
          //   }
          // }
          // feedProvider.listFeedsFrP= listFeedsInit;
          setState(() {});
        }
      } else {
        isTontai = false;
        if (mounted) {
          setState(() {});
        }
      }
    });
    _scrollController = ScrollController()
      ..addListener(() async {
        final userProvider = Provider.of<UserProvider>(context, listen: false);

        if (_scrollController.offset ==
            _scrollController.position.maxScrollExtent) {
          print("cuối cùng");
          print(listFeedsInit.length);
          List<FeedBaseModel> listFeedsNew = [];
          String query = '?limit=15&offset=' +
              (listFeedsInit.length).toString() +
              '&sourceId=' +
              widget.frId;
          String path = '/feed/limitFeedOwn' + query;
          var result = await Future.wait([
            getApi(userProvider.jwtP, path),
          ]);
          listFeedsNew = getFeedInit(result[0]);
          listFeedsInit.addAll(listFeedsNew);
          if (listFeedsNew.length > 0) {
            if (mounted) {
              setState(() {});
            }
          }

          print("kết quả khi thêm là ");
          print(listFeedsNew);
        }
        print("offset = ${_scrollController.offset}");
      });
  }

//------------------------get feed init--------------------
  getFeedInit(data) {
    print("------------------getFeedInit--------------");
    List<FeedBaseModel> listFeedsInit = [];

    print("data là");
    print(data);
    if (data == "not jwt" || data == "error") {
      return listFeedsInit;
    } else {
      for (var i = 0; i < data.length; i++) {
        if (data != []) {
          FeedBaseModel a = FeedBaseModel(
            feedId: data[i]["_id"].toString(),
            message: data[i]["messages"],
            like: data[i]["like"],
            comment: data[i]["comment"],
            pathVideo: data[i]["pathVideo"],
            tag: data[i]["tag"],
            pathImg: data[i]["pathImg"],
            rule: data[i]["rule"],
            sourceUserId: data[i]["sourceId"].toString(),
            createdAt: data[i]["createdAt"],
            sourceUserName: data[i]["sourceUserName"].toString(),
          );
          listFeedsInit.add(a);
        }
      }
      return listFeedsInit;
    }
  }

//----------------------------get friend của fr------------------
  Future<Map<String, UserModel>> getFriendUser(
      String jwt, String path, List listFr) async {
    print("--list fr la");
    print(listFr);
    Map<String, UserModel> chatFriend = {};

    print("------chạy get avatar---------");
    var result = await getApi(jwt, path);
    print("ket qua la :");
    print(result);
    if (result != "error" && result != "not jwt") {
      for (var i = 0; i < listFr.length; i++) {
        chatFriend[listFr[i]] = UserModel(
            friend: [],
            friendConfirm: [],
            friendRequest: [],
            feedImg: [],
            feedVideo: [],
            coverImg: [],
            hadMessageList: [],
            id: result[listFr[i]][2],
            avatarImg: [result[listFr[i]][0]],
            realName: result[listFr[i]][1]);
      }
    }
    return chatFriend;
  }

//------------------get infor cua ownFr------------
  getInforFr(data) {
    print("kết quả của get info Fr");
    print(data);
    if (data != "not jwt" && data != "error") {
      if (data["userName"] != null) {
        UserModel user = UserModel(
            friendRequest: data["friendRequest"],
            friendConfirm: data["friendConfirm"],
            userName: data["userName"],
            realName: data["realName"],
            email: data["email"],
            id: data["_id"],
            feedImg: data["feedImg"],
            feedVideo: data["feedVideo"],
            friend: data["friend"],
            hadMessageList: data["hadMessageList"],
            avatarImg: data["avatarImg"] != null
                ? data["avatarImg"]
                : ["avatarNull.jpg"],
            coverImg: data["coverImg"]);
        return user;
      } else {
        return UserModel(
            friend: [],
            friendConfirm: [],
            friendRequest: [],
            feedImg: [],
            feedVideo: [],
            coverImg: [],
            avatarImg: [],
            hadMessageList: []);
      }
    } else {
      return UserModel(
          friend: [],
          friendConfirm: [],
          friendRequest: [],
          feedImg: [],
          feedVideo: [],
          coverImg: [],
          avatarImg: [],
          hadMessageList: []);
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final feedProvider = Provider.of<FeedProvider>(context, listen: false);

    Future<String> addFr(String isFrTextModal, String jwt, String id) async {
      if (isFrTextModal == "Hủy kết bạn") {
        print("huy ket bạn");
        var result = await PostApi(
            jwt,
            {"createdAt": DateTime.now().toString()},
            "/user/removeFriend/" + id);
        if (result != "not jwt" &&
            result != "error" &&
            result != "not friend") {
          userProvider.listFriendsP.remove(widget.frId);
          userProvider.userP.friend.remove(widget.frId);
          return "Kết bạn";
        } else {
          print(result);
        }
      }
      if (isFrTextModal == "Gửi yêu cầu kết bạn") {
        print("ket bạn");
        var result = await PostApi(
            jwt, {"createdAt": DateTime.now().toString()}, "/user/addfr/" + id);
        if (result != "not jwt" &&
            result != "error" &&
            result != "had friendConfirm" &&
            result != "had friendRequest" &&
            result != "had friend") {
          userProvider.userP.friendRequest.add(widget.frId);
          return "Đã gửi lời mời";
        } else {
          print(result);
        }
      }
      if (isFrTextModal == "Đồng ý kết bạn") {
        print("ket bạn");
        var result = await PostApi(
            jwt,
            {"createdAt": DateTime.now().toString()},
            "/user/addfrConfirm/" + id);
        if (result != "not jwt" &&
            result != "error" &&
            result != "had not request" &&
            result != "had not confirm" &&
            result != "had friend") {
          userProvider.userP.friend.add(widget.frId);
          userProvider.userP.friendConfirm.remove(widget.frId);
          userProvider.listFriendsP[widget.frId] = UserModel(
              friend: [],
              friendConfirm: [],
              friendRequest: [],
              feedImg: [],
              feedVideo: [],
              coverImg: [],
              hadMessageList: [],
              id: result["_id"].toString(),
              avatarImg: result["avatarImg"],
              realName: result["realName"]);
          print("----đã kết bạn--");
          return "Bạn bè";
        }
      }
      if (isFrTextModal == "Hủy lời mời") {
        print("hủy ket bạn");
        var result = await PostApi(
            jwt,
            {"createdAt": DateTime.now().toString()},
            "/user/removeFrRequest/" + id);
        if (result != "not jwt" &&
            result != "error" &&
            result != "had not confirm" &&
            result != "had not request") {
          if (mounted) {
            userProvider.userP.friendRequest.remove(widget.frId);
            return "Kết bạn";
          }
        } else {
          print(result);
        }
      }

      if (isFrTextModal == "Xóa lời mời") {
        print("ket bạn");
        var result = await PostApi(
            jwt,
            {"createdAt": DateTime.now().toString()},
            "/user/removeFrConfirm/" + id);
        if (result != "not jwt" &&
            result != "error" &&
            result != "had not confirm" &&
            result != "had not request") {
          if (mounted) {
            userProvider.userP.friendConfirm.remove(widget.frId);
            return "Kết bạn";
          }
        } else {
          print(result);
        }
      }

      return "error";
    }

    Widget modalChild(String isFr, String? textIsFr) {
      String text = "";
      if (isFr == "Bạn bè") {
        text = "Hủy kết bạn";
      }
      if (isFr == "Kết bạn") {
        text = "Gửi yêu cầu kết bạn";
      }
      if (isFr == "Chấp nhận lời mời") {
        text = "Đồng ý kết bạn";
      }
      if (isFr == "Xóa lời mời") {
        text = "Xóa lời mời";
      }
      if (isFr == "Đã gửi lời mời") {
        text = "Hủy lời mời";
      }
      if (textIsFr == "Xóa lời mời") {
        text = "Xóa lời mời";
      }

      return Container(
        width: 250,
        height: 35,
        child: Material(
          color: Color.fromRGBO(80, 0, 80, 0.2),
          child: InkWell(
              onTap: () async {
                print(isFr);
                print(text);
                String a = await addFr(text, userProvider.jwtP, widget.frId);
                print(a);
                if (a != "not jwt" && a != "error") {
                  setState(() {});
                  Navigator.pop(
                    context,
                    isFr = a,
                  );
                } else {
                  print("--addFr có lỗi");
                }
              },
              hoverColor: Colors.amber,
              child: Text(text,
                  style: TextStyle(fontSize: 24), textAlign: TextAlign.center)),
        ),
      );
    }

    Size size = MediaQuery.of(context).size;

    List<Widget> frGirdView(Map<String, UserModel> inforFr, List listFr) {
      List<Widget> list = [];
      if (listFr.length == 0 || listFr == null) {
      } else {
        int pop = inforFr.length < 6 ? listFr.length : 6;
        for (var i = 0; i < pop; i++) {
          if (frOfFr.length == 0 || frOfFr[listFr[i]] == null) {
          } else {
            list.add(AvatarFriendBtn(
              id: frOfFr[listFr[i]]!.id,
              frName: frOfFr[listFr[i]]!.realName,
              frImage: frOfFr[listFr[i]]!.avatarImg[0],
            ));
          }
        }
      }

      return list;
    }

    getIsFr(userProvider) {
      if (userProvider.userP.friend != null &&
          userProvider.userP.friend.contains(widget.frId)) {
        return "Bạn bè";
      }

      if (userProvider.userP.friendConfirm != null &&
          userProvider.userP.friendConfirm.contains(widget.frId)) {
        return "Chấp nhận lời mời";
      }
      if (userProvider.userP.friendRequest != null &&
          userProvider.userP.friendRequest.contains(widget.frId)) {
        return "Đã gửi lời mời";
      }
      return "Kết bạn";
    }

    return Scaffold(
        body: Padding(
            padding: const EdgeInsets.all(4.0),
            child: ListView.builder(
                shrinkWrap: true,
                controller: _scrollController,
                itemCount: listFeedsInit.length + 3,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Container(
                      height: size.height / 3,
                      child: Stack(
                        children: [
                          Container(
                            height: size.height / 9 * 2,
                            width: size.width,
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(20.0),
                                  topLeft: Radius.circular(20)),
                            ),
                            child: userProvider.inforFrP.coverImg != null &&
                                    userProvider.inforFrP.coverImg.length > 0
                                ? CachedNetworkImage(
                                    imageUrl: SERVER_IP +
                                        "/upload/" +
                                        userProvider.inforFrP.coverImg[
                                            userProvider
                                                    .inforFrP.coverImg.length -
                                                1],
                                    fit: BoxFit.fitWidth,
                                    placeholder: (context, url) =>
                                        CircularProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                  )
                                : Image.asset(
                                    "assets/images/nature.jpg",
                                    fit: BoxFit.cover,
                                  ),
                          ),
                          Positioned(
                              left:
                                  ((size.width - 16) - (size.height - 16) / 6) /
                                          2 -
                                      4,
                              right: null,
                              top: size.height / 36 * 5,
                              child: CircleAvatar(
                                radius: 78,
                                backgroundImage:
                                    AssetImage('assets/images/load.gif'),
                                child: CircleAvatar(
                                  radius: 75,
                                  backgroundImage: userProvider
                                                  .inforFrP.avatarImg !=
                                              null &&
                                          userProvider
                                                  .inforFrP.avatarImg.length >
                                              0
                                      ? NetworkImage(SERVER_IP +
                                          "/upload/" +
                                          userProvider.inforFrP.avatarImg[
                                              userProvider.inforFrP.avatarImg
                                                      .length -
                                                  1])
                                      : NetworkImage(
                                          SERVER_IP + "/upload/avatarNull.jpg"),
                                  backgroundColor: Colors.transparent,
                                ),
                              )),
                          //------camera bia--------------------------
                        ],
                      ),
                    );
                  }
                  if (isTontai) {
                    if (index == 1) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 32.0),
                        child: Center(
                          child: Text(inforFr.userName, style: AppStyles.h2),
                        ),
                      );
                    }
                    if (index == 2) {
                      return Column(
                        children: [
                          Row(
                            children: [
                              Icon(Icons.lock_clock),
                              Text("   Bắt đầu từ 9/2021", style: AppStyles.h4),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.badge),
                              Text("   Học tại đh Công Nghệ",
                                  style: AppStyles.h4),
                            ],
                          ),
                          TextButton.icon(
                              onPressed: () {},
                              icon: Icon(Icons.wysiwyg),
                              label: Text("   Xem chi tiết")),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              AppBTnStyle(
                                  label: "Nhắn tin",
                                  onTap: inforFr.id == ""
                                      ? null
                                      : () {
                                          print("nhắn tin");
                                          ChatModel chatModel = ChatModel(
                                            id: widget.frId,
                                            realName: inforFr.realName,
                                            avatar: inforFr.avatarImg[
                                                inforFr.avatarImg.length - 1],
                                          );
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (builder) =>
                                                      IndividualChat(
                                                        chatModel: chatModel,
                                                        sourceChat: ChatModel(
                                                            id: userProvider
                                                                .userP.id,
                                                            avatar: userProvider
                                                                    .userP
                                                                    .avatarImg[
                                                                userProvider
                                                                        .userP
                                                                        .avatarImg
                                                                        .length -
                                                                    1]),
                                                      )));
                                        }),
                              Consumer<UserProvider>(
                                  builder: (context, userProvider, child) {
                                return AppBTnStyle(
                                    label: getIsFr(userProvider),
                                    onTap: () async {
                                      print(
                                          "--- ấn vào nút bạn bè------------");
                                      await showModalBottomSheet<String>(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return Container(
                                            height: 200,
                                            child: Center(
                                              child: Column(
                                                // crossAxisAlignment:
                                                //     CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  SizedBox(),
                                                  modalChild(
                                                      getIsFr(userProvider),
                                                      ""),
                                                  isFr == "Chấp nhận lời mời"
                                                      ? modalChild(
                                                          getIsFr(userProvider),
                                                          "Xóa lời mời")
                                                      : Container(),
                                                  SizedBox(),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    });
                              }),
                            ],
                          ),
                          Divider(height: 60, color: Colors.black),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(children: [
                                Text("Bạn bè", style: AppStyles.h4),
                                Text(frOfFr.length.toString(),
                                    style: AppStyles.h4)
                              ]),
                              Icon(Icons.search)
                            ],
                          ),
                          userProvider.inforFrP.friend.length > 0
                              ? Material(
                                  child: GridView.count(
                                      crossAxisCount: 3,
                                      crossAxisSpacing: 4,
                                      mainAxisSpacing: 4,
                                      childAspectRatio: 4 / 5,
                                      physics:
                                          NeverScrollableScrollPhysics(), // to disable GridView's scrolling
                                      shrinkWrap:
                                          true, // You won't see infinite size error
                                      children: frGirdView(
                                          frOfFr,
                                          userProvider.inforFrP.friend != null
                                              ? userProvider.inforFrP.friend
                                              : [])),
                                )
                              : Container(),
                          userProvider.inforFrP.friend.length > 0
                              ? AppBTnStyle(
                                  label: "Xem tất cả bạn bè",
                                  onTap: () {
                                    print(isFr);
                                    print(userProvider.userP.friend);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (builder) =>
                                                AllFriendScreen(
                                                    tag: true, user: inforFr)));
                                  })
                              : Container(),
                          Divider(
                            height: 60,
                            color: Colors.black,
                          ),
                        ],
                      );
                    }
                    if (listFeedsInit.length > 0) {
                      return CardFeedStyle(
                        feed: listFeedsInit[index - 3],
                        ownFeedUser: inforFr,
                      );
                    } else {
                      return SizedBox(
                          height: 300, child: Text("chưa có bài viết nào"));
                    }
                  } else {
                    if (index == 2) {
                      return Expanded(
                          child:
                              Center(child: Text("tài khoản không tồn tại")));
                    }
                    return Container();
                  }
                })));
  }
}

Future<dynamic> getApi(String jwt, String pathApi) async {
  print("--------get Api---------" + pathApi);
  print(jwt);
  var res = await http.get(
    Uri.parse(SERVER_IP + pathApi),
    headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'cookie': "jwt=" + jwt,
    },
  );
  if (res.statusCode == 200 || res.statusCode == 201) {
    var data = json.decode(res.body);
    print("result " + pathApi);
    print(data);
    return data;
  } else {
    return "error";
  }
}

Future PostApi(String jwt, data, String pathApi) async {
  http.Response response;
  print("----post---------" + pathApi);
  response = await http.post(Uri.parse(SERVER_IP + pathApi),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'cookie': "jwt=" + jwt
      },
      body: jsonEncode(data));

  if (response.statusCode == 200 || response.statusCode == 201) {
    print("-----kêt quả post--------");
    print(json.decode(response.body).toString());
    return json.decode(response.body);
  } else {
    print("---------------post lỗi---------");
    return "error";
  }
}
