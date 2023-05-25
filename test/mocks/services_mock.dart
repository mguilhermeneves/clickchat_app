import 'package:mocktail/mocktail.dart';

import 'package:clickchat_app/src/global/services/notification_service.dart';
import 'package:clickchat_app/src/global/services/auth_service.dart';

class AuthServiceMock extends Mock implements AuthService {}

class NotificationServiceMock extends Mock implements NotificationService {}
