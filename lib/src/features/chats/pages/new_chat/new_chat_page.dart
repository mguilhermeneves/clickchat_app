import 'package:flutter/material.dart';

import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

import 'package:clickchat_app/src/global/helpers/app.dart';
import 'package:clickchat_app/src/global/widgets/messenger_widget.dart';
import 'package:clickchat_app/src/features/chats/pages/new_chat/new_chat_controller.dart';

import 'components/contact_component.dart';

class NewChatPage extends StatefulWidget {
  const NewChatPage({super.key});

  @override
  State<NewChatPage> createState() => _NewChatPageState();
}

class _NewChatPageState extends State<NewChatPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NewChatController>().init();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<NewChatController>();
    final state = controller.value;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nova mensagem'),
        leading: IconButton(
          onPressed: Navigator.of(context).pop,
          icon: const Icon(Iconsax.arrow_left),
        ),
        actions: [
          IconButton(
            onPressed: () => App.dialog.alert(
              'Função não implementada.',
            ),
            icon: const Icon(Iconsax.search_normal),
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
          if (state.isInitial) return Container();

          if (state.isLoading) {
            return const LinearProgressIndicator();
          }

          if (state.isError) {
            return Messenger.alert(state.asError.message);
          }

          return StreamBuilder(
            stream: state.asSuccess.contacts,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Messenger.alert(
                  'Ocorreu um problema inesperado na atualização em tempo real. Aguarde alguns instantes e tente novamente.',
                );
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container();
              }

              final contacts = snapshot.data;

              if (contacts?.isEmpty ?? true) {
                return const Messenger(
                  'Você não possui nenhum contato adicionado.',
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 10),
                itemCount: contacts!.length,
                itemBuilder: (_, index) {
                  return ContactComponent(contacts[index]);
                },
              );
            },
          );
        },
      ),
    );
  }
}
