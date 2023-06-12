import 'package:provider/provider.dart';

import 'package:clickchat_app/src/features/profile/pages/profile/profile_controller.dart';
import 'package:clickchat_app/src/global/services/storage_service.dart';

final profileProvider = [
  Provider<StorageService>(
    create: (context) => StorageService(context.read()),
  ),
  Provider<ProfileController>(
    create: (context) => ProfileController(context.read(), context.read()),
  ),
];
