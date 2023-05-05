import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../messages_controller.dart';

class ConfirmRemoveChatComponent extends StatelessWidget {
  final String chatId;

  const ConfirmRemoveChatComponent(this.chatId, {super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.read<MessagesController>();
    final colorScheme = Theme.of(context).colorScheme;

    return AlertDialog(
      title: const Text('Deseja apagar essa conversa?'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'As mensagens serão apagadas somente para você.',
            style: TextStyle(
              color: colorScheme.onSecondary,
            ),
          ),
        ],
      ),
      actionsPadding: EdgeInsets.zero,
      actions: [
        ValueListenableBuilder(
            valueListenable: controller.removeChatLoading,
            builder: (context, loading, child) {
              return Column(
                children: [
                  Divider(
                    thickness: 1,
                    height: 1,
                    color: colorScheme.outline,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: TextButton(
                      onPressed:
                          loading ? () {} : () => controller.removeChat(chatId),
                      style: TextButton.styleFrom(
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        foregroundColor: colorScheme.error,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                      ),
                      child: Text(loading ? 'Apagando...' : 'Apagar para mim'),
                    ),
                  ),
                  Divider(
                    thickness: 1,
                    height: 1,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: TextButton(
                      onPressed: loading ? null : Navigator.of(context).pop,
                      style: TextButton.styleFrom(
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            bottom: Radius.circular(15),
                          ),
                        ),
                      ),
                      child: const Text('Cancelar'),
                    ),
                  ),
                ],
              );
            })
      ],
    );
  }
}
