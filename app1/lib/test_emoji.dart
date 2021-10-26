import 'package:app1/Screen/LoginScreen.dart';
import 'package:app1/Screen/MainScreen.dart';
import 'package:app1/Stream/user_stream.dart';
import 'package:app1/model/user_model.dart';
import 'package:app1/provider/user_provider.dart';
import 'package:app1/ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  MyStream myStream = new MyStream();

  @override
  void dispose() {
    super.dispose();
    myStream.dispose();
  }

  @override
  void initState() {
    super.initState();
    myStream.userStream;
  }

  UserModel user = new UserModel(userName: "hey");
  @override
  Widget build(BuildContext context) {
    print("render");
    return Scaffold(
      appBar: AppBar(
        title: Text("heyf"),
      ),
      body: Consumer<UserProvider>(builder: (context, userProvider, child) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'You have pushed the button this many times:',
              ),
              TextButton(
                  onPressed: () {
                    userProvider.userLogin(user);
                  },
                  child: Text(userProvider.userP.userName)),
              StreamBuilder<UserModel>(
                stream: myStream.userStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasData) {
                    var a = snapshot.data;
                    if (a != null) {
                      if (a.userName != "") {
                        print(a.userName);
                        // Navigator.pushReplacementNamed(context, "/MainScreen");
                      } else {
                        return Container();
                      }
                    }

                    // print(snapshot.data);

                  }
                  return Container();
                },

                //  Text(
                //   snapshot.hasData ? snapshot.data.toString() : "0",
                //   style: Theme.of(context).textTheme.headline4,
                // ),
              ),
              RawMaterialButton(
                  shape: CircleBorder(),
                  fillColor: Colors.green,
                  onPressed: () {
                    // myStream.setUser(user);
                    print("oki");
                    UserModel user3 = UserModel(userName: "hihi3");

                    userProvider.userLogin(user3);
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => StreamBuilder<UserModel>(
                    //             stream: myStream.userStream,
                    //             initialData: user,
                    //             builder: (context, snapshot) {
                    //               print(snapshot.connectionState);
                    //               if (snapshot.data != null) {
                    //                 UserModel a = snapshot.data!;
                    //                 print("a.........");
                    //                 print("a.username là " + a.userName);
                    //               }
                    //               return LoginScreen();
                    //             })));
                  },
                  child: Image.asset(AppImages.nature))
            ],
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          myStream.setUser(user);
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
