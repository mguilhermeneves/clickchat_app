class MessageModel {
  final String id;
  final String userIdSender;
  final String text;
  final DateTime dateTime;
  final String? userIdRemove;
  final bool read;

  MessageModel({
    required this.id,
    required this.userIdSender,
    required this.text,
    required this.dateTime,
    required this.read,
    this.userIdRemove,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
        id: json['id'],
        userIdSender: json['userIdSender'],
        text: json['text'],
        dateTime: json['dateTime'].toDate(),
        userIdRemove: json['userIdRemove'],
        read: json['read'],
      );
}
