import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

import 'package:clickchat_app/src/global/helpers/app.dart';
import 'package:clickchat_app/src/features/profile/pages/profile/components/edit_picture_component.dart';
import 'package:clickchat_app/src/features/profile/pages/profile/profile_controller.dart';
import 'package:clickchat_app/src/global/theme/extensions/icon_button_extension.dart';
import 'package:clickchat_app/src/global/widgets/action_button_widget.dart';
import 'package:clickchat_app/src/global/widgets/avatar_widget.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    context.read<ProfileController>().init();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.read<ProfileController>();
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        systemOverlayStyle: SystemUiOverlayStyle(
          systemNavigationBarColor: colorScheme.onBackground,
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: colorScheme.outline,
            height: 1,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 15),
            Stack(
              children: [
                ValueListenableBuilder(
                  valueListenable: controller.profilePictureLoading,
                  builder: (_, loading, child) {
                    return Avatar(
                      letter: controller.user?.displayName ?? '',
                      imageUrl: controller.profilePictureUrl,
                      isLoading: loading,
                      size: 50,
                    );
                  },
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: SizedBox(
                    width: 35,
                    height: 35,
                    child: IconButton(
                      onPressed: () => showModalBottomSheet(
                        context: context,
                        builder: (_) => const EditPictureComponent(),
                      ),
                      icon: const Icon(
                        Iconsax.camera,
                        size: 18,
                      ),
                    ).gradient(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Text(
              controller.user?.displayName ?? '',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 5),
            Text(
              controller.user?.email ?? '',
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(height: 30),
            ActionButton(
              iconData: Iconsax.edit_2,
              labelText: 'Editar nome',
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(15)),
              onTap: () => App.dialog.alert(
                'Função não implementada.',
              ),
            ),
            Divider(height: 1, thickness: 1, color: colorScheme.outline),
            ValueListenableBuilder(
              valueListenable: controller.signOutLoading,
              builder: (context, loading, widget) {
                return ActionButton(
                  iconData: Iconsax.logout,
                  labelText: loading ? 'Saindo...' : 'Sair',
                  color: colorScheme.error,
                  borderRadius:
                      const BorderRadius.vertical(bottom: Radius.circular(15)),
                  onTap: loading ? () {} : () => controller.signOut(context),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
