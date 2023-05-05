import 'package:flutter/material.dart';

import 'package:clickchat_app/src/global/helpers/app.dart';
import 'package:clickchat_app/src/global/helpers/value_disposable.dart';

import '../../states/chats_state.dart';
import '../../usecases/get_all_chats.dart';
import '../../usecases/remove_chats.dart';

class ChatsController extends ValueNotifier<ChatsState>
    implements ValueDisposable {
  final IGetAllChats _getAllChats;
  final IRemoveChats _removeChats;
  final removeChatsLoading = ValueNotifier<bool>(false);

  ChatsController(this._getAllChats, this._removeChats)
      : super(ChatsState.initial());

  void init() {
    if (value.isSuccess) return;

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

  Future<void> _getAll() async {
    value = ChatsState.loading();

    final result = _getAllChats.call();

    if (result.succeeded) {
      value = ChatsState.success(result.data!);
    } else {
      value = ChatsState.error(result.error!);
    }
  }

  @override
  void disposeValue() {
    value = ChatsState.initial();
  }
}
