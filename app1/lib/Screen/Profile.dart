import 'package:app1/Screen/LoadScreen.dart';
import 'package:app1/Screen/MainScreen.dart';
import 'package:app1/auth_social/google_sign_in.dart';
import 'package:app1/main.dart';
import 'package:app1/provider/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:app1/ui.dart';
import 'package:provider/provider.dart';
import '../widgets/app_button.dart';
import "../widgets/friend_avatar.dart";
import "../widgets/card_feed.dart";

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    // final user = FirebaseAuth.instance.currentUser!;
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    int numLine = 5;
    Size size = MediaQuery.of(context).size;
    List<Widget> a = [
      CardFeedStyle(),
      CardFeedStyle(),
      CardFeedStyle(),
    ];

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: ListView(
        children: [
          Container(
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
                  child: Image.asset(
                    "assets/images/nature.jpg",
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                    left: ((size.width - 16) - (size.height - 16) / 6) / 2 - 4,
                    right: null,
                    top: size.height / 36 * 5,
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 4),
                          borderRadius: BorderRadius.all(
                              Radius.circular(size.height / 12))),
                      child: Container(
                        clipBehavior: Clip.antiAlias,
                        width: size.height / 6,
                        height: size.height / 6,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                                Radius.circular(size.height / 12))),
                        child: Image.asset(
                          'assets/images/nature3.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    )),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 32.0),
            child: Center(
              child: Text(userProvider.userP.userName, style: AppStyles.h2),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(child: AppBTnStyle(label: "Thay đổi 1", onTap: () {})),
              AppBTnStyle(
                  label: "Đăng xuất",
                  onTap: () async {
                    userProvider.UserLogOut();
                    await storage.delete(key: "jwt");
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (builder) => LoadScreen()));
                  }),
            ],
          ),
          Padding(
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
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
                                fixedSize:
                                    MaterialStateProperty.all(Size(120, 30)),
                              ),
                              onPressed: () {},
                              icon: Icon(Icons.home),
                              label: Text("hình ảnh")),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8),
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
                                fixedSize:
                                    MaterialStateProperty.all(Size(120, 30)),
                              ),
                              onPressed: () {},
                              icon: Icon(Icons.home),
                              label: Text("hình ảnh")),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8),
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
                                fixedSize:
                                    MaterialStateProperty.all(Size(120, 30)),
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
                                fixedSize:
                                    MaterialStateProperty.all(Size(120, 30)),
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
          ),
        ],
      ),
    );
  }
}
