import 'dart:async';

import 'package:flutter/material.dart';

import 'package:clickchat_app/src/global/helpers/app.dart';
import 'package:clickchat_app/src/global/helpers/value_disposable.dart';

import '../../models/chat_model.dart';
import '../../models/message_model.dart';
import '../../states/chats_state.dart';
import '../../usecases/get_all_chats.dart';
import '../../usecases/remove_chats.dart';

class ChatsController extends ValueNotifier<ChatsState>
    implements ValueDisposable {
  final IGetAllChats _getAllChats;
  final IRemoveChats _removeChats;
  final removeChatsLoading = ValueNotifier<bool>(false);
  final List<StreamSubscription<MessageModel?>> _lastMessagesSubscriptions = [];
  final List<StreamSubscription<int?>> _unreadMessagesSubscriptions = [];
  StreamSubscription<List<ChatModel>>? _chatsSubscription;

  ChatsController(this._getAllChats, this._removeChats)
      : super(ChatsState.initial());

  void init() async {
    if (value.isSuccess) return;

    _getAll();
  }

  void _getAll() {
    value = ChatsState.loading();

    final result = _getAllChats.call();

    if (!result.succeeded) {
      value = ChatsState.error(result.error!);
      return;
    }

    final chats = result.data!;

    _chatsSubscription = chats.listen(
      (chatsEvent) {
        value = ChatsState.success(chatsEvent);

        _cleanSubscriptions();

        for (var chat in chatsEvent) {
          _listenLastMessage(chat);
          _listenUnreadMessages(chat);
        }
      },
      onError: (error) {
        value = ChatsState.error(
          'Ocorreu um problema inesperado na atualização em tempo real. Aguarde alguns instantes e tente novamente.',
        );
      },
    );
  }

  void _listenUnreadMessages(ChatModel chat) {
    var unreadMessagesSubscription = chat.unreadMessages?.listen(
      (unreadMessages) {
        if (!value.isSuccess) return;

        var currentChats = value.asSuccess.chats;

        var index = currentChats.indexWhere(
          (element) => element.id == chat.id,
        );

        currentChats[index].unreadMessagesValue = unreadMessages;

        value = ChatsState.success(currentChats);
      },
    );

    if (unreadMessagesSubscription != null) {
      _unreadMessagesSubscriptions.add(unreadMessagesSubscription);
    }
  }

  void _listenLastMessage(ChatModel chat) {
    var lastMessageSubscription = chat.lastMessage?.listen((lastMessage) {
      if (lastMessage == null || !value.isSuccess) return;

      var currentChats = value.asSuccess.chats;

      var index = currentChats.indexWhere(
        (element) => element.id == chat.id,
      );

      currentChats[index].lastMessageValue = lastMessage;

      currentChats.sort((b, a) {
        var aDate = a.lastMessageValue?.dateTime;
        var bDate = b.lastMessageValue?.dateTime;

        if (aDate == null || bDate == null) return 0;

        return aDate.compareTo(bDate);
      });

      value = ChatsState.success(currentChats);
    });

    if (lastMessageSubscription != null) {
      _lastMessagesSubscriptions.add(lastMessageSubscription);
    }
  }

  void _cleanSubscriptions() {
    if (_lastMessagesSubscriptions.isNotEmpty) {
      for (var lastMessageSubscription in _lastMessagesSubscriptions) {
        lastMessageSubscription.cancel();
      }
      _lastMessagesSubscriptions.clear();
    }

    if (_unreadMessagesSubscriptions.isNotEmpty) {
      for (var unreadMessagesSubscription in _unreadMessagesSubscriptions) {
        unreadMessagesSubscription.cancel();
      }
      _unreadMessagesSubscriptions.clear();
    }
  }

  Future<void> refresh() async {
    _getAll();
  }

  Future<void> removeChats(List<String> chatsId) async {
    removeChatsLoading.value = true;

    final result = await _removeChats.call(chatsId);

    if (result.succeeded) {
      App.to.pop();
    } else {
      App.dialog.alert(result.error!);
    }

    removeChatsLoading.value = false;
  }

  @override
  Future<void> disposeValue() async {
    value = ChatsState.initial();

    _cleanSubscriptions();

    _chatsSubscription?.cancel();
  }
}
