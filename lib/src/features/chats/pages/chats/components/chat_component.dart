import 'package:flutter/material.dart';

import 'package:clickchat_app/src/features/chats/models/message_model.dart';
import 'package:clickchat_app/src/global/theme/app_theme.dart';
import 'package:clickchat_app/src/global/helpers/datetime_extension.dart';
import 'package:clickchat_app/src/global/widgets/avatar_widget.dart';

import '../../../models/chat_model.dart';

class ChatComponent extends StatefulWidget {
  final ChatModel chat;
  final bool selected;
  final void Function() onLongPress;
  final void Function() onTap;

  const ChatComponent({
    super.key,
    required this.chat,
    required this.selected,
    required this.onLongPress,
    required this.onTap,
  });

  @override
  State<ChatComponent> createState() => _ChatComponentState();
}

class _ChatComponentState extends State<ChatComponent> {
  String lastMessageDateTime(DateTime dateTime) {
    final now = DateTime.now();
    if (dateTime.dateEquals(now)) {
      return dateTime.time;
    }

    final yesterday = DateTime(now.year, now.month, now.day - 1);
    if (dateTime.dateEquals(yesterday)) {
      return 'Ontem';
    }

    return dateTime.date;
  }

  @override
  Widget build(BuildContext context) {
    final contact = widget.chat.contact!;

    return InkWell(
      onLongPress: widget.onLongPress,
      onTap: widget.onTap,
      child: Container(
        decoration: BoxDecoration(
          color: widget.selected ? Theme.of(context).colorScheme.surface : null,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: Row(
            children: [
              Stack(
                children: [
                  Avatar(
                    letter: contact.name ?? contact.email!,
                    imageUrl: contact.userProfilePictureUrl,
                    size: 26,
                  ),
                  buildStampSelection(),
                ],
              ),
              const SizedBox(width: 15),
              StreamBuilder<MessageModel?>(
                stream: widget.chat.lastMessage,
                builder: (context, snapshot) {
                  final lastMessage = snapshot.data;

                  return Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                contact.name ?? contact.email!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            if (lastMessage != null) const SizedBox(width: 10),
                            if (lastMessage != null)
                              Text(
                                lastMessageDateTime(lastMessage.dateTime),
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                          ],
                        ),
                        if (lastMessage != null) const SizedBox(height: 2),
                        if (lastMessage != null)
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  lastMessage.text,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style:
                                      Theme.of(context).textTheme.labelMedium,
                                ),
                              ),
                              StreamBuilder(
                                  stream: widget.chat.unreadMessages,
                                  builder: (context, snapshot) {
                                    final unreadMessages = snapshot.data;

                                    if (unreadMessages == null ||
                                        unreadMessages == 0) {
                                      return Container();
                                    }

                                    return Container(
                                      height: 21,
                                      width: 21,
                                      decoration: BoxDecoration(
                                        gradient: AppTheme.gradient,
                                        borderRadius:
                                            BorderRadius.circular(100),
                                      ),
                                      child: Center(
                                        child: Text(
                                          unreadMessages > 99
                                              ? '99+'
                                              : unreadMessages.toString(),
                                          style: const TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                            ],
                          ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildStampSelection() {
    return Positioned(
      right: 0,
      bottom: 0,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 150),
        transitionBuilder: (child, animation) => ScaleTransition(
          scale: animation,
          child: child,
        ),
        child: widget.selected
            ? SizedBox(
                height: 22,
                width: 22,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Theme.of(context).colorScheme.background,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Colors.green,
                    ),
                    child: const Center(
                      child: Icon(Icons.check_rounded, size: 12),
                    ),
                  ),
                ),
              )
            : Container(),
      ),
    );
  }
}
