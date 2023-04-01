import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:clickchat_app/src/features/auth/pages/signup/signup_controller.dart';

import 'features/auth/pages/login/login_controller.dart';
import 'features/auth/pages/signup/signup_page.dart';
import 'features/auth/stores/login_store.dart';
import 'features/auth/stores/signup_store.dart';
import 'shared/services/auth_service.dart';
import 'shared/theme/app_theme.dart';
import 'app_page.dart';

final navigatorKey = GlobalKey<NavigatorState>();
final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(
          create: (context) => SignupStore(context.read()),
        ),
        ChangeNotifierProvider(
          create: (context) => LoginStore(context.read()),
        ),
        Provider(
          create: (context) => SignupController(context.read()),
        ),
        Provider(create: (context) => LoginController(context.read())),
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
