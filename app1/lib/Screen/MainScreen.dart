import 'dart:convert';

import 'package:app1/Screen/Notifications.dart';
import 'package:app1/Screen/SearchScreen.dart';
import 'package:app1/chat-app/model/chat_modal.dart';
import 'package:app1/chat-app/model/message_model.dart';
import 'package:app1/chat-app/screens_chat/LoginScreen.dart';
import 'package:app1/feed/model/comment_model.dart';
import 'package:app1/feed/model/feed_model.dart';
import 'package:app1/main.dart';
import 'package:app1/model/notifi_modal.dart';
import 'package:app1/model/user_model.dart';
import 'package:app1/provider/comment_provider.dart';
import 'package:app1/provider/feed_provider.dart';
import 'package:app1/provider/message_provider.dart';
import 'package:app1/provider/notifi_provider.dart';
import 'package:app1/provider/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart';
import '../user/screen/Profile.dart';
import './HomeScreen.dart';
import 'package:http/http.dart' as http;

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key, required this.UserId}) : super(key: key);
  final String UserId;
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  int _numberNotifications = 0;
  bool isSigninSocket = true;
  late Socket socket;
  //----------connetc socket--------------------------------------------
  void connect(String id) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final commentProvider =
        Provider.of<CommentProvider>(context, listen: false);

    print("begin connect....................");
    socket = io(SERVER_IP, <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false,
    });
    socket.connect();
    print(socket.connected);
    socket.emit("signin", id);
    socket.onConnect((data) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);

      final messageProvider =
          Provider.of<MessageProvider>(context, listen: false);
      final notifiProvider =
          Provider.of<NotifiProvider>(context, listen: false);
      socket.on("newFeed", (feed) {
        if (mounted) {
          print("---chạy setstate- số thông báo--");

          _numberNotifications = _numberNotifications + 1;

          print(feed);
          print(feed["feedId"]);
          setListFeedP(feed);
        }
      });
      socket.on("comment", (comment) {
        print("---chạy setstate- số thông báo--");

        _numberNotifications = _numberNotifications + 1;
        print(comment);
        Map<String, List<CommentFullModel>> listCommenPInit = {};
        CommentFullModel cmtNew = CommentFullModel(
          comment: CommentBaseModel(
            pathImg: comment["pathImg"],
            messages: comment["messages"],
            createdAt: comment["createdAt"],
            sourceUserId: comment["id"],
          ),
          avatarImg: comment["avatar"],
          realName: comment["realName"],
        );
        if (commentProvider.listCommentP[comment["feedId"]] == null &&
            commentProvider.feedId == comment["feedId"]) {
          listCommenPInit[comment["feedId"]] = [cmtNew];
          commentProvider.userComment(listCommenPInit);
        }
        if (commentProvider.listCommentP[comment["feedId"]] != null &&
            commentProvider.feedId == comment["feedId"]) {
          listCommenPInit = commentProvider.listCommentP;
          listCommenPInit[comment["feedId"]]!.add(cmtNew);
          commentProvider.userComment(listCommenPInit);
        }
      });
      socket.on("newTag", (feed) {
        if (mounted) {
          print("---chạy setstate- số thông báo--");

          _numberNotifications = _numberNotifications + 1;
          setNewTag(feed);
        }
      });

      socket.on("message", (msg) async {
        if (userProvider.userP.hadMessageList.indexOf(msg["sourceId"]) < 0) {
          userProvider.userP.hadMessageList.add(msg["sourceId"]);
          messageProvider.listMessageP;
          var result =
              await getApi(userProvider.jwtP, "/user/" + msg["sourceId"]);
          if (result != "not jwt" && result != "error") {
            userProvider.listHadChatP[msg["sourceId"]] = UserModel(
                friend: [],
                hadMessageList: [],
                coverImg: [],
                friendConfirm: [],
                friendRequest: [],
                realName: result["realName"],
                id: result["_id"],
                avatarImg: result["avatarImg"]);
          }
          messageProvider
              .listMessageP[msg["targetId"] + "/" + msg["sourceId"]] = [];
        }
        print("message");
        print(msg);
        if (mounted) {
          setState(() {
            setListMessageP(msg);
            _numberNotifications = _numberNotifications + 1;
          });
        }
      });
      socket.on("likeFeed", (msg) {
        NotifiModel not = NotifiModel(
            targetIdUser: [],
            sourceIdUser: msg["idUserLiked"],
            sourceRealnameUser: msg["realNameLiked"],
            sourceUserPathImg: msg["avatarLiked"],
            type: msg["type"],
            isSeen: false,
            createdAt: msg["createdAt"],
            content: msg["feedId"]);
        List<NotifiModel> notifiInit = notifiProvider.listNotifiP;
        for (int i = 0; i < notifiInit.length; i++) {
          if (notifiInit[i].sourceIdUser == not.sourceIdUser &&
              notifiInit[i].content == not.content) {
            notifiInit.removeAt(i);
            i--;
          }
        }
        notifiInit.insert(0, not);

        notifiProvider.userNotifi(notifiInit);
        if (mounted) {
          setState(() {
            _numberNotifications = _numberNotifications + 1;
          });
        }
      });
      socket.on("handleFr", (data) async {
        print(data);
        print(data["type"]);
        print("type là là là");
        if (data["type"] == "removeFrRequest") {
          userProvider.userP.friendConfirm.remove(data["sourceUserId"]);
        }
        if (data["type"] == "removeFrConfirm") {
          userProvider.userP.friendRequest.remove(data["sourceUserId"]);

          if (mounted) {
            setState(() {});
          }
        }

        if (data["type"] == "removeFriend") {
          userProvider.userP.friend.remove(data["sourceUserId"]);
          userProvider.listFriendsP.remove(data["sourceUserId"]);

          if (mounted) {
            setState(() {});
          }
        }
        if (data["type"] == "confirmFr") {
          List<NotifiModel> notifiInit = [];
          userProvider.userP.friend.add(data["sourceUserId"]);
          userProvider.userP.friendRequest.remove(data["sourceUserId"]);
          notifiInit = notifiProvider.listNotifiP;
          var result =
              await getApi(userProvider.jwtP, "/user/" + data["sourceUserId"]);
          print("kết quả result là");
          print(result);
          if (result != "not jwt" && result != "error") {
            userProvider.listFriendsP[data["sourceUserId"]] = UserModel(
                friend: [],
                hadMessageList: [],
                coverImg: [],
                friendConfirm: [],
                friendRequest: [],
                avatarImg: result["avatarImg"],
                id: data["sourceUserId"],
                realName: result["realName"]);
            notifiInit.insert(
                0,
                NotifiModel(
                  type: data["type"],
                  createdAt: data["createdAt"],
                  isSeen: false,
                  content: data["content"] == null ? "" : data["content"],
                  sourceRealnameUser: result["realName"],
                  sourceUserPathImg: result["avatarImg"]
                      [result["avatarImg"].length - 1],
                  sourceIdUser: data["sourceUserId"],
                  targetIdUser: data["targetUserId"],
                ));

            notifiProvider.userNotifi(notifiInit);
            if (mounted) {
              setState(() {
                _numberNotifications = _numberNotifications + 1;
              });
            }
          }
        }
        if (data["type"] == "addFr") {
          List<NotifiModel> notifiInit = [];
          userProvider.userP.friendConfirm.add(data["sourceUserId"]);
          notifiInit = notifiProvider.listNotifiP;
          var result =
              await getApi(userProvider.jwtP, "/user/" + data["sourceUserId"]);
          print("kết quả result là");
          print(result);
          if (result != "error" && result != "not jwt") {
            notifiInit.insert(
                0,
                NotifiModel(
                  type: data["type"],
                  createdAt: data["createdAt"],
                  isSeen: false,
                  content: data["content"] == null ? "" : data["content"],
                  sourceRealnameUser: result["realName"],
                  sourceUserPathImg: result["avatarImg"]
                      [result["avatarImg"].length - 1],
                  sourceIdUser: data["sourceUserId"],
                  targetIdUser: data["targetUserId"],
                ));

            notifiProvider.userNotifi(notifiInit);
            if (mounted) {
              setState(() {
                _numberNotifications = _numberNotifications + 1;
              });
            }
          }
        }
      });
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      if (index == 4) {
        _numberNotifications = 0;
      }
      ;
      _selectedIndex = index;
    });
  }

  setListMessageP(msg) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final notifiProvider = Provider.of<NotifiProvider>(context, listen: false);

    final messageProvider =
        Provider.of<MessageProvider>(context, listen: false);
    if (messageProvider
            .listMessageP[userProvider.userP.id + "/" + msg["sourceId"]] !=
        null) {
      Map<String, List<MessageModel>> messagesI = {};
      print("---đã nhắn tin rồi-----");
      messageProvider
          .listMessageP[userProvider.userP.id + "/" + msg["sourceId"]]!
          .add(MessageModel(
              path: msg["path"],
              time: msg["time"],
              message: msg["message"],
              targetId: msg["targetId"],
              sourceId: msg["sourceId"]));
      messagesI = messageProvider.listMessageP;
      NotifiModel not = NotifiModel(
        type: "newMsg",
        sourceIdUser: msg["sourceId"],
        targetIdUser: [msg["targetId"]],
        content: msg["sourceId"],
        createdAt: msg["time"],
      );

      List<NotifiModel> notifiInit = notifiProvider.listNotifiP;

      for (int i = 0; i < notifiInit.length; i++) {
        if (notifiInit[i].type == "newMsg" &&
            notifiInit[i].sourceIdUser == msg["sourceId"]) {
          notifiInit.removeAt(i);
          i--;
        }
      }

      notifiInit.insert(0, not);

      notifiProvider.userNotifi(notifiInit);
      messageProvider.userMessage(messagesI);
    } else {
      Map<String, List<MessageModel>> messagesI = {};

      List<MessageModel> output = [];
      print("---chưa nhắn tin ----");

      output.add(MessageModel(
          path: msg["path"],
          time: msg["time"],
          message: msg["message"],
          targetId: msg["targetId"],
          sourceId: msg["sourceId"]));

      messageProvider
              .listMessageP[userProvider.userP.id + "/" + msg["sourceId"]] ==
          output;
      messagesI = messageProvider.listMessageP;
      NotifiModel not = NotifiModel(
        type: "newMsg",
        sourceIdUser: msg["sourceId"],
        targetIdUser: [msg["targetId"]],
        content: msg["sourceId"],
        createdAt: msg["time"],
      );

      List<NotifiModel> notifiInit = notifiProvider.listNotifiP;

      for (int i = 0; i < notifiInit.length; i++) {
        if (notifiInit[i].type == "newMsg" &&
            notifiInit[i].sourceIdUser == msg["sourceId"]) {
          notifiInit.removeAt(i);
          i--;
        }
      }

      notifiInit.insert(0, not);

      notifiProvider.userNotifi(notifiInit);
      messageProvider.userMessage(messagesI);
    }
    if (mounted) {
      setState(() {});
    }
  }

  setListFeedP(feed) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final feedProvider = Provider.of<FeedProvider>(context, listen: false);
    final notifiProvider = Provider.of<NotifiProvider>(context, listen: false);

    List<FeedBaseModel> newFeeds = [];
    if (feed["sourceUserId"] == userProvider.userP.id) {
      newFeeds = feedProvider.listFeedsP;
      FeedBaseModel newFeed = FeedBaseModel(
          feedId: feed["feedId"],
          pathImg: feed['pathImg'],
          pathVideo: feed['pathVideo'],
          message: feed['messages'],
          comment: feed['comment'],
          rule: feed['rule'],
          tag: feed["tag"],
          like: feed['like']);
      print(newFeed);
      // newFeeds.add(newFeed);
      // feedProvider.userFeed(newFeeds);

    } else {
      print("-- bạn đã đăng feed");
      print(feed["messages"]);
      print(feed["sourceUserId"]);
      FeedBaseModel newFeed = FeedBaseModel(
        pathImg: feed["pathImg"],
        rule: feed["rule"],
        comment: feed["comment"],
        feedId: feed["feedId"].toString(),
        message: feed["messages"],
        pathVideo: feed['pathVideo'],
        tag: feed["tag"],
        like: feed["like"],
        sourceUserId: feed["sourceUserId"].toString(),
        createdAt: feed["createdAt"],
        sourceUserName: feed["sourceUserName"].toString(),
      );

      newFeeds = feedProvider.listFeedsFrP;
      newFeeds.add(newFeed);
      feedProvider.userFrFeed(newFeeds);

      NotifiModel not = NotifiModel(
          type: "newFeed",
          sourceIdUser: feed["sourceUserId"].toString(),
          targetIdUser: feed["tag"],
          createdAt: feed["createdAt"],
          content: feed["feedId"],
          isSeen: false,
          sourceRealnameUser: feed["sourceRealnameUser"],
          sourceUserPathImg: feed["sourceUserPathImg"]
              [feed["sourceUserPathImg"].length - 1]);
      List<NotifiModel> notifiInit = notifiProvider.listNotifiP;
      notifiInit.insert(0, not);
      notifiProvider.userNotifi(notifiInit);
    }

    if (mounted) {
      setState(() {});
    }
  }

  //
  setNewTag(feed) {
    final notifiProvider = Provider.of<NotifiProvider>(context, listen: false);

    NotifiModel not = NotifiModel(
        type: "newTag",
        sourceIdUser: feed["sourceUserId"].toString(),
        targetIdUser: feed["tag"],
        createdAt: feed["createdAt"],
        content: "",
        isSeen: false,
        sourceRealnameUser: feed["sourceRealnameUser"],
        sourceUserPathImg: feed["sourceUserPathImg"]
            [feed["sourceUserPathImg"].length - 1]);
    List<NotifiModel> notifiInit = notifiProvider.listNotifiP;
    notifiInit.insert(0, not);
    notifiProvider.userNotifi(notifiInit);
  }
  //

  @override
  void dispose() {
    super.dispose();
    socket.dispose();
  }

  @override
  void initState() {
    super.initState();
    connect(widget.UserId);
  }

  @override
  Widget build(BuildContext context) {
    print(_numberNotifications.toString());
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Widget> _widgetOptions = [
      HomeScreen(),
      Profile(),
      SearchScreen(),
      ChatLoginScreen(),
      NotifiScreen()
    ];
    // final user = FirebaseAuth.instance.currentUser!;
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                  // color: Colors.grey[500],
                ),
                title: Container(
                  child: Text("home"),
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide()),
                  ),
                ),
                backgroundColor: Colors.green),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.person,
                ),
                title: SizedBox(),
                backgroundColor: Colors.yellow),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.search,
              ),
              title: SizedBox(),
              backgroundColor: Colors.blue,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.location_on),
              title: SizedBox(),
              backgroundColor: Colors.blue,
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.notification_important_outlined,
              ),
              title: _numberNotifications != 0
                  ? CircleAvatar(
                      backgroundColor: Colors.blue,
                      radius: 9,
                      child: Text(_numberNotifications.toString()),
                    )
                  : SizedBox(),
              backgroundColor: Colors.blue,
            ),
          ],
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          unselectedItemColor: Colors.grey[500],
          selectedFontSize: 14,
          unselectedFontSize: 14,
          onTap: _onItemTapped,
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.orange,
          iconSize: 26,
          elevation: 5),
    );
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
