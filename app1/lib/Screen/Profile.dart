import 'dart:convert';

import 'package:app1/Screen/LoadScreen.dart';
import 'package:app1/Screen/MainScreen.dart';
import 'package:app1/auth_social/google_sign_in.dart';
import 'package:app1/chat-app/screens_chat/CameraView.dart';
import 'package:app1/main.dart';
import 'package:app1/model/create_user.dart';
import 'package:app1/model/user_model.dart';
import 'package:app1/provider/user_provider.dart';
import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:app1/ui.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../widgets/app_button.dart';
import "../widgets/friend_avatar.dart";
import 'package:http/http.dart' as http;

import "../widgets/card_feed.dart";

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  int popTime = 0;

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    void onImageSend(String path, String event, String jwt) async {
      print("image.............${path}");
      var request = http.MultipartRequest(
          "POST", Uri.parse(SERVER_IP + "/file/img/upload"));
      request.fields["eventChangeImgUser"] = event;
      request.files.add(await http.MultipartFile.fromPath("img", path));
      request.headers.addAll(
          {"Content-type": "multipart/form-data", "cookie": "jwt=" + jwt});

      http.StreamedResponse response = await request.send();

      var httpResponse = await http.Response.fromStream(response);
      print(httpResponse.statusCode);
      if (httpResponse.statusCode == 201 || httpResponse.statusCode == 200) {
        var data = json.decode(httpResponse.body).toString();

        if (data == "error" || data == "not jwt") {
          print(data);
        } else {
          print(data);
          UserModel user = userProvider.userP;
          if (event == "avatar") {
            List avatar = user.avatarImg!;
            avatar.add(data);
            user.avatarImg = avatar;
          }
          if (event == "cover") {
            List cover = user.coverImg!;
            cover.add(data);
            user.coverImg = cover;
          }
          userProvider.userLogin(user, userProvider.jwtP);
          for (var i = 0; i < popTime; i++) {
            if (mounted) Navigator.pop(context);
          }
          if (mounted)
            setState(() {
              popTime = 0;
            });
        }
      } else {
        print("er");
      }
    }

    final ImagePicker _picker = ImagePicker();
    // final user = FirebaseAuth.instance.currentUser!;

    int numLine = 5;
    Size size = MediaQuery.of(context).size;
    List<Widget> a = [
      // CardFeedStyle(),
      // CardFeedStyle(),
      // CardFeedStyle(),
    ];
    ScrollController _scrollController = new ScrollController();
    print(userProvider.userP.userName);
    return Padding(
        padding: const EdgeInsets.all(4.0),
        child: ListView.builder(
            shrinkWrap: true,
            controller: _scrollController,
            itemCount: userProvider.listFeedsP.length + 4,
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
                        child: userProvider.userP.coverImg != null &&
                                userProvider.userP.coverImg != []
                            ? Image.network(
                                SERVER_IP +
                                    "/upload/" +
                                    userProvider.userP.coverImg![
                                        userProvider.userP.coverImg!.length -
                                            1],
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                "assets/images/nature.jpg",
                                fit: BoxFit.cover,
                              ),
                      ),
                      Positioned(
                          left:
                              ((size.width - 16) - (size.height - 16) / 6) / 2 -
                                  4,
                          right: null,
                          top: size.height / 36 * 5,
                          child: Container(
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.white, width: 4),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(size.height / 12))),
                            child: Container(
                              clipBehavior: Clip.antiAlias,
                              width: size.height / 6,
                              height: size.height / 6,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(size.height / 12))),
                              child: userProvider.userP.avatarImg != null &&
                                      userProvider.userP.avatarImg != []
                                  ? Image.network(
                                      SERVER_IP +
                                          "/upload/" +
                                          userProvider.userP.avatarImg![
                                              userProvider
                                                      .userP.avatarImg!.length -
                                                  1],
                                      fit: BoxFit.cover,
                                    )
                                  : Image.asset(
                                      'assets/images/nature3.jpg',
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          )),
                      //------camera bia--------------------------
                      Positioned(
                          top: size.height / 36 * 6,
                          right: 10,
                          child: CircleAvatar(
                            backgroundColor: Color.fromRGBO(0, 0, 0, 0.4),
                            child: IconButton(
                              color: Colors.grey,
                              icon: Icon(Icons.camera_alt_sharp,
                                  color: Colors.blueAccent, size: 20),
                              onPressed: () async {
                                if (mounted)
                                  setState(() {
                                    popTime = 1;
                                  });
                                print(
                                    "chuyen sang camera................................");
                                final XFile? file = await _picker.pickImage(
                                    source: ImageSource.gallery);
                                print(file);
                                file != null
                                    ? Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (builder) =>
                                                CameraViewPage(
                                                  path: file.path,
                                                  event: "cover",
                                                  onImageSend: onImageSend,
                                                )))
                                    : print("chọn file");
                              },
                            ),
                          )),

                      ///---------------camera ở avatar------------------
                      Positioned(
                          top: size.height / 36 * 9,
                          left:
                              ((size.width - 16) + (size.height - 16) / 6) / 2 -
                                  36,
                          child: CircleAvatar(
                            backgroundColor: Color.fromRGBO(0, 0, 0, 0.4),
                            child: IconButton(
                              color: Colors.grey,
                              icon: Icon(Icons.camera_alt_sharp,
                                  color: Colors.blueAccent, size: 20),
                              onPressed: () async {
                                if (mounted)
                                  setState(() {
                                    popTime = 1;
                                  });
                                print(
                                    "chuyen sang camera................................");
                                final XFile? file = await _picker.pickImage(
                                    source: ImageSource.gallery);
                                print(file);
                                file != null
                                    ? Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (builder) =>
                                                CameraViewPage(
                                                  path: file.path,
                                                  event: "avatar",
                                                  onImageSend: onImageSend,
                                                )))
                                    : print("chọn file");
                              },
                            ),
                          ))
                    ],
                  ),
                );
              }
              if (index == 1) {
                return Padding(
                  padding: const EdgeInsets.only(top: 32.0),
                  child: Center(
                    child:
                        Text(userProvider.userP.userName, style: AppStyles.h2),
                  ),
                );
              }
              if (index == 2) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        child: AppBTnStyle(label: "Thay đổi 1", onTap: () {})),
                    AppBTnStyle(
                        label: "Đăng xuất",
                        onTap: () async {
                          await logoutFunction(userProvider.jwtP);
                          await storage.delete(key: "jwt");
                          await userProvider.UserLogOut();
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (builder) => LoadScreen()));
                        }),
                  ],
                );
              }
              if (index == 3) {
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: [
                          Icon(Icons.lock_clock),
                          Text("   Bắt đầu từ 9/2021", style: AppStyles.h4),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.badge),
                          Text("   Học tại đh Công Nghệ", style: AppStyles.h4),
                        ],
                      ),
                      TextButton.icon(
                          onPressed: () {},
                          icon: Icon(Icons.wysiwyg),
                          label: Text("   Xem chi tiết")),
                      AppBTnStyle(label: "Cài đặt riêng tư", onTap: () {}),
                      Divider(height: 60, color: Colors.black),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(children: [
                            Text("Bạn bè", style: AppStyles.h4),
                            Text("600 bạn", style: AppStyles.h4)
                          ]),
                          Icon(Icons.search)
                        ],
                      ),
                      GridView.count(
                        crossAxisCount: 3,
                        crossAxisSpacing: 4,
                        mainAxisSpacing: 4,
                        childAspectRatio: 4 / 5,
                        physics:
                            NeverScrollableScrollPhysics(), // to disable GridView's scrolling
                        shrinkWrap: true, // You won't see infinite size error
                        children: <Widget>[
                          AvatarFriendBtn(
                            frName: "Trang",
                            frImage: "assets/images/nature2.jpg",
                          ),
                          AvatarFriendBtn(
                            frName: "Trâm",
                            frImage: "assets/images/nature5.jpg",
                          ),
                          AvatarFriendBtn(
                            frName: "Trang",
                            frImage: "assets/images/nature3.jpg",
                          ),
                          AvatarFriendBtn(
                            frName: "Nhung",
                            frImage: "assets/images/nature4.jpg",
                          ),
                          AvatarFriendBtn(
                            frName: "Linh",
                            frImage: "assets/images/nature2.jpg",
                          ),
                        ],
                      ),
                      AppBTnStyle(label: "Xem tất cả bạn bè", onTap: () {}),
                      Divider(
                        height: 60,
                        color: Colors.black,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Đăng",
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          Icon(Icons.sort_sharp)
                        ],
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 8, right: 8.0),
                            child: CircleAvatar(
                              radius: 24,
                            ),
                          ),
                          SizedBox(
                              width: size.width - 150,
                              child: TextField(
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                decoration: InputDecoration(
                                  hintText: "Bạn đang nghĩ gì...",
                                ),
                              ))
                        ],
                      ),
                      Divider(
                        height: 40,
                        color: Colors.black,
                      ),
                      Container(
                        height: 40,
                        child: ListView(
                          physics: ClampingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 16),
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      width:
                                          1, //                   <--- border width here
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(16))),
                                child: TextButton.icon(
                                    style: ButtonStyle(
                                      fixedSize: MaterialStateProperty.all(
                                          Size(120, 30)),
                                    ),
                                    onPressed: () {},
                                    icon: Icon(Icons.home),
                                    label: Text("hình ảnh")),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 8.0, right: 8),
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      width:
                                          1, //                   <--- border width here
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(16))),
                                child: TextButton.icon(
                                    style: ButtonStyle(
                                      fixedSize: MaterialStateProperty.all(
                                          Size(120, 30)),
                                    ),
                                    onPressed: () {},
                                    icon: Icon(Icons.home),
                                    label: Text("hình ảnh")),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 8.0, right: 8),
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      width:
                                          1, //                   <--- border width here
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(16))),
                                child: TextButton.icon(
                                    style: ButtonStyle(
                                      fixedSize: MaterialStateProperty.all(
                                          Size(120, 30)),
                                    ),
                                    onPressed: () {},
                                    icon: Icon(Icons.home),
                                    label: Text("hình ảnh")),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 16),
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 1,
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(16))),
                                child: TextButton.icon(
                                    style: ButtonStyle(
                                      fixedSize: MaterialStateProperty.all(
                                          Size(120, 30)),
                                    ),
                                    onPressed: () {},
                                    icon: Icon(Icons.home),
                                    label: Text("hình ảnh")),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        height: 40,
                      ),
                      for (var item in a) item
                    ],
                  ),
                );
              }
              return CardFeedStyle(
                  feed: userProvider.listFeedsP[index - 4],
                  userOwnUse: userProvider.userP);
            }));
  }

  //.....................pop image gely-----------

  //
  postApi(String jwt, data, String sourcePath) async {
    print("----chạy hàm post api feed---------------");
    try {
      http.Response response;
      String path = SERVER_IP + sourcePath;
      print(path);
      response = await http.post(Uri.parse(path),
          headers: {
            'Content-type': 'application/json',
            'Accept': 'application/json',
            'cookie': "jwt=" + jwt,
          },
          body: jsonEncode(data));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return "error";
      }
    } catch (e) {
      return "error";
    }
  }

  var urlLogout = Uri.parse(SERVER_IP + '/auth/logout');
//-------logout----------------------------------------
  Future<String> logoutFunction(String token) async {
    http.Response response;
    response = await http.post(urlLogout,
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({"jwt": token}));

    return json.decode(response.body).toString();
    //-------------------------------
  }
}
