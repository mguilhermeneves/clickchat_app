import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

import 'package:clickchat_app/src/features/contacts/pages/contacts/components/add_contact_component.dart';
import 'package:clickchat_app/src/global/helpers/app.dart';
import 'package:clickchat_app/src/global/widgets/messenger_widget.dart';

import 'components/contact_component.dart';
import 'contacts_controller.dart';

class ContactsPage extends StatefulWidget {
  final double bottomNavigationBarHeight;

  const ContactsPage({
    super.key,
    required this.bottomNavigationBarHeight,
  });

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ContactsController>().init();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ContactsController>();
    final state = controller.value;
    final colorScheme = Theme.of(context).colorScheme;

    if (state.isInitial) return Container();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Contatos'),
        systemOverlayStyle: SystemUiOverlayStyle(
          systemNavigationBarColor: colorScheme.onBackground,
        ),
        actions: [
          IconButton(
            onPressed: () => App.dialog.alert(
              'Função não implementada.',
            ),
            icon: const Icon(Iconsax.search_normal),
          ),
          IconButton(
            onPressed: () => showModalBottomSheet(
              isScrollControlled: true,
              context: context,
              builder: (_) => const AddContactComponent(),
            ),
            icon: const Icon(Iconsax.profile_add),
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
                padding: EdgeInsets.only(
                  top: 10,
                  bottom: 10 + widget.bottomNavigationBarHeight,
                ),
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
