import 'package:mocktail/mocktail.dart';

import 'package:clickchat_app/src/features/contacts/repositories/contact_repository.dart';
import 'package:clickchat_app/src/global/repositories/user_repository.dart';

class UserRepositoryMock extends Mock implements IUserRepository {}

class ContactRepositoryMock extends Mock implements IContactRepository {}
