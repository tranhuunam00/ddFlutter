List<String> friendNull = [''];

class UserModel {
  late String userName;
  late String email;
  late List? friend;
  late List? hadMessageList;
  late String realName;
  late String id;
  late List? avatarImg;
  late List? coverImg;
  late List? friendRequest;
  late List? friendConfirm;
  UserModel(
      {this.userName = "",
      this.email = "",
      this.realName = "",
      this.friend = null,
      this.id = "",
      this.hadMessageList = null,
      this.coverImg = null,
      this.friendConfirm = null,
      this.friendRequest = null,
      this.avatarImg = null});
}
