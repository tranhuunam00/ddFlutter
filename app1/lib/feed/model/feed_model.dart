class FeedBaseModel {
  late List pathImg;
  late String message;
  late String sourceUserId;
  late String createdAt;
  late List rule;
  late String sourceUserName;
  late String feedId;
  late List comment;
  late List like;
  FeedBaseModel(
      {required this.pathImg,
      this.message = "",
      this.sourceUserId = "",
      required this.comment,
      required this.rule,
      required this.like,
      this.createdAt = "",
      this.sourceUserName = "",
      this.feedId = ""});
}
