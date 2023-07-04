import 'dart:ui';
import 'package:flutter/material.dart';

import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

import 'package:clickchat_app/src/features/profile/pages/profile/profile_page.dart';
import 'package:clickchat_app/src/features/chats/pages/chats/chats_page.dart';
import 'package:clickchat_app/src/features/contacts/pages/contacts/contacts_page.dart';
import 'package:clickchat_app/src/global/theme/extensions/icon_extension.dart';

import 'global/widgets/keep_page_alive_widget.dart';
import 'app_controller.dart';

class AppPage extends StatefulWidget {
  const AppPage({super.key});

  @override
  State<AppPage> createState() => _AppPageState();
}

class _AppPageState extends State<AppPage> {
  final double bottomNavigationBarHeight = 60;

  @override
  void initState() {
    final controller = context.read<AppController>();

    controller.init();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.initLate();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.read<AppController>();
    final colorScheme = Theme.of(context).colorScheme;

    return ListenableBuilder(
      listenable: controller.auth,
      builder: (context, child) {
        /// Mostra temporariamente até chamar [addPostFrameCallback] no [initState].
        if (!controller.auth.signedIn) {
          return Container(color: colorScheme.background);
        }

        return Scaffold(
          extendBody: true,
          body: PageView(
            physics: const NeverScrollableScrollPhysics(),
            controller: controller.pageController,
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
                  child: ValueListenableBuilder(
                      valueListenable: controller.page,
                      builder: (context, page, child) {
                        return BottomNavigationBar(
                          elevation: 0,
                          showSelectedLabels: false,
                          showUnselectedLabels: false,
                          currentIndex: page,
                          selectedItemColor: colorScheme.primary,
                          unselectedItemColor: colorScheme.secondary,
                          backgroundColor:
                              colorScheme.onBackground.withOpacity(0.85),
                          type: BottomNavigationBarType.fixed,
                          onTap: (index) {
                            if (index == AppPageView.chats.index) {
                              return controller.jumpToPage(AppPageView.chats);
                            }
                            if (index == AppPageView.contacts.index) {
                              return controller
                                  .jumpToPage(AppPageView.contacts);
                            }
                            if (index == AppPageView.profile.index) {
                              return controller.jumpToPage(AppPageView.profile);
                            }
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
                        );
                      }),
                ),
              ),
            ),
          ),
        );
      },
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
