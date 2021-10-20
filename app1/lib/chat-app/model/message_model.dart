class MessageModel {
  late String type;
  late String message;
  late String time;
  late String path;
  MessageModel({
    this.type = "",
    this.message = "",
    this.time = "",
    required this.path,
  });
}
