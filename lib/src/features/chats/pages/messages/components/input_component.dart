import 'dart:io';
import 'package:flutter/material.dart';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

import 'package:clickchat_app/src/global/theme/extensions/circular_progress_indicator_extension.dart';
import 'package:clickchat_app/src/global/theme/extensions/floating_action_button_extension.dart';

import '../messages_controller.dart';

class InputComponent extends StatefulWidget {
  final bool showEmoji;
  final void Function(bool showEmoji) setShowEmoji;

  const InputComponent({
    super.key,
    required this.showEmoji,
    required this.setShowEmoji,
  });

  @override
  State<InputComponent> createState() => _InputComponentState();
}

class _InputComponentState extends State<InputComponent> {
  final textController = TextEditingController();
  final textFocus = FocusNode();
  bool showSendButton = false;

  @override
  void initState() {
    textController.addListener(() {
      setState(() {
        showSendButton = textController.text.isNotEmpty;
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    textController.dispose();
    textFocus.dispose();

    super.dispose();
  }

  Future<void> onSendPressed() async {
    if (textController.text.isEmpty) return;

    final sent =
        await context.read<MessagesController>().send(textController.text);
    if (sent) {
      textController.clear();
      setState(() {});
    }
  }

  void onBackspacePressed() {
    textController
      ..text = textController.text.characters.toString()
      ..selection = TextSelection.fromPosition(
        TextPosition(offset: textController.text.length),
      );
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.read<MessagesController>();
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(width: 1, color: colorScheme.outline),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: textController,
                  focusNode: textFocus,
                  minLines: 1,
                  maxLines: 4,
                  keyboardType: TextInputType.multiline,
                  textAlignVertical: TextAlignVertical.center,
                  textCapitalization: TextCapitalization.sentences,
                  onTap: () {
                    if (!widget.showEmoji) return;

                    widget.setShowEmoji(false);
                  },
                  decoration: InputDecoration(
                    prefixIcon: IconButton(
                      onPressed: () async {
                        if (widget.showEmoji) {
                          textFocus.requestFocus();
                        } else {
                          textFocus.unfocus();
                        }

                        widget.setShowEmoji(!widget.showEmoji);
                      },
                      icon: Icon(widget.showEmoji
                          ? Iconsax.keyboard
                          : Icons.emoji_emotions_outlined),
                    ),
                    prefixIconColor: colorScheme.secondary,
                    hintText: 'Mensagem...',
                    enabledBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(100),
                      borderSide: const BorderSide(color: Colors.transparent),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(100),
                      borderSide: const BorderSide(color: Colors.transparent),
                    ),
                    focusedErrorBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                    errorBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                  onChanged: (value) => setState(() {}),
                ),
              ),
              const SizedBox(width: 7),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 100),
                transitionBuilder: (child, animation) => SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(1.0, 0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
                child: showSendButton
                    ? ValueListenableBuilder(
                        valueListenable: controller.sendLoading,
                        builder: (context, loading, child) {
                          return SizedBox(
                            height: 48,
                            width: 48,
                            child: FloatingActionButton(
                              onPressed: onSendPressed,
                              child: loading
                                  ? const CircularProgressIndicator()
                                      .elevatedButton()
                                  : const Icon(Iconsax.send_2),
                            ).gradient(),
                          );
                        },
                      )
                    : Container(),
              ),
            ],
          ),
        ),
        Offstage(
          offstage: !widget.showEmoji,
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(width: 1, color: colorScheme.outline),
              ),
            ),
            child: SizedBox(
                height: 300,
                child: EmojiPicker(
                  textEditingController: textController,
                  onBackspacePressed: onBackspacePressed,
                  config: Config(
                    columns: 8,
                    emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0),
                    verticalSpacing: 0,
                    horizontalSpacing: 0,
                    gridPadding: EdgeInsets.zero,
                    initCategory: Category.RECENT,
                    bgColor: colorScheme.background,
                    indicatorColor: colorScheme.primary,
                    iconColor: colorScheme.onSecondary,
                    iconColorSelected: colorScheme.primary,
                    backspaceColor: colorScheme.primary,
                    skinToneDialogBgColor: Colors.white,
                    skinToneIndicatorColor: Colors.grey,
                    enableSkinTones: true,
                    recentTabBehavior: RecentTabBehavior.RECENT,
                    recentsLimit: 28,
                    replaceEmojiOnLimitExceed: false,
                    noRecents: const Text(
                      'Nenhum recente',
                      textAlign: TextAlign.center,
                    ),
                    loadingIndicator: const SizedBox.shrink(),
                    tabIndicatorAnimDuration: kTabScrollDuration,
                    categoryIcons: const CategoryIcons(),
                    buttonMode: ButtonMode.MATERIAL,
                    checkPlatformCompatibility: true,
                  ),
                )),
          ),
        ),
      ],
    );
  }
}
