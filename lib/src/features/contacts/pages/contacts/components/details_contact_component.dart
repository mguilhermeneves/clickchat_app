import 'package:flutter/material.dart';

import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

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
                imageUrl: widget.contact.userImageUrl,
                backgroundColor: colorScheme.onSurface,
                size: 27,
              ),
              const SizedBox(width: 15),
              Column(
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
            ],
          ),
          const SizedBox(height: 30),
          _buildAction(
            iconData: Iconsax.message_text_1,
            labelText: 'Enviar mensagem',
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed(
                '/page',
                arguments: 0,
              );
              Navigator.of(context).pushNamed(
                '/chat-messages/new',
                arguments: widget.contact.userId,
              );
            },
          ),
          const SizedBox(height: 15),
          Column(
            children: [
              _buildAction(
                iconData: Iconsax.edit_2,
                labelText: 'Editar apelido',
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(15)),
                onTap: () {},
              ),
              Divider(height: 1, thickness: 1, color: colorScheme.outline),
              ValueListenableBuilder(
                valueListenable: controller.deleteLoading,
                builder: (_, loading, child) => _buildAction(
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

  Widget _buildAction({
    required IconData iconData,
    required String labelText,
    BorderRadius borderRadius = const BorderRadius.all(Radius.circular(15)),
    void Function()? onTap,
    Color? color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: borderRadius,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: borderRadius,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 15,
            ),
            child: Row(
              children: [
                Icon(iconData, color: color),
                const SizedBox(width: 15),
                Text(
                  labelText,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: color,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
