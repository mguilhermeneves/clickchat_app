import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

import 'package:clickchat_app/src/features/profile/pages/profile/profile_page.dart';
import 'package:clickchat_app/src/features/chats/pages/chats/chats_page.dart';
import 'package:clickchat_app/src/features/contacts/pages/contacts/contacts_page.dart';
import 'package:clickchat_app/src/global/theme/extensions/icon_extension.dart';

import 'global/services/auth_service.dart';
import 'global/services/notification_service.dart';
import 'global/widgets/keep_page_alive_widget.dart';

class AppPage extends StatefulWidget {
  final int? page;

  const AppPage({this.page, super.key});

  @override
  State<AppPage> createState() => _AppPageState();
}

class _AppPageState extends State<AppPage> {
  final double bottomNavigationBarHeight = 60;
  late int page = widget.page ?? 0;
  late final pageController = PageController(
    initialPage: widget.page ?? page,
  );

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = context.read<AuthService>();
      if (!auth.signedIn) {
        Navigator.of(context).pushReplacementNamed('/login');
      } else {
        context.read<NotificationService>().initialize();
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthService>();
    final colorScheme = Theme.of(context).colorScheme;

    /// Mostra temporariamente até chamar [addPostFrameCallback] no [initState].
    if (!auth.signedIn) {
      return Container(color: colorScheme.background);
    }

    return Scaffold(
      extendBody: true,
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        children: [
          KeepPageAlive(
            child: ChatsPage(
              bottomNavigationBarHeight: bottomNavigationBarHeight,
            ),
          ),
          KeepPageAlive(
            child: ContactsPage(
              bottomNavigationBarHeight: bottomNavigationBarHeight,
            ),
          ),
          const KeepPageAlive(
            child: ProfilePage(),
          ),
        ],
      ),
      bottomNavigationBar: Theme(
        data: ThemeData(
          splashColor: colorScheme.onSurface,
          highlightColor: colorScheme.onSurface,
        ),
        child: ClipRRect(
          child: SizedBox(
            height: bottomNavigationBarHeight,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 9, sigmaY: 9),
              child: BottomNavigationBar(
                elevation: 0,
                showSelectedLabels: false,
                showUnselectedLabels: false,
                currentIndex: page,
                selectedItemColor: colorScheme.primary,
                unselectedItemColor: colorScheme.secondary,
                backgroundColor: colorScheme.onBackground.withOpacity(0.85),
                type: BottomNavigationBarType.fixed,
                onTap: (index) {
                  setState(() => page = index);

                  pageController.jumpToPage(page);
                },
                items: [
                  BottomNavigationBarItem(
                    icon: _buildBottomNavigationBarIcon(
                      icon: Iconsax.message_text_1,
                      active: page == 0,
                    ),
                    label: 'messages',
                  ),
                  BottomNavigationBarItem(
                    icon: _buildBottomNavigationBarIcon(
                      icon: Iconsax.profile_2user,
                      active: page == 1,
                    ),
                    label: 'contacts',
                  ),
                  BottomNavigationBarItem(
                    icon: _buildBottomNavigationBarIcon(
                      icon: Iconsax.profile_circle,
                      active: page == 2,
                    ),
                    label: 'profile',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBarIcon({
    required IconData icon,
    required bool active,
  }) {
    return AnimatedSwitcher(
      switchInCurve: Curves.elasticIn,
      switchOutCurve: Curves.fastLinearToSlowEaseIn,
      duration: const Duration(milliseconds: 150),
      child: active
          ? Icon(icon, key: const ValueKey(1)).gradient()
          : Icon(icon, key: const ValueKey(2)),
      transitionBuilder: (child, animation) => ScaleTransition(
        scale: animation,
        child: child,
      ),
    );
  }
}
