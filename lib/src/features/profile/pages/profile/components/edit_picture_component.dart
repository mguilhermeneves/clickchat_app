import 'package:flutter/material.dart';

import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'package:clickchat_app/src/features/profile/pages/profile/profile_controller.dart';
import 'package:clickchat_app/src/global/theme/extensions/text_button_extension.dart';
import 'package:clickchat_app/src/global/widgets/action_button_widget.dart';

class EditPictureComponent extends StatefulWidget {
  const EditPictureComponent({super.key});

  @override
  State<EditPictureComponent> createState() => _EditPictureComponentState();
}

class _EditPictureComponentState extends State<EditPictureComponent> {
  @override
  Widget build(BuildContext context) {
    final controller = context.read<ProfileController>();
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              Text(
                'Editar foto do perfil',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const Spacer(),
              TextButton(
                onPressed: Navigator.of(context).pop,
                child: const Text('Cancelar'),
              ).compact(),
            ],
          ),
        ),
        Divider(
          thickness: 1,
          height: 1,
          color: colorScheme.outline,
        ),
        Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              ActionButton(
                iconData: Iconsax.camera,
                labelText: 'Tirar foto',
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(15)),
                onTap: () => controller.pickPicture(ImageSource.camera),
              ),
              Divider(height: 1, thickness: 1, color: colorScheme.outline),
              ActionButton(
                iconData: Iconsax.gallery,
                labelText: 'Selecionar foto da galeria',
                borderRadius:
                    const BorderRadius.vertical(bottom: Radius.circular(15)),
                onTap: () => controller.pickPicture(ImageSource.gallery),
              ),
              ValueListenableBuilder(
                  valueListenable: controller.profilePictureUrl,
                  builder: (_, profilePictureUrl, child) {
                    if (profilePictureUrl == null) return Container();

                    return Column(
                      children: [
                        const SizedBox(height: 15),
                        ActionButton(
                          iconData: Iconsax.trash,
                          labelText: 'Remover foto',
                          color: colorScheme.error,
                          onTap: controller.deletePicture,
                        ),
                      ],
                    );
                  }),
            ],
          ),
        ),
      ],
    );
  }
}
