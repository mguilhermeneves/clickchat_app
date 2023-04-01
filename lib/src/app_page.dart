import 'package:clickchat_app/src/features/auth/pages/login/login_page.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'shared/services/auth_service.dart';

class AppPage extends StatefulWidget {
  const AppPage({super.key});

  @override
  State<AppPage> createState() => _AppPageState();
}

class _AppPageState extends State<AppPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthService>();

    if (!auth.signedIn) {
      return const LoginPage();
    }

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('App Page'),
            const SizedBox(
              height: 10,
            ),
            Text(auth.user?.displayName ?? 'Sem nome'),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () {
                auth.signOut();
              },
              child: const Text('Sair'),
            ),
          ],
        ),
      ),
    );
  }
}
