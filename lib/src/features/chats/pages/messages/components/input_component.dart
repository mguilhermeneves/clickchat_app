import 'package:flutter/material.dart';

import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

import 'package:clickchat_app/src/global/theme/extensions/circular_progress_indicator_extension.dart';
import 'package:clickchat_app/src/global/theme/extensions/floating_action_button_extension.dart';

import '../messages_controller.dart';

class InputComponent extends StatefulWidget {
  const InputComponent({super.key});

  @override
  State<InputComponent> createState() => _InputComponentState();
}

class _InputComponentState extends State<InputComponent> {
  final textController = TextEditingController();

  Future<void> onPressedSend() async {
    if (textController.text.isEmpty) return;

    final sent =
        await context.read<MessagesController>().send(textController.text);
    if (sent) {
      textController.clear();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.read<MessagesController>();
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
          border:
              Border(top: BorderSide(width: 1, color: colorScheme.outline))),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: textController,
              minLines: 1,
              maxLines: 4,
              keyboardType: TextInputType.multiline,
              textAlignVertical: TextAlignVertical.center,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.emoji_emotions_outlined),
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
            child: textController.text.isEmpty
                ? Container()
                : ValueListenableBuilder(
                    valueListenable: controller.sendLoading,
                    builder: (context, loading, child) {
                      return SizedBox(
                        height: 48,
                        width: 48,
                        child: FloatingActionButton(
                          onPressed: onPressedSend,
                          child: loading
                              ? const CircularProgressIndicator()
                                  .elevatedButton()
                              : const Icon(Iconsax.send_2),
                        ).gradient(),
                      );
                    }),
          ),
        ],
      ),
    );
  }
}
