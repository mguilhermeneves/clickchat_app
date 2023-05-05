import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:clickchat_app/src/features/chats/pages/chats/chats_controller.dart';

class ConfirmRemoveChatsComponent extends StatelessWidget {
  final List<String> chatsId;
  final void Function() onPressedConfirm;

  const ConfirmRemoveChatsComponent({
    super.key,
    required this.chatsId,
    required this.onPressedConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final controller = context.read<ChatsController>();

    final title = chatsId.length > 1
        ? 'Deseja apagar as ${chatsId.length} conversas?'
        : 'Deseja apagar essa conversa?';

    return AlertDialog(
      title: Text(title),
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
            valueListenable: controller.removeChatsLoading,
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
                      onPressed: loading
                          ? () {}
                          : () async {
                              await controller.removeChats(chatsId);
                              onPressedConfirm();
                            },
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
