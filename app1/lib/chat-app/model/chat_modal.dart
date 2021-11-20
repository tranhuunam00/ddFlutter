class ChatModel {
  late String userName;
  late String icon;
  late bool isGroup;
  late String time;
  late String currentMessage;
  late String status;
  late bool isSelect;
  late String id;

  ChatModel({
    this.id = "",
    this.userName = "",
    this.icon = "",
    this.isGroup = false,
    this.time = "",
    this.currentMessage = "",
    this.status = "",
    this.isSelect = false,
  });
}
