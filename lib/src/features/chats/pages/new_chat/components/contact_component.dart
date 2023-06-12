import 'package:flutter/material.dart';

import 'package:clickchat_app/src/global/models/contact_model.dart';
import 'package:clickchat_app/src/global/widgets/avatar_widget.dart';

class ContactComponent extends StatelessWidget {
  final ContactModel contact;

  const ContactComponent(this.contact, {super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context).popAndPushNamed(
        '/chat-messages/new',
        arguments: contact.userId,
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
    );
  }
}
