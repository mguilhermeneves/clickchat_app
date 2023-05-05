import 'package:clickchat_app/src/features/chats/chats_provider.dart';
import 'package:clickchat_app/src/features/chats/models/chat_model.dart';
import 'package:clickchat_app/src/features/chats/pages/messages/messages_page.dart';
import 'package:clickchat_app/src/features/chats/pages/new_chat/new_chat_page.dart';
import 'package:clickchat_app/src/features/contacts/contacts_provider.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'app_provider.dart';
import 'features/auth/auth_provider.dart';
import 'features/auth/pages/signup/signup_page.dart';
import 'global/theme/app_theme.dart';
import 'app_page.dart';

final navigatorKey = GlobalKey<NavigatorState>();
final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ...appProvider,
        ...authProvider,
        ...contactsProvider,
        ...chatsProvider,
      ],
      child: MaterialApp(
        title: 'clickchat',
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.dark,
        darkTheme: AppTheme.dark,
        scaffoldMessengerKey: scaffoldMessengerKey,
        navigatorKey: navigatorKey,
        initialRoute: '/',
        routes: {
          '/': (_) => const AppPage(),
          '/page': (context) => AppPage(
                page: ModalRoute.of(context)!.settings.arguments as int,
              ),
          '/signup': (_) => const SignupPage(),
          '/chat-messages': (context) => MessagesPage(
                chat: ModalRoute.of(context)!.settings.arguments as ChatModel,
              ),
          '/chat-messages/new': (context) => MessagesPage(
                userId: ModalRoute.of(context)!.settings.arguments as String,
              ),
          '/new-chat': (_) => const NewChatPage(),
        },
      ),
    );
  }
}
