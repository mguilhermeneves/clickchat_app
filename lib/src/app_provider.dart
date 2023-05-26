import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import 'features/chats/pages/chats/chats_controller.dart';
import 'features/contacts/pages/contacts/contacts_controller.dart';
import 'global/repositories/contact_repository.dart';
import 'global/repositories/user_repository.dart';
import 'global/services/auth_service.dart';
import 'global/services/notification_service.dart';
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
  Provider(
      create: (context) => NotificationService(context.read(), context.read())),
];

class AppProvider {
  /// Utilizado no AuthService.signOut()
  static Future<void> disposeValues(BuildContext context) async {
    context.read<ContactsController>().disposeValue();
    context.read<ChatsController>().disposeValue();

    /// Aguarda [disposeValue] de [NotificationService] pq ele conecta com
    /// firestore para apagar o token. Quando ocorre [signOut] antes, da erro
    /// de permissão no firestore.
    await context.read<NotificationService>().disposeValue();
  }
}
