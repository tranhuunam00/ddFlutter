class NotifiModel {
  late bool isSeen;
  late String type;
  late String sourceIdUser;
  late String targetIdUser;
  late String sourceUserPathImg;
  late String sourceRealnameUser;
  late String content;
  late String createdAt;
  NotifiModel(
      {this.type = "",
      this.sourceIdUser = "",
      this.sourceRealnameUser = "",
      this.sourceUserPathImg = "avatarNull.jpg",
      this.targetIdUser = "",
      this.createdAt = "",
      this.isSeen = false,
      this.content = ""});
}
