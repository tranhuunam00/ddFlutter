import 'dart:convert';
import 'dart:developer';
import 'dart:ui';

import 'package:app1/Screen/LoginScreen.dart';
import 'package:app1/Screen/MainScreen.dart';
import 'package:app1/Screen/Profile.dart';
import 'package:app1/main.dart';
import 'package:app1/provider/user_provider.dart';
import 'package:app1/widgets/app_button.dart';
import 'package:app1/widgets/app_button_icon.dart';
import 'package:app1/widgets/dismit_keybord.dart';
import 'package:app1/widgets/text_input_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../ui.dart';

class SettingUser extends StatefulWidget {
  const SettingUser({Key? key}) : super(key: key);

  @override
  _SettingUser createState() => _SettingUser();
}

class _SettingUser extends State<SettingUser> {
  List<String> listTinhThanhPho = [
    'An Giang',
    'Bà rịa – Vũng tàu',
    'Bắc Giang',
    'Bắc Kạn',
    'Bạc Liêu',
    'Bắc Ninh',
    'Bến Tre',
    'Bình Định',
    'Bình Dương',
    'Bình Phước',
    'Bình Thuận',
    'Cà Mau',
    'Cần Thơ',
    'Cao Bằng',
    'Đà Nẵng',
    'Đắk Lắk',
    'Đắk Nông',
    'Điện Biên',
    'Đồng Nai',
    'Đồng Tháp',
    'Gia Lai',
    'Hà Giang',
    'Hà Nam',
    'Hà Nội',
    'Hà Tĩnh',
    'Hải Dương',
    'Hải Phòng',
    'Hậu Giang',
    'Hòa Bình',
    'Hưng Yên',
    'Khánh Hòa',
    'Kiên Giang',
    'Kon Tum',
    'Lai Châu',
    'Lâm Đồng',
    'Lạng Sơn',
    'Lào Cai',
    'Long An',
    'Nam Định',
    'Nghệ An',
    'Ninh Bình',
    'Ninh Thuận',
    'Phú Thọ',
    'Phú Yên',
    'Quảng Bình',
    'Quảng Nam',
    'Quảng Ngãi',
    'Quảng Ninh',
    'Quảng Trị',
    'Sóc Trăng',
    'Sơn La',
    'Tây Ninh',
    'Thái Bình',
    'Thái Nguyên',
    'Thanh Hóa',
    'Thừa Thiên Huế',
    'Tiền Giang',
    'Thành phố Hồ Chí Minh',
    'Trà Vinh',
    'Tuyên Quang',
    'Vĩnh Long',
    'Vĩnh Phúc',
    'Yên Bái',
  ];
  //List<String> listHuyenPhuong = ['Bắc Từ Liêm','Nam Từ Liêm','Thanh Oai'];
  //List<String> listXaPhuong = ['Mỹ Đình 1','Mỹ Đình 2','Mỹ Đình 3'];
  final TextEditingController _inputNameController = TextEditingController();
  var valueChooseTinh = 'Hà Nội';
  var valueChooseHuyen = 'Hà Nội';
  var valueChooseXa = 'Hà Nội';
  late DateTime _dateBirth;
  late String dateBirth;
  late bool valueCheckSexBoy;
  late bool valueCheckSexGirl;
  late bool valueCheckSexOther;

  @override
  void initState() {
    valueCheckSexBoy = false;
    valueCheckSexGirl = false;
    valueCheckSexOther = false;
    dateBirth = "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    return DismissKeyboard(
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: Padding(
              padding: EdgeInsets.symmetric(vertical: 24, horizontal: 32),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 90,
                    ),
                    Text("Thông tin cá nhân"),
                    Text(
                      "Họ và tên",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.w400),
                      textAlign: TextAlign.left,
                    ),
                    // SizedBox(height: 10,),
                    TextField(
                      controller: _inputNameController,
                      autofocus: false,
                      decoration: InputDecoration(
                          hintText: "VD: Nguyễn Văn A",
                          border: OutlineInputBorder()),
                    ),

                    //Quê quán
                    Text(
                      "Quê quán",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.w400),
                      textAlign: TextAlign.left,
                    ),
                    Text(
                      "Tỉnh/Thành phố",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                    ),
                    DropdownButton(
                      isExpanded: true,
                      hint: Text("..."),
                      dropdownColor: Colors.white,
                      value: valueChooseTinh,
                      onChanged: (value) {
                        setState(() {
                          valueChooseTinh = value as String;
                        });
                      },
                      items: listTinhThanhPho.map((valueTinh) {
                        return DropdownMenuItem(
                          value: valueTinh,
                          child: Text(valueTinh),
                        ); //DropdownMenuItem
                      }).toList(),
                    ), //Tỉnh

                    SizedBox(
                      height: 8,
                    ),
                    // Text("Quận/Huyện",style: TextStyle (fontSize: 20, fontWeight: FontWeight.w400),),
                    // DropdownButton(
                    //   isExpanded: true,
                    //   hint: Text("..."),
                    //   dropdownColor: Colors.white,
                    //   value: valueChooseHuyen,
                    //   onChanged: (value){
                    //     setState(() {
                    //       valueChooseHuyen = value as String;
                    //     });
                    //   },
                    //   items: listHuyenPhuong.map((valueHuyen) {
                    //     return  DropdownMenuItem(
                    //       value: valueHuyen,
                    //       child: Text(valueHuyen),
                    //     ); //DropdownMenuItem
                    //   }).toList(),
                    // ),//Huyện
                    //
                    SizedBox(
                      height: 8,
                    ),
                    //
                    Text(
                      "Xã/Phường",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                    ),
                    // DropdownButton(
                    //   isExpanded: true,
                    //   hint: Text("..."),
                    //   dropdownColor: Colors.white,
                    //   value: valueChooseXa,
                    //   onChanged: (value){
                    //     setState(() {
                    //       valueChooseXa = value as String;
                    //     });
                    //   },
                    //   items: listXaPhuong.map((valueXa) {
                    //   items: listXaPhuong.map((valueXa) {
                    //     return  DropdownMenuItem(
                    //       value: valueXa,
                    //       child: Text(valueXa),
                    //     ); //DropdownMenuItem
                    //   }).toList(),
                    // ),//Xã

                    SizedBox(
                      height: 10,
                    ),

                    // ............ Ngày sinh
                    Row(
                      children: <Widget>[
                        Text(
                          "Ngày sinh:  ",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w400),
                        ),
                        RaisedButton(
                            child: Text("Chọn"),
                            onPressed: () {
                              showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1975),
                                lastDate: DateTime.now(),
                              ).then((date) {
                                setState(() {
                                  _dateBirth = date as DateTime;
                                  dateBirth =
                                      _dateBirth.toString().substring(0, 10);
                                });
                              });
                            }), //Chọn ngày sinh
                        Text(
                          "\t\t\t\t" + dateBirth,
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w400),
                        ),
                      ],
                    ), // Ngày sinh

                    //..............Giới tính
                    Row(
                      children: [
                        Text(
                          "Giới tính:",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w400),
                        ),
                        Row(
                          children: [
                            Row(
                              children: [
                                Checkbox(
                                  value: valueCheckSexBoy,
                                  onChanged: (valueSex) {
                                    setState(() {
                                      valueCheckSexBoy = valueSex as bool;
                                    });
                                    valueCheckSexGirl = false;
                                    valueCheckSexOther = false;
                                  },
                                ),
                                Text(
                                  "Nam",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            ), // gt Nam

                            Row(
                              children: [
                                Checkbox(
                                  value: valueCheckSexGirl,
                                  onChanged: (valueSex) {
                                    setState(() {
                                      valueCheckSexGirl = valueSex as bool;
                                    });
                                    valueCheckSexBoy = false;
                                    valueCheckSexOther = false;
                                  },
                                ),
                                Text(
                                  "Nữ",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            ), // gt Nữ

                            Row(
                              children: [
                                Checkbox(
                                  value: valueCheckSexOther,
                                  onChanged: (valueSex) {
                                    setState(() {
                                      valueCheckSexOther = valueSex as bool;
                                    });
                                    valueCheckSexGirl = false;
                                    valueCheckSexBoy = false;
                                  },
                                ),
                                Text(
                                  "Khác",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            ), // gt khác
                          ],
                        ),
                      ],
                    ), // Giới tính

                    //..............Nút Lưu
                    SizedBox(
                      height: 20,
                    ),
                    AppBTnStyle(
                        label: "Lưu cài đặt",
                        onTap: () async {
                          String sex;
                          String selectTinh = valueChooseTinh;
                          print("Họ, Tên  ---  " + _inputNameController.text);
                          print("Tỉnh đã chọn là ---  " + selectTinh);
                          //  print("Huyện đã chọn là ---  " + selectTinh);
                          //  print("Xã đã chọn là ---  " + selectTinh);
                          print("Ngày sinh  ---  " + dateBirth);
                          if (valueCheckSexBoy) {
                            sex = "Nam";
                            print("Giới tính  --- Nam ");
                          } else if (valueCheckSexGirl) {
                            print("Giới tính  --- Nữ ");
                            sex = "Nữ";
                          } else {
                            sex = "Other";
                            print("Giới tính  ---  Khác ");
                          }

                          log('Đã lưu cài đặt');
                          var result = await PostApi(
                              userProvider.jwtP,
                              {
                                "realName": _inputNameController.text,
                                "sex": sex,
                                "addressTinh": selectTinh,
                                "addressDetails": "",
                                "birthDate": dateBirth
                              },
                              "/user/setting");
                          print("kết quả là ---------");
                          if (result == "not jwt") {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (builder) => LoginScreen()));
                          }
                          if (result == "done") {
                            userProvider.userP.realName =
                                _inputNameController.text;
                            userProvider.userP.sex = sex;
                            userProvider.userP.addressTinh = selectTinh;
                            userProvider.userP.addressDetails = "";
                            userProvider.userP.birthDate = dateBirth;
                            if (_inputNameController.text != "user") {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (builder) => MainScreen()));
                            }
                          }
                          print(result);
                        }),
                  ], //nút lưu
                ),
              ),
            )));
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
