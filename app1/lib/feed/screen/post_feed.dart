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
import 'package:app1/chat-app/screens_chat/VideoView.dart';
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
import 'package:video_player/video_player.dart';

class PostFeedScreen extends StatefulWidget {
  const PostFeedScreen({Key? key}) : super(key: key);

  @override
  _PostFeedScreenState createState() => _PostFeedScreenState();
}

class _PostFeedScreenState extends State<PostFeedScreen> {
  final TextEditingController _controller = TextEditingController();
  bool isEmojiShowing = false;
  bool isVisible = false;
  String photopath = "";
  FocusNode focusNode = FocusNode();
  late Socket socket;
  final ImagePicker _picker = ImagePicker();
  //late final fileImage;

  List<XFile>? listFileImage = [];
  late VideoPlayerController _videoPlayerController;
  bool isSendBtn = false;
  int dem = 0;
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

  late Future<void> _initializeVideoPlayerFuture;

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
    isVisible = true;
    print("image.............: ${path}");
    var request = http.MultipartRequest(
        "POST", Uri.parse(SERVER_IP + "/file/img/upload"));
    request.files.add(await http.MultipartFile.fromPath("img", path));
    request.headers.addAll(
        {"Content-type": "multipart/form-data", "cookie": "jwt=" + jwt});

    http.StreamedResponse response = await request.send();

    var httpResponse = await http.Response.fromStream(response);
    print(httpResponse.statusCode);
    if (httpResponse.statusCode == 201 || httpResponse.statusCode == 200) {
      var data = json.decode(httpResponse.body).toString();
      print(" ");
      print(data);
      photopath = path;
      for (var i = 0; i < popTime; i++) {
        if (mounted) Navigator.pop(context);
      }

      if (mounted)
        setState(() {
          popTime = 0;
        });
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
                backgroundColor: Colors.pinkAccent,
                title: Text("Tạo bài viêt"),
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
                  // nút đăng  hiển thị ở trên appbar ............................
                  (_controller.text.length > 0 == true ||
                          isVisible) // kiểm tra có chữ hoặc có ảnh chưa để có thể ấn nút đăng
                      ? InkWell(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 20.0, right: 5, left: 5),
                            child: Text(
                              "ĐĂNG",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.black87),
                            ),
                          ),
                          onTap: () async {
                            print(listFileImage);
                            // print(_controller.text);
                            // FeedBaseModel feed = new FeedBaseModel(
                            //     like: [],
                            //     rule: [],
                            //     comment: [],
                            //     pathImg: [],
                            //     createdAt: DateTime.now().toString(),
                            //     sourceUserId: userProvider.userP.id,
                            //     message: _controller.text,
                            //     sourceUserName: userProvider.userP.userName);
                            // print('ND : ' + _controller.text);
                            // String newIdFeed = await PostFeedFunction(feed);
                            // if (newIdFeed == "not jwt") {
                            //   print(newIdFeed);
                            // } else {
                            //   if (newIdFeed != "error") {
                            //     FeedBaseModel a = new FeedBaseModel(
                            //         like: [],
                            //         rule: [],
                            //         comment: [],
                            //         pathImg: [],
                            //         feedId: newIdFeed,
                            //         createdAt: DateTime.now().toString(),
                            //         sourceUserId: userProvider.userP.id,
                            //         message: _controller.text,
                            //         sourceUserName:
                            //             userProvider.userP.userName);
                            //     List<FeedBaseModel> b = feedProvider.listFeedsP;
                            //     b.insert(0, a);
                            //     print("đã tạo mới bài viết rồi!");
                            //     feedProvider.userFeed(b);
                            //     Navigator.pop(context);
                            //   }
                            // }
                          },
                        )
                      : InkWell(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 20.0, right: 5, left: 5),
                            child: Text(
                              "ĐĂNG",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.black12),
                            ),
                          ),
                          onTap: null,
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
            body: SingleChildScrollView(
              //reverse: true,
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: WillPopScope(
                  child: Column(
                    children: [
                      //Avatar.............................................
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(8, 2, 8, 8),
                                    child: CircleAvatar(
                                      child: Text("BP"),
                                      backgroundColor: Colors.brown.shade50,
                                      // backgroundImage: ImageProvider,
                                    ),
                                    // child: Container(
                                    //   width: 48,
                                    //   height: 48,
                                    //     child: Image.asset('assets/images/nature1.jpg',),
                                    // ),
                                  ), // Ảnh người cmt

                                  Column(
                                    //mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Tên cá nhân
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 2),
                                        child: Text(
                                          'Bảo Phạm',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w800,
                                              color: Colors.black54),
                                        ),
                                      ),

                                      //cột chọn chế độ
                                      Container(
                                        child: Padding(
                                          padding: const EdgeInsets.all(3.0),
                                          child: Row(
                                            children: [
                                              // ví dụ sẵn chọn chế độ một mình
                                              Row(
                                                children: [
                                                  Icon(Icons.lock,
                                                      size: 20,
                                                      color: Colors
                                                          .black87), // icon ổ khóa
                                                  Text(
                                                    "Chỉ mình tôi",
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.black54),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xff7c94b6),
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      //put text............................................
                      //Khung status
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 8.0, top: 8, right: 8, bottom: 8),
                        child: Container(
                          color: Colors.black12,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  controller: _controller,
                                  keyboardType: TextInputType.multiline,
                                  maxLines: 8,
                                  decoration: InputDecoration.collapsed(
                                    hintText: "Bạn đang nghĩ gì?",
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // góc test hiển thị ảnh ...............
                      if (listFileImage!.length == 0)
                        SizedBox()
                      else
                        Expanded(
                          child: GridView.builder(
                              itemCount: listFileImage!.length,
                              itemBuilder: (listViewContext, index) => Padding(
                                    padding: const EdgeInsets.all(2),
                                    child: Container(
                                      child: Stack(
                                        fit: StackFit.expand,
                                        children: [
                                          Image.file(
                                            File(listFileImage![index].path),
                                            fit: BoxFit.cover,
                                          ),

                                          Positioned(
                                            right: 0,
                                            top: 0,
                                            child: Container(
                                              color: Color.fromRGBO(
                                                  255, 255, 255, 0.4),
                                              child: IconButton(
                                                onPressed: () async {
                                                  listFileImage!
                                                      .removeAt(index);
                                                  setState(() {});
                                                },
                                                icon: Icon(Icons.delete),
                                              ),
                                            ),
                                          ) //position
                                        ],
                                      ),
                                    ),
                                  ),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 4)),
                        ),

                      //các tiện ích
                      Expanded(
                        child: ListView(
                          children: [
                            // Thêm ảnh
                            FlatButton(
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 4, bottom: 4),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.camera_alt,
                                      color: Colors.green,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Text(
                                        "Ảnh/Video",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black54),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              onPressed: () {
                                showModalBottomSheet(
                                    backgroundColor: Colors.transparent,
                                    context: context,
                                    builder: (builder) => bottomSheet());
                              },
                            ),

                            // Gắn thẻ
                            FlatButton(
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 4, bottom: 4),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.person_add_alt_1_outlined,
                                      color: Colors.pink,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Text(
                                        "Gắn thẻ bạn bè",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black54),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              onPressed: () {
                                // Navigator.pushReplacement(context,
                                //     MaterialPageRoute(builder: (builder) => ListFriend()));
                              },
                            ),

                            // Thêm vị trí
                            FlatButton(
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 4, bottom: 4),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.location_pin,
                                      color: Colors.redAccent,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Text(
                                        "Thêm vị trí",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black54),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              onPressed: () {},
                            ),

                            //Tài liệu, file
                            FlatButton(
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 4, bottom: 4),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.insert_drive_file,
                                      color: Colors.blue,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Text(
                                        "Tài liệu",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black54),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              onPressed: () {},
                            ),

                            //Cảm xúc
                            FlatButton(
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 4, bottom: 4),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.emoji_emotions,
                                      color: Colors.yellow,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Text(
                                        "Cảm xúc/Hoạt động",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black54),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ),

                      // Nút đăng ở dưới cùng có hoặc không ...................................
                      // Container(
                      //   width: size.width,
                      //   height: 40,
                      //   color: Colors.green,
                      //   child: InkWell(
                      //     child: Padding(
                      //       padding: const EdgeInsets.all(8.0),
                      //       child: Text(
                      //         "ĐĂNG",
                      //         textAlign: TextAlign.center,
                      //         style: TextStyle(
                      //             fontSize: 18,
                      //             fontWeight: FontWeight.w800,
                      //             color: Colors.black87),
                      //       ),
                      //     ),
                      //     onTap: () async {
                      //       print(_controller.text);
                      //       FeedBaseModel feed = new FeedBaseModel(
                      //           like: [],
                      //           rule: [],
                      //           comment: [],
                      //           pathImg: [],
                      //           createdAt: DateTime.now().toString(),
                      //           sourceUserId: userProvider.userP.id,
                      //           message: _controller.text,
                      //           sourceUserName: userProvider.userP.userName);
                      //       print('ND : ' + _controller.text);
                      //       String newIdFeed = await PostFeedFunction(feed);
                      //       if (newIdFeed == "not jwt") {
                      //         print(newIdFeed);
                      //       } else {
                      //         if (newIdFeed != "error") {
                      //           FeedBaseModel a = new FeedBaseModel(
                      //               like: [],
                      //               rule: [],
                      //               comment: [],
                      //               pathImg: [],
                      //               feedId: newIdFeed,
                      //               createdAt: DateTime.now().toString(),
                      //               sourceUserId: userProvider.userP.id,
                      //               message: _controller.text,
                      //               sourceUserName: userProvider.userP.userName);
                      //           List<FeedBaseModel> b = feedProvider.listFeedsP;
                      //           b.insert(0, a);
                      //           print("đã tạo mới bài viết rồi!");
                      //           feedProvider.userFeed(b);
                      //           Navigator.pop(context);
                      //         }
                      //       }
                      //     },
                      //   ),
                      // ),
                      // (_controller.text.length > 0 == true)
                      //     ? Container(
                      //   width: size.width,
                      //   height: 40,
                      //   color: Colors.green,
                      //   child: InkWell(
                      //     child: Padding(
                      //       padding: const EdgeInsets.all(8.0),
                      //       child: Text(
                      //         "ĐĂNG",
                      //         textAlign: TextAlign.center,
                      //         style: TextStyle(
                      //             fontSize: 18,
                      //             fontWeight: FontWeight.w800,
                      //             color: Colors.black87),
                      //       ),
                      //     ),
                      //     onTap: () async {
                      //       print(_controller.text);
                      //       FeedBaseModel feed = new FeedBaseModel(
                      //           like: [],
                      //           rule: [],
                      //           comment: [],
                      //           pathImg: [],
                      //           createdAt: DateTime.now().toString(),
                      //           sourceUserId: userProvider.userP.id,
                      //           message: _controller.text,
                      //           sourceUserName: userProvider.userP.userName);
                      //       print('ND : ' + _controller.text);
                      //       String newIdFeed = await PostFeedFunction(feed);
                      //       if (newIdFeed == "not jwt") {
                      //         print(newIdFeed);
                      //       } else {
                      //         if (newIdFeed != "error") {
                      //           FeedBaseModel a = new FeedBaseModel(
                      //               like: [],
                      //               rule: [],
                      //               comment: [],
                      //               pathImg: [],
                      //               feedId: newIdFeed,
                      //               createdAt: DateTime.now().toString(),
                      //               sourceUserId: userProvider.userP.id,
                      //               message: _controller.text,
                      //               sourceUserName: userProvider.userP.userName);
                      //           List<FeedBaseModel> b = feedProvider.listFeedsP;
                      //           b.insert(0, a);
                      //           print("đã tạo mới bài viết rồi!");
                      //           feedProvider.userFeed(b);
                      //           Navigator.pop(context);
                      //         }
                      //       }
                      //     },
                      //   ),
                      // )
                      //     :Container(
                      //   width: size.width,
                      //   height: 40,
                      //   color: Colors.greenAccent,
                      //   child: InkWell(
                      //     child: Padding(
                      //       padding: const EdgeInsets.all(8.0),
                      //       child: Text(
                      //         "ĐĂNG",
                      //         textAlign: TextAlign.center,
                      //         style: TextStyle(
                      //             fontSize: 18,
                      //             fontWeight: FontWeight.w800,
                      //             color: Colors.black87),
                      //       ),
                      //     ),
                      //     onTap: null
                      //   ),
                      // ),
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
                    () async {
                      if (mounted)
                        setState(() {
                          popTime = 3;
                        });
                      print("chup ảnh................................");
                      dem = 0;

                      final XFile? file =
                          await _picker.pickImage(source: ImageSource.camera);
                      if (file != null && dem <= 20) {
                        listFileImage!.add(file);
                        dem = dem + 1;
                        print("Đã chụp ảnh");
                        setState(() {});
                      }
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
                      isVisible = true;

                      print("chuyen sang ảnh................................");
                      final List<XFile>? selectedFile =
                          await _picker.pickMultiImage();
                      if (selectedFile!.isNotEmpty) {
                        listFileImage!.addAll(selectedFile);
                        dem = listFileImage!.length;
                        print("Số ảnh chọn là " + dem.toString());
                        setState(() {});
                      }
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
                    Icons.ondemand_video,
                    Colors.orange,
                    "Video",
                    () async {
                      if (mounted)
                        setState(() {
                          popTime = 4;
                        });
                      print("Video................................");
                      final XFile? file =
                          await _picker.pickVideo(source: ImageSource.gallery);
                      //video = File(file.path);
                      //_videoPlayerController = VideoPlayerController.file(file.path);
                      if (file != null) {
                        listFileImage!.add(file);
                        print("1 video vừa được chọn ");
                        print(file.path);
                        setState(() {
                          _videoPlayerController =
                              VideoPlayerController.file(File(file.path));
                          _initializeVideoPlayerFuture =
                              _videoPlayerController.initialize();
                        });
                      }
                    },
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
}
