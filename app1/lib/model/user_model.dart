List<String> friendNull = [''];

class UserModel {
  late String userName;
  late String email;
  late List friend;
  late List hadMessageList;
  late String realName;
  late String id;
  late List avatarImg;
  late List coverImg;
  late List friendRequest;
  late List friendConfirm;
  UserModel(
      {this.userName = "",
      this.email = "",
      this.realName = "",
      required this.friend,
      this.id = "",
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
