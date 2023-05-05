import 'package:clickchat_app/src/app_provider.dart';
import 'package:clickchat_app/src/features/auth/pages/login/login_page.dart';
import 'package:clickchat_app/src/features/chats/pages/chats/chats_controller.dart';
import 'package:clickchat_app/src/features/chats/pages/chats/chats_page.dart';
import 'package:clickchat_app/src/features/contacts/pages/contacts/contacts_page.dart';
import 'package:clickchat_app/src/global/theme/extensions/icon_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';

import 'package:provider/provider.dart';

import 'global/services/auth_service.dart';

class AppPage extends StatefulWidget {
  final int? page;

  const AppPage({this.page, super.key});

  @override
  State<AppPage> createState() => _AppPageState();
}

class _AppPageState extends State<AppPage> {
  late int page = widget.page ?? 0;
  late final pageController = PageController(
    initialPage: widget.page ?? page,
  );

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthService>();
    final colorScheme = Theme.of(context).colorScheme;

    if (!auth.signedIn) {
      return const LoginPage();
    }

    return Scaffold(
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        children: [
          ChatsPage(),
          ContactsPage(),
          //! temp
          Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('App Page'),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(auth.user?.displayName ?? 'Sem nome'),
                  Text(auth.user?.uid ?? ''),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      auth.signOut(context);
                    },
                    child: const Text('Sair'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      // bottomNavigationBar: Container(
      //   decoration: BoxDecoration(
      //     border: Border(
      //       top: BorderSide(
      //         color: Theme.of(context).colorScheme.onBackground,
      //         width: 1,
      //       ),
      //     ),
      //   ),
      //   child: NavigationBar(
      //     height: 57,
      //     onDestinationSelected: (index) {
      //       setState(() => page = index);
      //       pageController.jumpToPage(page);
      //     },
      //     labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
      //     surfaceTintColor: Colors.red,
      //     elevation: 0,
      //     selectedIndex: page,
      //     backgroundColor: Theme.of(context).colorScheme.background,
      //     destinations: <Widget>[
      //       NavigationDestination(
      //         icon: const Icon(Iconsax.message_text),
      //         selectedIcon: const Icon(Iconsax.message_text).gradient(),
      //         label: 'Chats',
      //       ),
      //       NavigationDestination(
      //         icon: const Icon(Iconsax.profile_2user),
      //         selectedIcon: const Icon(Iconsax.profile_2user).gradient(),
      //         label: 'Messages',
      //       ),
      //       NavigationDestination(
      //         icon: const Icon(Iconsax.setting),
      //         selectedIcon: const Icon(Iconsax.setting).gradient(),
      //         label: 'Config',
      //       ),
      //     ],
      //   ),
      // ),
      bottomNavigationBar: Theme(
        data: ThemeData(
          splashColor: colorScheme.onSurface,
          highlightColor: colorScheme.onSurface,
        ),
        child: Container(
          decoration: BoxDecoration(
              // // border: Border(
              // //   top: BorderSide(
              // //     color: Color(0xff272731),
              // //     // color: Color(0xff222430),
              // //   ),
              // // ),
              ),
          height: 60,
          child: BottomNavigationBar(
            elevation: 0,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            currentIndex: page,
            selectedItemColor: colorScheme.primary,
            unselectedItemColor: colorScheme.secondary,
            // unselectedItemColor: Color(0xff55556c),
            // unselectedItemColor: colorScheme.onSecondary,
            backgroundColor: colorScheme.onBackground,
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
                  icon: Iconsax.setting,
                  active: page == 2,
                ),
                label: 'settings',
              ),
              //     // BottomNavigationBarItem(
              //     //   label: 'settings',
              //     //   icon: FloatingActionButton(
              //     //     onPressed: () {},
              //     //     child: const Icon(Iconsax.message_add_1),
              //     //     // mini: true,
              //     //   ).gradient(),
              //     // ),
            ],
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
