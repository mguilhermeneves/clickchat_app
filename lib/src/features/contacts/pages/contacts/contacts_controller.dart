import 'package:flutter/material.dart';

import 'package:clickchat_app/src/global/models/contact_model.dart';
import 'package:clickchat_app/src/global/states/contacts_state.dart';
import 'package:clickchat_app/src/global/helpers/value_disposable.dart';
import 'package:clickchat_app/src/global/usecases/get_all_contacts.dart';
import 'package:clickchat_app/src/global/helpers/app.dart';

import '../../usecases/add_contact.dart';
import '../../usecases/delete_contact.dart';

class ContactsController extends ValueNotifier<ContactsState>
    implements ValueDisposable {
  final IGetAllContacts _getAllContacts;
  final IAddContact _addContact;
  final IDeleteContact _deleteContact;
  final addLoading = ValueNotifier<bool>(false);
  final deleteLoading = ValueNotifier<bool>(false);

  ContactsController(
    this._getAllContacts,
    this._addContact,
    this._deleteContact,
  ) : super(ContactsState.initial());

  void init() {
    if (value.isSuccess) return;

    _getAll();
  }

  Future<void> add(ContactModel contact) async {
    addLoading.value = true;

    final result = await _addContact.call(contact);

    addLoading.value = false;

    if (result.succeeded) {
      App.to.pop();
    } else {
      App.dialog.alert(result.error!);
    }
  }

  Future<void> delete(String id) async {
    deleteLoading.value = true;

    final result = await _deleteContact.call(id);

    deleteLoading.value = false;

    if (result.succeeded) {
      App.to.pop();
    } else {
      App.dialog.alert(result.error!);
    }
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
