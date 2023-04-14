import 'package:clickchat_app/src/features/contacts/usecases/delete_contact.dart';
import 'package:provider/provider.dart';

import 'pages/contacts/contacts_controller.dart';
import 'repositories/contact_repository.dart';
import 'usecases/add_contact.dart';
import 'usecases/get_all_contacts.dart';

final contactsProvider = [
  Provider<IContactRepository>(
    create: (context) => ContactRepository(context.read()),
  ),
  Provider<IGetAllContacts>(
    create: (context) => GetAllContacts(context.read(), context.read()),
  ),
  Provider<IAddContact>(
    create: (context) =>
        AddContact(context.read(), context.read(), context.read()),
  ),
  Provider<IDeleteContact>(
    create: (context) => DeleteContact(context.read(), context.read()),
  ),
  ChangeNotifierProvider(
    create: (context) => ContactsController(
      context.read(),
      context.read(),
      context.read(),
    ),
  ),
];
