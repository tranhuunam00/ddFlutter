//
import 'dart:convert';
import 'dart:io';

import 'package:app1/chat-app/customs/OwnFile_card.dart';
import 'package:app1/chat-app/customs/OwnMessageCard.dart';
import 'package:app1/chat-app/customs/ReplyFile_card.dart';
import 'package:app1/chat-app/customs/ReplyMessageCard.dart';
import 'package:app1/chat-app/model/chat_modal.dart';
import 'package:app1/chat-app/model/message_model.dart';
import 'package:app1/chat-app/screens_chat/CameraScreen.dart';
import 'package:app1/chat-app/screens_chat/CameraView.dart';
import 'package:app1/feed/model/feed_model.dart';
import 'package:app1/main.dart';
import 'package:app1/model/user_model.dart';
import 'package:app1/provider/feed_provider.dart';
import 'package:app1/provider/message_provider.dart';
import 'package:app1/provider/user_provider.dart';
import 'package:app1/widgets/dismit_keybord.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart';

class PostFeedScreen extends StatefulWidget {
  const PostFeedScreen({Key? key}) : super(key: key);

  @override
  _PostFeedScreenState createState() => _PostFeedScreenState();
}

class _PostFeedScreenState extends State<PostFeedScreen> {
  final TextEditingController _controller = TextEditingController();
  bool isEmojiShowing = false;
  FocusNode focusNode = FocusNode();
  late Socket socket;
  final ImagePicker _picker = ImagePicker();
  bool isSendBtn = false;
  List<MessageModel> messages = [];
  ScrollController _scrollController = ScrollController();

  int popTime = 0;
  //.......................................................
  @override
  void initState() {
    super.initState();

    //tắt emoji khi nhập text
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        if (mounted)
          setState(() {
            isEmojiShowing = false;
          });
      }
    });
  }

  _onEmojiSelected(Emoji emoji) {
    // setState(() {
    //   _controller.text = _controller.text + emoji.emoji;
    // });
    if (mounted) {
      _controller
        ..text += emoji.emoji
        ..selection = TextSelection.fromPosition(
            TextPosition(offset: _controller.text.length));
    }
  }

  //gửi hình ảnh................................
  void onImageSend(String path, String jwt) async {
    print("image.............${path}");

    var request = http.MultipartRequest(
      "POST",
      Uri.parse(SERVER_IP + "/file/img/upload"),
    );
    request.fields["eventChangeImgUser"] = "message";
    request.headers.addAll(
        {"Content-type": "multipart/form-data", "cookie": "jwt=" + jwt});
    request.files.add(await http.MultipartFile.fromPath("img", path));

    http.StreamedResponse response = await request.send();
    var httpResponse = await http.Response.fromStream(response);
  }

  _onBackspacePressed() {
    if (mounted) {
      _controller
        ..text = _controller.text.characters.skipLast(1).toString()
        ..selection = TextSelection.fromPosition(
            TextPosition(offset: _controller.text.length));
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final feedProvider = Provider.of<FeedProvider>(context, listen: false);
    var urlPostFeed = Uri.parse(SERVER_IP + '/feed');
    Size size = MediaQuery.of(context).size;

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
            "createdAt": feed.createdAt,
          }));
      print(json.decode(response.body).toString());
      return json.decode(response.body).toString();
    }

    return DismissKeyboard(
      child: Stack(children: [
        Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(60),
              child: AppBar(
                leadingWidth: 60,
                titleSpacing: 0,
                leading: Padding(
                  padding: const EdgeInsets.only(left: 22, right: 12),
                  child: InkWell(
                      onTap: () async {
                        focusNode.unfocus();
                        if (!focusNode.hasFocus) {
                          Navigator.of(context).pop(true);
                        }

                        //
                      },
                      child: Icon(Icons.arrow_back, size: 24)),
                ),
                actions: [
                  IconButton(
                    icon: Icon(Icons.videocam),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(Icons.call),
                    onPressed: () {},
                  ),
                  PopupMenuButton<String>(onSelected: (value) {
                    print(value);
                  }, itemBuilder: (BuildContext context) {
                    return [
                      PopupMenuItem(
                          child: Text("View Contact"), value: "View Contact"),
                      PopupMenuItem(
                          child: Text("Media,Link"), value: "Media,Link"),
                      PopupMenuItem(
                          child: Text("Whatsapp Wed"), value: "Whatsapp Wed"),
                      PopupMenuItem(child: Text("Search"), value: "Search"),
                      PopupMenuItem(
                          child: Text("WallPaper"), value: "WallPaper"),
                      PopupMenuItem(
                          child: Text("Not notification"),
                          value: "Not notification"),
                    ];
                  })
                ],
              ),
            ),
            body: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: WillPopScope(
                child: Column(
                  children: [
                    //tin nhắn..............................................
                    //put text............................................
                    // và hiện thị ảnh
                    Expanded(
                      child: Column(
                        children: [
                          Container(
                            height: 100,
                            child: Row(
                              children: [
                                Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: Card(
                                        margin: const EdgeInsets.only(
                                            left: 2, right: 2, bottom: 8),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(25)),
                                        //input text...........................................
                                        child: TextFormField(
                                          maxLines: 5,
                                          focusNode: focusNode,
                                          controller: _controller,
                                          onChanged: (value) {
                                            if (value.length > 0) {
                                              if (mounted)
                                                setState(() {
                                                  isSendBtn = true;
                                                });
                                            } else {
                                              if (mounted)
                                                setState(() {
                                                  isSendBtn = false;
                                                });
                                            }
                                          },
                                          textAlignVertical:
                                              TextAlignVertical.center,
                                          keyboardType: TextInputType.multiline,
                                          minLines: 1,
                                          decoration: InputDecoration(
                                            hintText: "Nhập ... ",
                                            border: InputBorder.none,
                                            prefixIcon: IconButton(
                                              icon: Icon(Icons.emoji_emotions),
                                              onPressed: () {
                                                if (mounted)
                                                  setState(() {
                                                    focusNode.unfocus();
                                                    focusNode.canRequestFocus =
                                                        false;
                                                    isEmojiShowing =
                                                        !isEmojiShowing;
                                                  });
                                              },
                                            ),
                                            suffixIcon: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  IconButton(
                                                    icon:
                                                        Icon(Icons.camera_alt),
                                                    onPressed: () {
                                                      if (mounted)
                                                        setState(() {
                                                          popTime = 2;
                                                        });
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (builder) =>
                                                                  CameraScreen(
                                                                    onImageSend:
                                                                        onImageSend,
                                                                  )));
                                                    },
                                                  ),
                                                  IconButton(
                                                    icon:
                                                        Icon(Icons.attach_file),
                                                    onPressed: () {
                                                      showModalBottomSheet(
                                                          backgroundColor:
                                                              Colors
                                                                  .transparent,
                                                          context: context,
                                                          builder: (builder) =>
                                                              bottomSheet());
                                                    },
                                                  ),
                                                ]),
                                            contentPadding: EdgeInsets.all(5),
                                          ),
                                        ))),
                              ],
                            ),
                          ),
                          //emoji................................................
                          Offstage(
                            offstage: !isEmojiShowing,
                            child: SizedBox(
                              height: 250,
                              child: EmojiPicker(
                                  onEmojiSelected:
                                      (Category category, Emoji emoji) {
                                    _onEmojiSelected(emoji);
                                  },
                                  onBackspacePressed: _onBackspacePressed,
                                  config: Config(
                                      columns: 7,
                                      emojiSizeMax:
                                          24 * (Platform.isIOS ? 1.30 : 1.0),
                                      verticalSpacing: 0,
                                      horizontalSpacing: 0,
                                      initCategory: Category.RECENT,
                                      bgColor: const Color(0xFFF2F2F2),
                                      indicatorColor: Colors.blue,
                                      iconColor: Colors.grey,
                                      iconColorSelected: Colors.blue,
                                      progressIndicatorColor: Colors.blue,
                                      backspaceColor: Colors.blue,
                                      showRecentsTab: true,
                                      recentsLimit: 28,
                                      noRecentsText: 'No Recents',
                                      noRecentsStyle: const TextStyle(
                                          fontSize: 20, color: Colors.black26),
                                      tabIndicatorAnimDuration:
                                          kTabScrollDuration,
                                      categoryIcons: const CategoryIcons(),
                                      buttonMode: ButtonMode.MATERIAL)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    ////////////////////đây là cái viết như kiểu thêm ảnh /........................
                    //thêm các thứ
                    Container(
                      width: size.width,
                      height: size.height / 2,
                      color: Colors.green,
                      child: InkWell(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "ĐĂNG",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: Colors.black87),
                          ),
                        ),
                        onTap: () async {
                          print(_controller.text);
                          FeedBaseModel feed = new FeedBaseModel(
                              like: [],
                              rule: [],
                              comment: [],
                              pathImg: [],
                              createdAt: DateTime.now().toString(),
                              sourceUserId: userProvider.userP.id,
                              message: _controller.text,
                              sourceUserName: userProvider.userP.userName);
                          print('ND : ' + _controller.text);
                          String newIdFeed = await PostFeedFunction(feed);
                          if (newIdFeed == "not jwt") {
                            print(newIdFeed);
                          } else {
                            if (newIdFeed != "error") {
                              FeedBaseModel a = new FeedBaseModel(
                                  like: [],
                                  rule: [],
                                  comment: [],
                                  pathImg: [],
                                  createdAt: DateTime.now().toString(),
                                  sourceUserId: userProvider.userP.id,
                                  message: _controller.text,
                                  sourceUserName: userProvider.userP.userName);
                              List<FeedBaseModel> b = feedProvider.listFeedsP;
                              b.insert(0, feed);
                              print("đã tạo mới bài viết rồi!");
                              feedProvider.userFeed(b);
                              Navigator.pop(context);
                            }
                          }
                        },
                      ),
                    ),
                  ],
                ),
                //ấn quay lại thì kiểm tra xem có bật emoji k?
                onWillPop: () {
                  if (isEmojiShowing) {
                    if (mounted)
                      setState(() {
                        isEmojiShowing = false;
                      });
                  } else {
                    if (mounted) {
                      Navigator.pop(context);
                    }
                  }
                  return Future.value(false);
                },
              ),
            )),
      ]),
    );
  }

  Widget bottomSheet() {
    return Container(
        height: 278,
        width: MediaQuery.of(context).size.width,
        child: Card(
          margin: EdgeInsets.all(18),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 20, right: 20, top: 20, bottom: 10),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  iconcreation(
                    Icons.insert_drive_file,
                    Colors.indigo,
                    "Document",
                    () {},
                  ),
                  SizedBox(
                    width: 40,
                  ),
                  iconcreation(
                    Icons.camera_alt,
                    Colors.pink,
                    "Camera",
                    () {
                      if (mounted)
                        setState(() {
                          popTime = 3;
                        });
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (builder) => CameraScreen(
                                    onImageSend: onImageSend,
                                  )));
                    },
                  ),
                  SizedBox(
                    width: 40,
                  ),
                  iconcreation(
                    Icons.insert_photo,
                    Colors.purple,
                    "Gallary",
                    () async {
                      if (mounted)
                        setState(() {
                          popTime = 2;
                        });
                      print(
                          "chuyen sang camera................................");
                      final XFile? file =
                          await _picker.pickImage(source: ImageSource.gallery);
                      file != null
                          ? Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (builder) => CameraViewPage(
                                        path: file.path,
                                        event: "message",
                                        onImageSend: onImageSend,
                                      )))
                          : print("chọn file");
                    },
                  ),
                ]),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 20, right: 20, top: 20, bottom: 10),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  iconcreation(
                    Icons.headset,
                    Colors.orange,
                    "Audio",
                    () {},
                  ),
                  SizedBox(
                    width: 40,
                  ),
                  iconcreation(
                    Icons.location_pin,
                    Colors.pink,
                    "Location",
                    () {},
                  ),
                  SizedBox(
                    width: 40,
                  ),
                  iconcreation(
                    Icons.person,
                    Colors.blue,
                    "Contact",
                    () {},
                  )
                ]),
              )
            ],
          ),
        ));
  }

//widget
  Widget iconcreation(IconData icon, Color color, String text, Function onTap) {
    return InkWell(
      onTap: () => onTap(),
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: color,
            radius: 30,
            child: Icon(
              icon,
              size: 29,
              color: Colors.white,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(text, style: TextStyle(fontSize: 12))
        ],
      ),
    );
  }

  @override
  void dispose() {
    print("dispose      chạy");
    super.dispose();
    // socket.disconnect();
    // _scrollController.dispose();
  }
}
