import 'dart:convert';

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
          AppBTnStyle(
              label: "Tìm bạn",
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                    print("---ấn vào tìm---");
                                  },
                                ),
                              ),
                              SizedBox(),
                            ],
                          ),
                        ),
                      );
                    });
              })
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
