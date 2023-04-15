import 'package:clickchat_app/src/global/theme/extensions/text_button_extension.dart';
import 'package:flutter/material.dart';

import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

import 'package:clickchat_app/src/global/models/contact_model.dart';
import 'package:clickchat_app/src/features/contacts/pages/contacts/contacts_controller.dart';
import 'package:clickchat_app/src/features/contacts/validators/contact_validator.dart';
import 'package:clickchat_app/src/global/theme/extensions/circular_progress_indicator_extension.dart';
import 'package:clickchat_app/src/global/theme/extensions/elevated_button_extension.dart';

class AddContactComponent extends StatefulWidget {
  const AddContactComponent({super.key});

  @override
  State<AddContactComponent> createState() => _AddContactComponentState();
}

class _AddContactComponentState extends State<AddContactComponent> {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final controller = context.read<ContactsController>();
    final contact = ContactModel();

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                children: [
                  Text(
                    'Adicionar contato',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const Spacer(),
                  ValueListenableBuilder(
                    valueListenable: controller.addLoading,
                    builder: (_, loading, child) => TextButton(
                      onPressed: loading ? null : Navigator.of(context).pop,
                      child: const Text('Cancelar'),
                    ).compact(),
                  ),
                ],
              ),
            ),
            Divider(
              thickness: 1,
              height: 1,
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Iconsax.user),
                        labelText: 'Nome',
                        hintText: 'Digite o nome',
                      ),
                      keyboardType: TextInputType.name,
                      textCapitalization: TextCapitalization.words,
                      validator: ContactValidator.validateName,
                      onSaved: (value) => contact.name = value,
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Iconsax.sms),
                        labelText: 'E-mail',
                        hintText: 'Digite o e-mail',
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: ContactValidator.validateEmail,
                      onSaved: (value) => contact.email = value,
                    ),
                    const SizedBox(height: 30),
                    ValueListenableBuilder(
                      valueListenable: controller.addLoading,
                      builder: (_, loading, child) => SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: loading
                              ? () {}
                              : () async {
                                  if (formKey.currentState!.validate()) {
                                    formKey.currentState!.save();

                                    await controller.add(contact);
                                  }
                                },
                          child: loading
                              ? const CircularProgressIndicator()
                                  .elevatedButton()
                              : const Text('Adicionar'),
                        ).gradient(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
