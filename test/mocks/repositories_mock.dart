import 'package:mocktail/mocktail.dart';

import 'package:clickchat_app/src/features/chats/repositories/message_repository.dart';
import 'package:clickchat_app/src/features/chats/repositories/chat_repository.dart';
import 'package:clickchat_app/src/global/repositories/contact_repository.dart';
import 'package:clickchat_app/src/global/repositories/user_repository.dart';

class UserRepositoryMock extends Mock implements IUserRepository {}

class ContactRepositoryMock extends Mock implements IContactRepository {}

class ChatRepositoryMock extends Mock implements IChatRepository {}

class MessageRepositoryMock extends Mock implements IMessageRepository {}
