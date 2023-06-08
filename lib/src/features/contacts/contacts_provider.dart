import 'package:clickchat_app/src/features/contacts/usecases/delete_contact.dart';
import 'package:provider/provider.dart';

import 'pages/contacts/contacts_controller.dart';
import 'usecases/add_contact.dart';
import 'usecases/update_contact.dart';

final contactsProvider = [
  Provider<IAddContact>(
    create: (context) =>
        AddContact(context.read(), context.read(), context.read()),
  ),
  Provider<IDeleteContact>(
    create: (context) => DeleteContact(context.read(), context.read()),
  ),
  Provider<IUpdateContact>(
    create: (context) => UpdateContact(context.read(), context.read()),
  ),
  ChangeNotifierProvider(
    create: (context) => ContactsController(
      context.read(),
      context.read(),
      context.read(),
      context.read(),
    ),
  ),
];
