class FeedBaseModel {
  late List? pathImg;
  late String message;
  late String sourceUserId;
  late String createdAt;
  late List? rule;
  late String sourceUserName;
  late String feedId;
  late List? comment;
  late List? like;
  FeedBaseModel(
      {this.pathImg = null,
      this.message = "",
      this.sourceUserId = "",
      this.comment = null,
      this.rule = null,
      this.like = null,
      this.createdAt = "",
      this.sourceUserName = "",
      this.feedId = ""});
}
