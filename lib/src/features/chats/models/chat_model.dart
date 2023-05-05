import 'package:clickchat_app/src/global/models/contact_model.dart';

import 'message_model.dart';

class ChatModel {
  final String id;
  final List<String> usersId;
  Stream<MessageModel?>? lastMessage;
  ContactModel? contact;
  Stream<int>? unreadMessages;

  ChatModel({
    required this.id,
    required this.usersId,
    this.contact,
    this.lastMessage,
    this.unreadMessages,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) => ChatModel(
        id: json['id'],
        usersId: (json['usersId'] as Map<String, dynamic>).keys.toList(),
      );
}
