import 'package:provider/provider.dart';

import 'pages/chats/chats_controller.dart';
import 'pages/messages/messages_controller.dart';
import 'pages/new_chat/new_chat_controller.dart';
import 'repositories/chat_repository.dart';
import 'repositories/message_repository.dart';
import 'usecases/get_all_chats.dart';
import 'usecases/get_all_messages.dart';
import 'usecases/get_chat.dart';
import 'usecases/remove_chat.dart';
import 'usecases/remove_chats.dart';
import 'usecases/remove_message.dart';
import 'usecases/send_message.dart';

final chatsProvider = [
  Provider<IMessageRepository>(
    create: (context) => MessageRepository(context.read()),
  ),
  Provider<IChatRepository>(
    create: (context) => ChatRepository(context.read()),
  ),
  Provider<IGetAllChats>(
    create: (context) => GetAllChats(context.read(), context.read()),
  ),
  Provider<IGetChat>(
    create: (context) => GetChat(context.read(), context.read()),
  ),
  Provider<IGetAllMessages>(
    create: (context) => GetAllMessages(context.read(), context.read()),
  ),
  Provider<ISendMessage>(
    create: (context) => SendMessage(
      context.read(),
      context.read(),
      context.read(),
      context.read(),
    ),
  ),
  Provider<IRemoveMessage>(
    create: (context) => RemoveMessage(context.read(), context.read()),
  ),
  Provider<IRemoveChat>(
    create: (context) => RemoveChat(context.read(), context.read()),
  ),
  Provider<IRemoveChats>(
    create: (context) => RemoveChats(context.read(), context.read()),
  ),
  ChangeNotifierProvider(
    create: (context) => ChatsController(context.read(), context.read()),
  ),
  ChangeNotifierProvider(
    create: (context) => MessagesController(
      context.read(),
      context.read(),
      context.read(),
      context.read(),
      context.read(),
      context.read(),
      context.read(),
    ),
  ),
  ChangeNotifierProvider(
    create: (context) => NewChatController(context.read()),
  ),
];
