List<String> friendNull = [''];

class UserModel {
  late String userName;
  late String email;
  late String createdAt;

  late List friend;
  late List hadMessageList;
  late String realName;
  late String id;
  late String addressTinh;
  late String addressDetails;
  late String birthDate;
  late List avatarImg;
  late List coverImg;
  late String sex;
  late List friendRequest;
  late List friendConfirm;
  UserModel(
      {this.userName = "",
      this.email = "",
      this.realName = "",
      this.createdAt = "",
      required this.friend,
      this.id = "",
      this.sex = "",
      this.addressTinh = "",
      this.addressDetails = "",
      this.birthDate = "",
      required this.hadMessageList,
      required this.coverImg,
      required this.friendConfirm,
      required this.friendRequest,
      required this.avatarImg});
}

class UserCreateModel {
  late String userName;
  late String email;
  late String password;
  late List friend;
  late String token;
  late List hadMessageList;
  late String realName;

  late List avatarImg;
  late List coverImg;
  late List friendRequest;
  late List friendConfirm;
  UserCreateModel(
      {this.userName = "",
      this.email = "",
      this.realName = "",
      this.password = "",
      required this.friend,
      this.token = "",
      required this.hadMessageList,
      required this.coverImg,
      required this.friendConfirm,
      required this.friendRequest,
      required this.avatarImg});
}
