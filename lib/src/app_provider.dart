import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import 'global/repositories/user_repository.dart';
import 'global/services/auth_service.dart';

final appProvider = [
  Provider<FirebaseFirestore>.value(value: FirebaseFirestore.instance),
  Provider<IUserRepository>(
    create: (context) => UserRepository(context.read()),
  ),
  ChangeNotifierProvider(create: (context) => AuthService(context.read())),
];
