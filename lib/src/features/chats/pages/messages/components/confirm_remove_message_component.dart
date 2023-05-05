import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../messages_controller.dart';

class ConfirmRemoveMessageComponent extends StatelessWidget {
  final String messageId;

  const ConfirmRemoveMessageComponent({required this.messageId, super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.read<MessagesController>();
    final colorScheme = Theme.of(context).colorScheme;

    return AlertDialog(
      title: const Text('Deseja apagar essa mensagem?'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'A mensagem será apagada apenas para você.',
            style: TextStyle(
              color: colorScheme.onSecondary,
            ),
          ),
        ],
      ),
      actionsPadding: EdgeInsets.zero,
      actions: [
        ValueListenableBuilder(
            valueListenable: controller.removeMessageLoading,
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
                              await controller.removeMessage(messageId);
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
