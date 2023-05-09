import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import 'package:clickchat_app/src/features/chats/pages/chats/chats_controller.dart';
import 'package:clickchat_app/src/features/contacts/pages/contacts/contacts_controller.dart';

import 'global/repositories/contact_repository.dart';
import 'global/repositories/user_repository.dart';
import 'global/services/auth_service.dart';
import 'global/usecases/get_all_contacts.dart';

final appProvider = [
  Provider<FirebaseFirestore>.value(value: FirebaseFirestore.instance),
  Provider<IUserRepository>(
    create: (context) => UserRepository(context.read()),
  ),
  ChangeNotifierProvider(create: (context) => AuthService(context.read())),
  Provider<IContactRepository>(
    create: (context) => ContactRepository(context.read()),
  ),
  Provider<IGetAllContacts>(
    create: (context) => GetAllContacts(context.read(), context.read()),
  ),
];

class AppProvider {
  static void disposeValues(BuildContext context) {
    Provider.of<ChatsController>(context, listen: false).disposeValue();
    Provider.of<ContactsController>(context, listen: false).disposeValue();
  }
}
