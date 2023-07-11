import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:clickchat_app/src/features/chats/pages/chats/chats_controller.dart';
import 'package:clickchat_app/src/global/widgets/messenger_widget.dart';

import '../../models/chat_model.dart';
import 'components/app_bar_chats_component.dart';
import 'components/chat_component.dart';
import 'components/confirm_remove_chats_component.dart';

class ChatsPage extends StatefulWidget {
  final double bottomNavigationBarHeight;

  const ChatsPage({
    super.key,
    required this.bottomNavigationBarHeight,
  });

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  final Set<String> selectedChatsId = {};

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChatsController>().init();
    });

    super.initState();
  }

  void onSelected(String chatId) {
    setState(() {
      if (selectedChatsId.contains(chatId)) {
        selectedChatsId.remove(chatId);
      } else {
        selectedChatsId.add(chatId);
      }
    });
  }

  void onTap(ChatModel chat) {
    if (selectedChatsId.isNotEmpty) {
      setState(() {
        if (selectedChatsId.contains(chat.id)) {
          selectedChatsId.remove(chat.id);
        } else {
          selectedChatsId.add(chat.id);
        }
      });

      return;
    }

    Navigator.of(context).pushNamed(
      '/chat-messages',
      arguments: chat,
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ChatsController>();
    final state = controller.value;

    if (state.isInitial) return Container();

    return Scaffold(
      appBar: AppBarChatsComponent(
        removeMode: selectedChatsId.isNotEmpty,
        selectedToRemove: selectedChatsId.length,
        onCancelRemove: () => setState(() {
          selectedChatsId.clear();
        }),
        onPressedRemove: () async {
          await showDialog(
            context: context,
            builder: (_) => ConfirmRemoveChatsComponent(
              chatsId: selectedChatsId.toList(),
              onPressedConfirm: () => setState(() {
                selectedChatsId.clear();
              }),
            ),
          );
        },
      ),
      body: RefreshIndicator(
        onRefresh: controller.refresh,
        child: Builder(
          builder: (context) {
            if (state.isLoading) {
              return const LinearProgressIndicator();
            }

            if (state.isError) {
              return Messenger.alert(state.asError.message);
            }

            final chats = state.asSuccess.chats;

            if (chats.isEmpty) {
              return const Messenger(
                'Você não possui nenhuma conversa.',
              );
            }

            return ListView.builder(
              padding: EdgeInsets.only(
                top: 10,
                bottom: 10 + widget.bottomNavigationBarHeight,
              ),
              itemCount: chats.length,
              itemBuilder: (_, index) {
                final chat = chats[index];
                return ChatComponent(
                  key: Key(chat.id),
                  chat: chat,
                  selected: selectedChatsId.contains(chat.id),
                  onLongPress: () => onSelected(chat.id),
                  onTap: () => onTap(chat),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
