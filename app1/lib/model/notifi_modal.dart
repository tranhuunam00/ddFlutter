class NotifiModel {
  late bool isSeen;
  late String type;
  late String sourceIdUser;
  late String sourceRealnameUser;
  late String content;

  NotifiModel(
      {this.type = "",
      this.sourceIdUser = "",
      this.sourceRealnameUser = "",
      this.isSeen = false,
      this.content = ""});
}
