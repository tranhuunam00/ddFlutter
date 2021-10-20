class ChatModel {
  late String name;
  late String icon;
  late bool isGroup;
  late String time;
  late String currentMessage;
  late String status;
  late bool isSelect;
  late int id;

  ChatModel({
    this.id = 1,
    this.name = "",
    this.icon = "",
    this.isGroup = false,
    this.time = "",
    this.currentMessage = "",
    this.status = "",
    this.isSelect = false,
  });
}
