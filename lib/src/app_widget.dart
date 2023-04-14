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
          '/signup': (_) => const SignupPage(),
        },
      ),
    );
  }
}
