import 'package:flutter/material.dart';

import 'package:clickchat_app/src/global/usecases/get_all_contacts.dart';
import 'package:clickchat_app/src/global/helpers/value_disposable.dart';
import 'package:clickchat_app/src/global/states/contacts_state.dart';

class NewChatController extends ValueNotifier<ContactsState>
    implements ValueDisposable {
  final IGetAllContacts _getAllContacts;

  NewChatController(this._getAllContacts) : super(ContactsState.initial());

  void init() {
    if (value.isSuccess) return;

    _getAll();
  }

  Future<void> _getAll() async {
    value = ContactsState.loading();

    final result = _getAllContacts.call();

    if (result.succeeded) {
      value = ContactsState.success(result.data!);
    } else {
      value = ContactsState.error(result.error!);
    }
  }

  @override
  Future<void> disposeValue() async {
    value = ContactsState.initial();
  }
}
