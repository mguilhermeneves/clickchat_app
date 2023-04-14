import 'package:provider/provider.dart';

import 'pages/login/login_controller.dart';
import 'pages/signup/signup_controller.dart';
import 'stores/login_store.dart';
import 'stores/signup_store.dart';

final authProvider = [
  ChangeNotifierProvider(
    create: (context) => SignupStore(context.read()),
  ),
  ChangeNotifierProvider(
    create: (context) => LoginStore(context.read()),
  ),
  Provider(
    create: (context) => SignupController(context.read()),
  ),
  Provider(create: (context) => LoginController(context.read())),
];
