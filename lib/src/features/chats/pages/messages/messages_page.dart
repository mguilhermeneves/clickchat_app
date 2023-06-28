import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:clickchat_app/src/features/chats/pages/messages/components/app_bar_messages_component.dart';
import 'package:clickchat_app/src/features/chats/pages/messages/components/date_component.dart';
import 'package:clickchat_app/src/features/chats/pages/messages/components/input_component.dart';
import 'package:clickchat_app/src/features/chats/pages/messages/components/message_component.dart';
import 'package:clickchat_app/src/global/helpers/datetime_extension.dart';
import 'package:clickchat_app/src/global/widgets/messenger_widget.dart';

import '../../models/chat_model.dart';
import 'messages_controller.dart';

class MessagesPage extends StatefulWidget {
  final ChatModel? chat;
  final String? userId;

  const MessagesPage({this.chat, this.userId, super.key});

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  bool showEmoji = false;

  @override
  void initState() {
    if (widget.chat == null && widget.userId == null) {
      throw Exception('chat or userId must not be null.');
    }
    if (widget.chat != null && widget.userId != null) {
      throw Exception('Only one must be informed (chat or userId).');
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = context.read<MessagesController>();
      if (widget.chat == null) {
        controller.initByUserId(widget.userId!);
      } else {
        controller.init(widget.chat!);
      }
    });

    super.initState();
  }

  Future<bool> onWillPop() async {
    if (showEmoji) {
      setState(() => showEmoji = false);

      return Future.value(false);
    }

    return context.read<MessagesController>().disposeChatId();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<MessagesController>();
    final state = controller.value;

    if (state.isInitial) return Container();

    if (showEmoji == false) {}

    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        resizeToAvoidBottomInset: !showEmoji,
        appBar: const AppBarMessagesComponent(),
        body: Builder(
          builder: (context) {
            if (state.isLoading) {
              return const LinearProgressIndicator();
            }

            if (state.isError) {
              return Messenger.alert(state.asError.message);
            }

            return StreamBuilder(
              stream: state.asSuccess.messages,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Messenger.alert(
                    'Ocorreu um problema inesperado na atualização em tempo real. Aguarde alguns instantes e tente novamente.',
                  );
                }

                final messages = snapshot.data;
                final messageCount = messages?.length ?? 0;

                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        reverse: true,
                        controller: controller.scrollController,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        itemCount: messageCount + 1,
                        itemBuilder: (_, index) {
                          if (index == messageCount) {
                            controller.setHasMore(messageCount);

                            return ValueListenableBuilder(
                              valueListenable: controller.moreLoading,
                              builder: (_, loading, child) {
                                if (!loading) return Container();

                                return const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(),
                                    ),
                                  ],
                                );
                              },
                            );
                          }

                          final message = messages![index];
                          final iSent =
                              controller.userId == message.userIdSender;
                          bool previousSender = false;
                          DateTime? date;

                          if ((index + 1) < messages.length) {
                            final previousMessage = messages[index + 1];

                            if (previousMessage.userIdSender ==
                                    message.userIdSender &&
                                previousMessage.dateTime
                                    .dateEquals(message.dateTime)) {
                              previousSender = true;
                            }

                            if (!previousMessage.dateTime
                                .dateEquals(message.dateTime)) {
                              date = message.dateTime;
                            }
                          } else {
                            date = message.dateTime;
                          }

                          return Column(
                            children: [
                              DateComponent(date),
                              MessageComponent(
                                message: message,
                                iSent: iSent,
                                previousSender: previousSender,
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    InputComponent(
                      showEmoji: showEmoji,
                      setShowEmoji: (value) =>
                          setState(() => showEmoji = value),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
