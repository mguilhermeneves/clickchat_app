import 'dart:async';

import 'package:flutter/material.dart';

import 'package:clickchat_app/src/global/services/notification_service.dart';
import 'package:clickchat_app/src/features/chats/usecases/remove_chat.dart';
import 'package:clickchat_app/src/features/chats/usecases/remove_message.dart';
import 'package:clickchat_app/src/features/chats/usecases/send_message.dart';
import 'package:clickchat_app/src/global/helpers/app.dart';
import 'package:clickchat_app/src/global/services/auth_service.dart';

import '../../models/chat_model.dart';
import '../../models/message_model.dart';
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
  final sendLoading = ValueNotifier<bool>(false);
  final removeMessageLoading = ValueNotifier<bool>(false);
  final removeChatLoading = ValueNotifier<bool>(false);
  final moreLoading = ValueNotifier<bool>(false);
  late ScrollController scrollController;
  late ChatModel chat;
  bool _hasMore = true;
  int _limit = _limitPerPage;

  static const int _limitPerPage = 40;

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

  late Stream<List<MessageModel>> stream;

  void init(ChatModel chatModel) async {
    chat = chatModel;

    _notificationService.setChatId(chat.id);

    scrollController = ScrollController()..addListener(_getMore);

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

  void setHasMore(int messageCount) {
    if (messageCount < _limit) {
      _hasMore = false;
    } else {
      _hasMore = true;
    }
  }

  Future<void> _getMore() async {
    double pixels = scrollController.position.pixels;
    double maxScroll = scrollController.position.maxScrollExtent;

    if (pixels != maxScroll || moreLoading.value || !_hasMore) return;

    moreLoading.value = true;

    await Future.delayed(const Duration(milliseconds: 500));

    _limit += _limitPerPage;

    await _getAll();

    moreLoading.value = false;
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
    if (!value.isSuccess) {
      value = MessagesState.loading();
    }

    final result = await _getAllMessages.call(chat.id, _limit);

    if (result.succeeded) {
      value = MessagesState.success(result.data!);
    } else {
      value = MessagesState.error(result.error!);
    }
  }

  Future<bool> disposeChatId() async {
    value = MessagesState.initial();

    _notificationService.setChatId(null);

    _limit = _limitPerPage;

    _hasMore = true;

    return true;
  }
}
