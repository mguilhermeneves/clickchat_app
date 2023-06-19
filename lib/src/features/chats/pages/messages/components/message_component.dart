import 'package:clickchat_app/src/features/chats/pages/messages/components/confirm_remove_message_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:iconsax/iconsax.dart';

import 'package:clickchat_app/src/features/chats/models/message_model.dart';
import 'package:clickchat_app/src/global/helpers/datetime_extension.dart';
import 'package:clickchat_app/src/global/theme/app_theme.dart';

class MessageComponent extends StatefulWidget {
  final MessageModel message;
  final bool iSent;
  final bool previousSender;

  const MessageComponent({
    super.key,
    required this.message,
    required this.iSent,
    required this.previousSender,
  });

  @override
  State<MessageComponent> createState() => _MessageComponentState();
}

class _MessageComponentState extends State<MessageComponent> {
  final _menuKey = GlobalKey<PopupMenuButtonState>();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    const radius = Radius.circular(15);

    if (widget.iSent) {
      final borderRadius = BorderRadius.only(
        bottomLeft: radius,
        topLeft: radius,
        topRight: widget.previousSender ? radius : Radius.zero,
        bottomRight: radius,
      );

      return Align(
        alignment: Alignment.centerRight,
        child: Padding(
          padding: EdgeInsets.only(
            top: widget.previousSender ? 4 : 15,
            left: 45,
            right: 15,
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: AppTheme.gradient,
              borderRadius: borderRadius,
            ),
            child: buildMessageActions(
              text: buildText(),
              borderRadius: borderRadius,
            ),
          ),
        ),
      );
    }

    final borderRadius = BorderRadius.only(
      bottomLeft: radius,
      bottomRight: radius,
      topRight: radius,
      topLeft: widget.previousSender ? radius : Radius.zero,
    );

    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(
          top: widget.previousSender ? 4 : 15,
          right: 45,
          left: 15,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: colorScheme.onSurface,
            borderRadius: borderRadius,
          ),
          child: buildMessageActions(
            text: buildText(),
            borderRadius: borderRadius,
          ),
        ),
      ),
    );
  }

  Widget buildText() {
    return RichText(
      textAlign: TextAlign.end,
      text: TextSpan(
        children: [
          WidgetSpan(
            child: Text(widget.message.text),
          ),
          const WidgetSpan(
            child: SizedBox(width: 7),
          ),
          WidgetSpan(
            child: Text(
              widget.message.dateTime.time,
              style: TextStyle(
                fontSize: 11,
                color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.6),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildMessageActions(
      {required Widget text, required BorderRadius borderRadius}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () async {
          if (FocusScope.of(context).hasFocus) {
            FocusScope.of(context).unfocus();
            await Future.delayed(const Duration(milliseconds: 300));
          }
          _menuKey.currentState?.showButtonMenu();
        },
        borderRadius: borderRadius,
        child: PopupMenuButton(
          key: _menuKey,
          enabled: false,
          onSelected: (value) async {
            if (value == 'apagar') {
              await showDialog(
                context: context,
                builder: (_) => ConfirmRemoveMessageComponent(
                  messageId: widget.message.id,
                ),
              );
            }
            if (value == 'copiar') {
              await Clipboard.setData(
                ClipboardData(text: widget.message.text),
              );
            }
          },
          tooltip: '',
          position: PopupMenuPosition.under,
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'copiar',
              child: Row(
                children: [
                  Icon(Iconsax.copy),
                  SizedBox(width: 15),
                  Text('Copiar'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'apagar',
              child: Row(
                children: [
                  Icon(Iconsax.trash),
                  SizedBox(width: 15),
                  Text('Apagar'),
                ],
              ),
            ),
          ],
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            child: text,
          ),
        ),
      ),
    );
  }
}
