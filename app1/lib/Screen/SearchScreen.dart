import 'dart:convert';

import 'package:app1/user/screen/FriendProfile.dart';
import 'package:app1/main.dart';
import 'package:app1/model/user_model.dart';
import 'package:app1/provider/user_provider.dart';
import 'package:app1/widgets/app_button.dart';
import 'package:app1/widgets/dismit_keybord.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    Size size = MediaQuery.of(context).size;

    TextEditingController _textModalController = TextEditingController();
    return DismissKeyboard(
      child: Scaffold(
        appBar: AppBar(),
        body: Column(children: [
          Container(
              height: 120,
              width: size.width,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () async {
                        print("----search----------");
                        await showModalBottomSheet<String>(
                            context: context,
                            builder: (BuildContext context) {
                              return Container(
                                height: size.height * 2 / 3,
                                child: Center(
                                  child: Column(
                                    // crossAxisAlignment:
                                    //     CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      SizedBox(),
                                      // Text("ảo"),
                                      TextField(
                                          controller: _textModalController,
                                          decoration: InputDecoration(
                                            hintText: "nhập tiềm kiếm",
                                          )),
                                      Material(
                                        child: InkWell(
                                          child: Text("Tìm theo Id"),
                                          onTap: () async {
                                            _textModalController.text;
                                            print(_textModalController.text);
                                            // await getApi(userProvider.jwtP,
                                            //     "/user/" + userProvider.userP.id);
                                          },
                                        ),
                                      ),
                                      Material(
                                        child: InkWell(
                                          child: Text("Tìm theo email"),
                                          onTap: () async {
                                            print("---ấn vào tìm- email--");
                                            var result = await getApi(
                                                userProvider.jwtP,
                                                "/user/email/" +
                                                    _textModalController.text);
                                            print(result);
                                            if (result != "error" &&
                                                result != "not jwt") {
                                              if (result["_id"] != null) {
                                                if (result["_id"] !=
                                                    userProvider.userP.id) {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (builder) =>
                                                              FriendProfile(
                                                                  frId: result[
                                                                      "_id"])));
                                                }
                                              }
                                            }
                                          },
                                        ),
                                      ),
                                      SizedBox(),
                                    ],
                                  ),
                                ),
                              );
                            });
                      },
                      child: Container(
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Image.asset("assets/icons/findPeopleIcon.png"),
                              Text("Tìm bạn bè"),
                            ],
                          ),
                          width: size.width / 2 - 20,
                          height: 120,
                          color: Color.fromRGBO(200, 100, 400, 0.2)),
                    ),
                    InkWell(
                      onTap: () {
                        print("hihi");
                      },
                      child: Container(
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Image.asset("assets/icons/findPeopleIcon.png"),
                              Text("Có thể bạn quen"),
                            ],
                          ),
                          width: size.width / 2 - 20,
                          height: 120,
                          color: Color.fromRGBO(200, 100, 400, 0.2)),
                    )
                  ],
                ),
              )),
        ]),
      ),
    );
  }
}

Future<dynamic> getApi(String jwt, String pathApi) async {
  print("get Api " + pathApi);
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
