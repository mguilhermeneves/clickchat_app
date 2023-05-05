import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:iconsax/iconsax.dart';

class AppBarChatsComponent extends StatelessWidget
    implements PreferredSizeWidget {
  final bool removeMode;
  final int selectedToRemove;
  final void Function() onCancelRemove;
  final void Function() onPressedRemove;

  const AppBarChatsComponent({
    super.key,
    this.removeMode = false,
    this.selectedToRemove = 0,
    required this.onCancelRemove,
    required this.onPressedRemove,
  });

  @override
  Size get preferredSize => const Size.fromHeight(57);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Stack(
      children: [
        AppBar(
          title: const Text('Conversas'),
          systemOverlayStyle: SystemUiOverlayStyle(
            systemNavigationBarColor: colorScheme.onBackground,
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Iconsax.search_normal),
            ),
            IconButton(
              onPressed: () => Navigator.of(context).pushNamed('/new-chat'),
              icon: const Icon(Iconsax.edit),
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(
              color: colorScheme.outline,
              height: 1,
            ),
          ),
        ),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 100),
          transitionBuilder: (child, animation) => SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, -1.0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
          child: removeMode ? buildAppBarRemove(context) : Container(),
        ),
      ],
    );
  }

  Widget buildAppBarRemove(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AppBar(
      title: Text(selectedToRemove.toString()),
      centerTitle: false,
      backgroundColor: colorScheme.surface,
      systemOverlayStyle: SystemUiOverlayStyle(
        systemNavigationBarColor: colorScheme.onBackground,
      ),
      leading: IconButton(
        onPressed: onCancelRemove,
        icon: const Icon(Icons.close_rounded),
      ),
      actions: [
        IconButton(
          onPressed: onPressedRemove,
          icon: const Icon(Iconsax.trash),
        ),
      ],
    );
  }
}
