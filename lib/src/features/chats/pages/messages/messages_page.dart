import 'package:flutter/material.dart';

import 'dart:math' as math;

import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

import 'package:clickchat_app/src/features/chats/pages/messages/components/date_component.dart';
import 'package:clickchat_app/src/features/chats/pages/messages/components/input_component.dart';
import 'package:clickchat_app/src/features/chats/pages/messages/components/message_component.dart';
import 'package:clickchat_app/src/global/helpers/datetime_extension.dart';
import 'package:clickchat_app/src/global/widgets/avatar_widget.dart';
import 'package:clickchat_app/src/global/widgets/messenger_widget.dart';

import 'components/confirm_remove_chat_component.dart';
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

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<MessagesController>();
    final state = controller.value;
    final colorScheme = Theme.of(context).colorScheme;

    if (state.isInitial) return Container();

    return WillPopScope(
      onWillPop: controller.disposeChatId,
      child: Scaffold(
        appBar: AppBar(
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
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.manage_search),
            ),
            PopupMenuButton(
              icon: Transform.rotate(
                angle: 90 * math.pi / 180,
                child: const Icon(Iconsax.more),
              ),
              tooltip: '',
              position: PopupMenuPosition.under,
              onSelected: (_) async {
                await showDialog(
                  context: context,
                  builder: (_) =>
                      ConfirmRemoveChatComponent(controller.chat.id),
                );
              },
              itemBuilder: (context) => [
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
              color: colorScheme.outline,
              height: 1,
            ),
          ),
        ),
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

                // return Column(
                //   children: [
                //     Expanded(
                //       child: SingleChildScrollView(
                //         physics: const BouncingScrollPhysics(),
                //         controller: controller.scrollController,
                //         reverse: true,
                //         child: Column(
                //           children: [
                //             ValueListenableBuilder(
                //               valueListenable: controller.moreLoading,
                //               builder: (_, loading, child) {
                //                 if (!loading) return Container();

                //                 return const Row(
                //                   mainAxisAlignment: MainAxisAlignment.center,
                //                   children: [
                //                     SizedBox(
                //                       height: 20,
                //                       width: 20,
                //                       child: CircularProgressIndicator(),
                //                     ),
                //                   ],
                //                 );
                //               },
                //             ),
                //             ListView.builder(
                //               shrinkWrap: true,
                //               reverse: true,
                //               physics: const NeverScrollableScrollPhysics(),
                //               padding: const EdgeInsets.symmetric(vertical: 10),
                //               itemCount: messageCount + 1,
                //               itemBuilder: (_, index) {
                //                 if (index == messageCount) {
                //                   controller.setHasMore(messageCount);
                //                   return Container();

                //                   // return ValueListenableBuilder(
                //                   //   valueListenable: controller.moreLoading,
                //                   //   builder: (_, loading, child) {
                //                   //     if (!loading) return Container();

                //                   //     return const Row(
                //                   //       mainAxisAlignment:
                //                   //           MainAxisAlignment.center,
                //                   //       children: [
                //                   //         SizedBox(
                //                   //           height: 20,
                //                   //           width: 20,
                //                   //           child: CircularProgressIndicator(),
                //                   //         ),
                //                   //       ],
                //                   //     );
                //                   //   },
                //                   // );
                //                 }

                //                 final message = messages![index];
                //                 final iSent =
                //                     controller.userId == message.userIdSender;
                //                 bool previousSender = false;
                //                 DateTime? date;

                //                 if ((index + 1) < messages.length) {
                //                   final previousMessage = messages[index + 1];

                //                   if (previousMessage.userIdSender ==
                //                           message.userIdSender &&
                //                       previousMessage.dateTime
                //                           .dateEquals(message.dateTime)) {
                //                     previousSender = true;
                //                   }

                //                   if (!previousMessage.dateTime
                //                       .dateEquals(message.dateTime)) {
                //                     date = message.dateTime;
                //                   }
                //                 } else {
                //                   date = message.dateTime;
                //                 }

                //                 return Column(
                //                   children: [
                //                     DateComponent(date),
                //                     MessageComponent(
                //                       message: message,
                //                       iSent: iSent,
                //                       previousSender: previousSender,
                //                     ),
                //                   ],
                //                 );
                //               },
                //             ),
                //           ],
                //         ),
                //       ),
                //     ),
                //     const InputComponent(),
                //   ],
                // );

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
                    const InputComponent(),
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
