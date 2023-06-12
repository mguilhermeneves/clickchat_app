import 'package:clickchat_app/src/features/contacts/pages/contacts/components/details_contact_component.dart';
import 'package:flutter/material.dart';

import 'package:clickchat_app/src/global/widgets/avatar_widget.dart';

import '../../../../../global/models/contact_model.dart';

class ContactComponent extends StatelessWidget {
  final ContactModel contact;

  const ContactComponent(this.contact, {super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final borderRadius = BorderRadius.circular(15);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: borderRadius,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: borderRadius,
          onTap: () => showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (_) => DetailsContactComponent(contact),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: Row(
              children: [
                Avatar(
                  letter: contact.name!,
                  imageUrl: contact.userProfilePictureUrl,
                  size: 20,
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Text(
                    contact.name!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium,
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
