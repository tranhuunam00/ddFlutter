List<String> friendNull = [''];

class UserModel {
  late String userName;
  late String email;
  late List? friend;
  late String id;
  late List? avatarImg;
  late List? coverImg;
  UserModel(
      {this.userName = "",
      this.email = "",
      this.friend = null,
      this.id = "",
      this.coverImg = null,
      this.avatarImg = null});
}
