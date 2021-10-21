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
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart';

class IndividualChat extends StatefulWidget {
  final ChatModel? chatModel;
  const IndividualChat({Key? key, this.chatModel, this.sourceChat})
      : super(key: key);
  final ChatModel? sourceChat;

  @override
  _IndividualChatState createState() => _IndividualChatState();
}

class _IndividualChatState extends State<IndividualChat> {
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
    connect();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  //connect socket_io_client
  void connect() {
    print("begin connect....................");

    socket = io("http://d283-14-235-182-226.ngrok.io", <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false,
    });
    socket.connect();
    print(socket.connected);
    socket.emit("signin", widget.sourceChat!.id);
    socket.onConnect((data) {
      print("connected");
      print(mounted);
      socket.on("message", (msg) {
        print(msg["message"].toString());
        print(mounted == true);
        WidgetsBinding.instance!.addPostFrameCallback((_) {
          _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: Duration(milliseconds: 300),
              curve: Curves.easeOut);
        });
        setMessage("destion", msg["message"].toString(), msg["path"]);
      });
      // socket.on("test", (msg) {
      //   setMessage("destion", "nam");
      // });
    });
  }

  //gui tin nhan......................................
  void sendMessage(String message, int sourceId, int targetId, String path) {
    setMessage("source", message, path);

    socket.emit("message", {
      "message": message,
      "sourceId": sourceId,
      "targetId": targetId,
      "path": path
    });
  }

  //
  void setMessage(String type, String message, String path) {
    MessageModel messageModel = MessageModel(
        type: type,
        message: message,
        path: path,
        time: DateTime.now().toString().substring(10, 16));

    if (mounted)
      setState(() {
        messages.add(messageModel);
      });
  }

  //gửi hình ảnh................................
  void onImageSend(String path, String message) async {
    print("image.............${path}");
    print("message.......${message}");
    var request = http.MultipartRequest(
        "POST", Uri.parse("http://d283-14-235-182-226.ngrok.io/photos/upload"));

    request.files.add(await http.MultipartFile.fromPath("img", path));
    request.headers.addAll({
      "Content-type": "multipart/form-data",
    });
    http.StreamedResponse response = await request.send();
    var httpResponse = await http.Response.fromStream(response);
    var data = json.decode(httpResponse.body).toString();
    var pathSV = data.substring(11);
    print(data);
    setMessage("source", message, pathSV);

    socket.emit("message", {
      "message": message,
      "sourceId": widget.sourceChat!.id,
      "targetId": widget.chatModel!.id,
      "path": pathSV,
      "time": DateTime.now().toString(),
    });

    for (var i = 0; i < popTime; i++) {
      Navigator.pop(context);
    }
    setState(() {
      popTime = 0;
    });
  }

  _onEmojiSelected(Emoji emoji) {
    // setState(() {
    //   _controller.text = _controller.text + emoji.emoji;
    // });
    _controller
      ..text += emoji.emoji
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: _controller.text.length));
  }

  _onBackspacePressed() {
    _controller
      ..text = _controller.text.characters.skipLast(1).toString()
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: _controller.text.length));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Image.asset("assets/images/background.png",
          height: MediaQuery.of(context).size.height,
          fit: BoxFit.cover,
          width: MediaQuery.of(context).size.width),
      Scaffold(
          backgroundColor: Colors.transparent,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(60),
            child: AppBar(
              leadingWidth: 60,
              titleSpacing: 0,
              leading: Padding(
                padding: const EdgeInsets.only(left: 22, right: 12),
                child: InkWell(
                    onTap: () {
                      Navigator.pop(context, true);
                    },
                    child: Icon(Icons.arrow_back, size: 24)),
              ),
              title: InkWell(
                onTap: () {},
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 2.0),
                      child: CircleAvatar(
                          child: Image.asset(
                              widget.chatModel!.isGroup
                                  ? "assets/icons/groups.png"
                                  : "assets/icons/man.png",
                              width: 37,
                              height: 37)),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.chatModel!.name,
                            style: TextStyle(
                                fontSize: 18.5, fontWeight: FontWeight.bold)),
                        Text("last seen today 18:05",
                            style: TextStyle(fontSize: 11)),
                      ],
                    ),
                  ],
                ),
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
                    PopupMenuItem(child: Text("WallPaper"), value: "WallPaper"),
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
                  Expanded(
                      child: ListView.builder(
                          shrinkWrap: true,
                          controller: _scrollController,
                          itemCount: messages.length + 1,
                          itemBuilder: (context, index) {
                            if (index == messages.length) {
                              return Container(
                                height: 70,
                              );
                            }
                            if (messages[index].type == "source") {
                              if (messages[index].path.length > 0) {
                                return OwnFileCard(
                                  path: messages[index].path,
                                  message: messages[index].message,
                                );
                              } else {
                                return OwnMessageCard(
                                    message: messages[index].message,
                                    time: messages[index].time);
                              }
                            } else {
                              if (messages[index].path.length > 0) {
                                return ReplyFileCard(
                                  path: messages[index].path,
                                  message: messages[index].message,
                                );
                              } else {
                                return ReplyMessageCard(
                                    message: messages[index].message,
                                    time: messages[index].time);
                              }
                            }
                          })),
                  //input text............................................
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          height: 70,
                          child: Row(
                            children: [
                              Container(
                                  width: MediaQuery.of(context).size.width - 57,
                                  child: Card(
                                      margin: const EdgeInsets.only(
                                          left: 2, right: 2, bottom: 8),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(25)),
                                      //input text...........................................
                                      child: TextField(
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
                                        maxLines: 5,
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
                                                  icon: Icon(Icons.camera_alt),
                                                  onPressed: () {
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
                                                  icon: Icon(Icons.attach_file),
                                                  onPressed: () {
                                                    showModalBottomSheet(
                                                        backgroundColor:
                                                            Colors.transparent,
                                                        context: context,
                                                        builder: (builder) =>
                                                            bottomSheet());
                                                  },
                                                ),
                                              ]),
                                          contentPadding: EdgeInsets.all(5),
                                        ),
                                      ))),
                              Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 8.0, left: 2, right: 2),
                                child: CircleAvatar(
                                    radius: 25,
                                    child: IconButton(
                                      icon: !isSendBtn
                                          ? Icon(Icons.mic)
                                          : Icon(Icons.send),
                                      onPressed: () {
                                        if (isSendBtn) {
                                          _scrollController.animateTo(
                                              _scrollController
                                                  .position.maxScrollExtent,
                                              duration:
                                                  Duration(milliseconds: 300),
                                              curve: Curves.easeOut);
                                          sendMessage(
                                              _controller.text,
                                              widget.sourceChat!.id,
                                              widget.chatModel!.id,
                                              "");
                                          _controller.clear();
                                          if (mounted)
                                            setState(() {
                                              isSendBtn = false;
                                            });
                                        }
                                      },
                                    )),
                              ),
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
                  Navigator.pop(context);
                }
                return Future.value(false);
              },
            ),
          )),
    ]);
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
    print("chạy");
    super.dispose();
    socket.disconnect();
    _scrollController.dispose();
  }
}
