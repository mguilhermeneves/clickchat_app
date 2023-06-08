import 'package:flutter/material.dart';

import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

import 'package:clickchat_app/src/global/theme/extensions/text_button_extension.dart';
import 'package:clickchat_app/src/features/contacts/pages/contacts/contacts_controller.dart';
import 'package:clickchat_app/src/features/contacts/validators/contact_validator.dart';
import 'package:clickchat_app/src/global/theme/extensions/circular_progress_indicator_extension.dart';
import 'package:clickchat_app/src/global/theme/extensions/elevated_button_extension.dart';

class EditNameComponent extends StatefulWidget {
  final String id;
  final String name;

  const EditNameComponent({
    super.key,
    required this.id,
    required this.name,
  });

  @override
  State<EditNameComponent> createState() => _EditNameComponentState();
}

class _EditNameComponentState extends State<EditNameComponent> {
  final formKey = GlobalKey<FormState>();
  late String? name = widget.name;

  @override
  Widget build(BuildContext context) {
    final controller = context.read<ContactsController>();

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
                    'Editar nome',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const Spacer(),
                  ValueListenableBuilder(
                    valueListenable: controller.editLoading,
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
              color: Theme.of(context).colorScheme.outline,
            ),
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      initialValue: name,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Iconsax.user),
                        labelText: 'Nome',
                        hintText: 'Digite o nome',
                      ),
                      keyboardType: TextInputType.name,
                      textCapitalization: TextCapitalization.words,
                      validator: ContactValidator.validateName,
                      onSaved: (value) => name = value,
                    ),
                    const SizedBox(height: 30),
                    ValueListenableBuilder(
                      valueListenable: controller.editLoading,
                      builder: (_, loading, child) => SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: loading
                              ? () {}
                              : () async {
                                  if (formKey.currentState!.validate()) {
                                    formKey.currentState!.save();

                                    await controller.update(widget.id, name!);
                                  }
                                },
                          child: loading
                              ? const CircularProgressIndicator()
                                  .elevatedButton()
                              : const Text('Salvar'),
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
