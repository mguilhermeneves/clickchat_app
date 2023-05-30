import 'package:clickchat_app/src/global/services/notification_service.dart';
import 'package:flutter/material.dart';

import 'package:clickchat_app/src/features/chats/usecases/remove_chat.dart';
import 'package:clickchat_app/src/features/chats/usecases/remove_message.dart';
import 'package:clickchat_app/src/features/chats/usecases/send_message.dart';
import 'package:clickchat_app/src/global/helpers/app.dart';
import 'package:clickchat_app/src/global/services/auth_service.dart';

import '../../models/chat_model.dart';
import '../../states/messages_state.dart';
import '../../usecases/get_all_messages.dart';
import '../../usecases/get_chat.dart';

class MessagesController extends ValueNotifier<MessagesState> {
  final AuthService _authService;
  final NotificationService _notificationService;
  final IGetAllMessages _getAllMessages;
  final ISendMessage _sendMessage;
  final IGetChat _getChat;
  final IRemoveMessage _removeMessage;
  final IRemoveChat _removeChat;
  late ChatModel chat;
  final sendLoading = ValueNotifier<bool>(false);
  final removeMessageLoading = ValueNotifier<bool>(false);
  final removeChatLoading = ValueNotifier<bool>(false);

  String get userId => _authService.userId;

  MessagesController(
    this._authService,
    this._notificationService,
    this._getAllMessages,
    this._sendMessage,
    this._getChat,
    this._removeMessage,
    this._removeChat,
  ) : super(MessagesState.initial());

  void init(ChatModel chatModel) {
    chat = chatModel;

    _notificationService.setChatId(chat.id);

    _getAll();
  }

  Future<void> initByUserId(String userId) async {
    value = MessagesState.loading();

    final result = await _getChat.call(userId);

    if (result.succeeded) {
      init(result.data!);
    } else {
      value = MessagesState.error(result.error!);
    }
  }

  Future<void> removeMessage(String messageId) async {
    removeMessageLoading.value = true;

    final result = await _removeMessage.call(chat.id, messageId);

    if (result.succeeded) {
      App.to.pop();
    } else {
      App.dialog.alert(result.error!);
    }

    removeMessageLoading.value = false;
  }

  Future<void> removeChat(String chatId) async {
    removeChatLoading.value = true;

    final result = await _removeChat.call(chat.id);

    if (result.succeeded) {
      App.to.pop();
    } else {
      App.dialog.alert(result.error!);
    }

    removeChatLoading.value = false;
  }

  Future<bool> send(String text) async {
    sendLoading.value = true;

    final result = await _sendMessage.call(chat, text);

    sendLoading.value = false;

    if (result.succeeded) {
      return true;
    } else {
      App.dialog.alert(result.error!);
      return false;
    }
  }

  Future<void> _getAll() async {
    value = MessagesState.loading();

    final result = await _getAllMessages.call(chat.id);

    if (result.succeeded) {
      value = MessagesState.success(result.data!);
    } else {
      value = MessagesState.error(result.error!);
    }
  }

  Future<bool> disposeChatId() async {
    _notificationService.setChatId(null);

    return true;
  }
}
