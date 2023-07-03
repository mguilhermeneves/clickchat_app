import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

import 'package:clickchat_app/src/global/widgets/avatar_widget.dart';
import 'package:clickchat_app/src/global/helpers/app.dart';

import '../messages_controller.dart';
import 'confirm_remove_chat_component.dart';

class AppBarMessagesComponent extends StatelessWidget
    implements PreferredSizeWidget {
  const AppBarMessagesComponent({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(57);

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<MessagesController>();
    final state = controller.value;

    return AppBar(
      title: Builder(
        builder: (context) {
          if (state.isLoading || state.isError) return Container();

          final contact = controller.chat.contact!;

          return Row(
            children: [
              Avatar(
                letter: contact.name ?? contact.email!,
                imageUrl: contact.userProfilePictureUrl,
                size: 18,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  contact.name ?? contact.email!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 17),
                ),
              ),
            ],
          );
        },
      ),
      leading: IconButton(
        onPressed: () {
          Navigator.of(context).pop();
          controller.disposeChatId();
        },
        icon: const Icon(Iconsax.arrow_left),
      ),
      actions: [
        PopupMenuButton(
          icon: Transform.rotate(
            angle: 90 * math.pi / 180,
            child: const Icon(Iconsax.more),
          ),
          tooltip: '',
          position: PopupMenuPosition.under,
          onSelected: (selected) async {
            if (selected == 'buscar') {
              App.dialog.alert(
                'Função não implementada.',
              );
            }
            if (selected == 'apagar') {
              await showDialog(
                context: context,
                builder: (_) => ConfirmRemoveChatComponent(controller.chat.id),
              );
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'buscar',
              child: Row(
                children: [
                  Icon(Iconsax.search_status),
                  SizedBox(width: 15),
                  Text('Buscar'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'apagar',
              child: Row(
                children: [
                  Icon(Iconsax.trash),
                  SizedBox(width: 15),
                  Text('Apagar conversa'),
                ],
              ),
            ),
          ],
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          color: Theme.of(context).colorScheme.outline,
          height: 1,
        ),
      ),
    );
  }
}
