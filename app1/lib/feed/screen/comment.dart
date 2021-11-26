import 'dart:io';
import 'dart:convert';

import 'package:app1/chat-app/model/message_model.dart';
import 'package:app1/chat-app/screens_chat/CameraScreen.dart';
import 'package:app1/chat-app/screens_chat/CameraView.dart';
import 'package:app1/main.dart';
import 'package:app1/ui.dart';
import 'package:readmore/readmore.dart';
import 'package:app1/widgets/dismit_keybord.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import 'package:socket_io_client/socket_io_client.dart';

class CommentUser extends StatefulWidget {
  final CommentUser? chatModel;
  const CommentUser({Key? key, this.chatModel, this.sourceChat})
      : super(key: key);
  final CommentUser? sourceChat;

  @override
  _CommentUser createState() => _CommentUser();
}

class _CommentUser extends State<CommentUser> {
  final TextEditingController _controller = TextEditingController();
  bool isEmojiShowing = false;
  bool checkReaction = false;
  FocusNode focusNode = FocusNode();
  late Socket socket;
  final ImagePicker _picker = ImagePicker();
  bool isSendBtn = false;
  List<MessageModel> messages = [];
  ScrollController _scrollController = ScrollController();
  int popTime = 0;
  int dem = 15;
  int demlan = 0;
  bool _checkMaxBuildComment = false;

  final List<DataTiles> dataCommentList = [
    DataTiles('Nam', 'hay the'),
    DataTiles('Nam', 'hay qua 10d'),
    DataTiles('Nam', 'hay vaayj'),
  ];
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

  @override
  Widget build(BuildContext context) {
    return DismissKeyboard(
        child: Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 20,
          ),

          Padding(
            padding: const EdgeInsets.only(top: 1, bottom: 1),
            child: Container(
              height: 50,
              width: MediaQuery.of(context).size.width - 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  GestureDetector(
                    onTap: () async {
                      print("ShowReaction - ...");
                    },
                    child: Row(
                      children: <Widget>[
                        if (checkReaction)
                          (Row(
                            children: [
                              Text(
                                '12',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black54),
                              ),
                              Icon(Icons.arrow_drop_down_circle_outlined,
                                  size: 25, color: Colors.black54),
                            ],
                          )) //có người like
                        else
                          Text(
                            "Hãy là người đầu tiên thích bài viết",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                color: Colors.black54),
                          ),
                        // chưa có người like
                      ],
                    ),
                  ),

                  GestureDetector(
                    onTap: () async {
                      print("Đã like/ Bỏ like");
                    },
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Icon(Icons.thumb_up_alt,
                              size: 25, color: Colors.black54),
                        ),
                      ],
                    ),
                  ), // nút like góc phải
                ],
              ),
            ),
          ),

          Divider(
            height: 1,
            color: Colors.black,
          ), //gạch ngang

          Expanded(
            child: ListView.builder(
              itemCount: dem,
              itemBuilder: (listViewContext, index) {
                return _buildRowComment();
              },
            ),
          ), // list view builder comment

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
                                  borderRadius: BorderRadius.circular(25)),
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
                                textAlignVertical: TextAlignVertical.center,
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
                                          focusNode.canRequestFocus = false;
                                          isEmojiShowing = !isEmojiShowing;
                                        });
                                    },
                                  ),
                                  suffixIcon: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.camera_alt),
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
                                  ? Icon(Icons.send)
                                  : Icon(Icons.send),
                              onPressed: () {
                                if (isSendBtn) {
                                  _scrollController.animateTo(
                                      _scrollController
                                          .position.maxScrollExtent,
                                      duration: Duration(milliseconds: 300),
                                      curve: Curves.easeOut);
                                  print("Vừa đã cmt");
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
                        onEmojiSelected: (Category category, Emoji emoji) {
                          _onEmojiSelected(emoji);
                        },
                        onBackspacePressed: _onBackspacePressed,
                        config: Config(
                            columns: 7,
                            emojiSizeMax: 24 * (Platform.isIOS ? 1.30 : 1.0),
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
                            tabIndicatorAnimDuration: kTabScrollDuration,
                            categoryIcons: const CategoryIcons(),
                            buttonMode: ButtonMode.MATERIAL)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ) //Scaffold
        ); // DismissKeyboard
  }

  Widget _buildRowComment() {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 2, 8, 8),
            child: CircleAvatar(
              child: const Text('NT'),
              backgroundColor: Colors.brown.shade50,
            ),
            // child: Container(
            //   width: 48,
            //   height: 48,
            //     child: Image.asset('assets/images/nature1.jpg',),
            // ),
          ), // Ảnh người cmt
          Column(
            children: <Widget>[
              Container(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 5, 8, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(),
                      Padding(
                        padding: const EdgeInsets.only(top: 0, bottom: 3),
                        child: Text(
                          "Nam Trần",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      buildText(
                        'kinh quá nhỉ kinh quá nhkinh quá nhkinh quá nhkinh quá nhkinh quá nhkinh quá nhkinh quá nhkinh quá nhkinh quá nhkinh quá nhkinh quá nhkinh quá nhkinh quá nhkinh quá nh',
                      ),
                    ],
                  ),
                ),
                decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.all(Radius.circular(5.0))),
                width: MediaQuery.of(context).size.width - 65,
              ),
              SizedBox(
                height: 3,
              ),
            ],
          ),
        ],
      ), // khung của mỗi người cmt
    );
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

  _onBackspacePressed() {
    if (mounted) {
      _controller
        ..text = _controller.text.characters.skipLast(1).toString()
        ..selection = TextSelection.fromPosition(
            TextPosition(offset: _controller.text.length));
    }
  }

  bottomSheet() {}
  void onImageSend(String path, String message) async {
    print("image.............${path}");
    print("message.......${message}");
    var request =
        http.MultipartRequest("POST", Uri.parse(SERVER_IP + "/photos/upload"));

    request.files.add(await http.MultipartFile.fromPath("img", path));
    request.headers.addAll({
      "Content-type": "multipart/form-data",
    });
    http.StreamedResponse response = await request.send();
    var httpResponse = await http.Response.fromStream(response);
    var data = json.decode(httpResponse.body).toString();
    var pathSV = data.substring(11);
    print(data);

    for (var i = 0; i < popTime; i++) {
      if (mounted) Navigator.pop(context);
    }
    if (mounted)
      setState(() {
        popTime = 0;
      });
  }

  Widget showHidenComment() {
    return Container(
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 1, 8, 8),
                child: Container(
                  width: 48,
                  height: 48,
                  child: Image.asset(''),
                ),
              ), // Ảnh người cmt
              Column(
                children: <Widget>[
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 5, 8, 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(),
                          Padding(
                            padding: const EdgeInsets.only(top: 0, bottom: 3),
                            child: Text(
                              "Bảo",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          Text(
                            'giỏi thế ',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w400),
                            maxLines: null,
                          ),
                        ],
                      ),
                    ),
                    decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.all(Radius.circular(5.0))),
                    width: MediaQuery.of(context).size.width - 65,
                  ),
                ],
              ),
            ],
          ), // khung của mỗi người cmt
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 1, 8, 8),
                child: Container(
                  width: 48,
                  height: 48,
                  child: Image.asset(''),
                ),
              ), // Ảnh người cmt
              Column(
                children: <Widget>[
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 5, 8, 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(),
                          Padding(
                            padding: const EdgeInsets.only(top: 0, bottom: 3),
                            child: Text(
                              "Bảo",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          Text(
                            'giỏi thế ',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w400),
                            maxLines: null,
                          ),
                        ],
                      ),
                    ),
                    decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.all(Radius.circular(5.0))),
                    width: MediaQuery.of(context).size.width - 65,
                  ),
                ],
              ),
            ],
          ), // khung của mỗi người cmt
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 1, 8, 8),
                child: Container(
                  width: 48,
                  height: 48,
                  child: Image.asset(''),
                ),
              ), // Ảnh người cmt
              Column(
                children: <Widget>[
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 5, 8, 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(),
                          Padding(
                            padding: const EdgeInsets.only(top: 0, bottom: 3),
                            child: Text(
                              "Bảo",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          Text(
                            'giỏi thế ',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w400),
                            maxLines: null,
                          ),
                        ],
                      ),
                    ),
                    decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.all(Radius.circular(5.0))),
                    width: MediaQuery.of(context).size.width - 65,
                  ),
                ],
              ),
            ],
          ), // khung của mỗi người cmt
        ],
      ),
    );
  }

  Widget _maxBuildComment(int dem) {
    return GestureDetector(
      onTap: () async {
        print("Xem thêm");
      },
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("Xem Thêm"),
          //Icon(Icons.thumb_up_alt, size: 25,color: Colors.black54),
        ),
      ),
    );
  }

  Widget buildText(String text) {
    return ReadMoreText(
      text,
      trimLines: 2,
      trimMode: TrimMode.Line,
      trimCollapsedText: "Xem thêm",
      trimExpandedText: "Ẩn bớt",
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
    );
  }
}

class DataTiles {
  late String name;
  late String comment;
  DataTiles(String name, String comment) {
    this.name = name;
    this.comment = comment;
  }
}
