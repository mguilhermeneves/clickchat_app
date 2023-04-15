import 'package:flutter/material.dart';

import 'package:clickchat_app/src/features/contacts/usecases/get_all_contacts.dart';
import 'package:clickchat_app/src/global/helpers/app.dart';

import '../../../../global/models/contact_model.dart';
import '../../states/contacts_state.dart';
import '../../usecases/add_contact.dart';
import '../../usecases/delete_contact.dart';

class ContactsController extends ValueNotifier<ContactsState> {
  final IGetAllContacts _getAllContacts;
  final IAddContact _addContact;
  final IDeleteContact _deleteContact;
  final addLoading = ValueNotifier<bool>(false);
  final deleteLoading = ValueNotifier<bool>(false);

  ContactsController(
      this._getAllContacts, this._addContact, this._deleteContact)
      : super(ContactsState.initial());

  void init() {
    if (value.isSuccess) return;

    _getAll();
  }

  Future<void> add(ContactModel contact) async {
    addLoading.value = true;

    await Future.delayed(const Duration(seconds: 3));

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

    await Future.delayed(const Duration(seconds: 3));

    final result = _getAllContacts.call();

    if (result.succeeded) {
      value = ContactsState.success(result.data!);
    } else {
      value = ContactsState.error(result.error!);
    }
  }
}
