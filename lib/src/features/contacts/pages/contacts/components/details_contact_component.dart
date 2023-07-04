import 'package:flutter/material.dart';

import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

import 'package:clickchat_app/src/app_controller.dart';
import 'package:clickchat_app/src/features/contacts/pages/contacts/components/edit_name_component.dart';
import 'package:clickchat_app/src/global/widgets/action_button_widget.dart';
import 'package:clickchat_app/src/global/widgets/avatar_widget.dart';

import '../../../../../global/models/contact_model.dart';
import '../contacts_controller.dart';

class DetailsContactComponent extends StatefulWidget {
  final ContactModel contact;

  const DetailsContactComponent(this.contact, {Key? key}) : super(key: key);

  @override
  State<DetailsContactComponent> createState() =>
      _DetailsContactComponentState();
}

class _DetailsContactComponentState extends State<DetailsContactComponent> {
  @override
  Widget build(BuildContext context) {
    final controller = context.read<ContactsController>();
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 5,
            decoration: BoxDecoration(
              color: colorScheme.onSecondary,
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Avatar(
                letter: widget.contact.name!,
                imageUrl: widget.contact.userProfilePictureUrl,
                backgroundColor: colorScheme.onSurface,
                size: 27,
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.contact.name!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text(
                      widget.contact.email!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          ActionButton(
            iconData: Iconsax.message_text_1,
            labelText: 'Enviar mensagem',
            onTap: () async {
              Navigator.of(context).popAndPushNamed(
                '/chat-messages/new',
                arguments: widget.contact.userId,
              );

              context.read<AppController>().jumpToPage(AppPageView.chats);
            },
          ),
          const SizedBox(height: 15),
          Column(
            children: [
              ActionButton(
                iconData: Iconsax.edit_2,
                labelText: 'Editar nome',
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(15)),
                onTap: () {
                  Navigator.pop(context);
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (_) => EditNameComponent(
                      id: widget.contact.id!,
                      name: widget.contact.name!,
                    ),
                  );
                },
              ),
              Divider(height: 1, thickness: 1, color: colorScheme.outline),
              ValueListenableBuilder(
                valueListenable: controller.deleteLoading,
                builder: (_, loading, child) => ActionButton(
                  iconData: Iconsax.trash,
                  labelText: loading ? 'Excluindo...' : 'Excluir',
                  color: colorScheme.error,
                  borderRadius:
                      const BorderRadius.vertical(bottom: Radius.circular(15)),
                  onTap: () => controller.delete(widget.contact.id!),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
