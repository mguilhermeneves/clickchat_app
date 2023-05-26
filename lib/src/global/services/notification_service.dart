import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../../../main.dart';
import '../constants/cloud_messasing_constant.dart';
import '../helpers/result.dart';
import '../helpers/value_disposable.dart';
import '../repositories/user_repository.dart';
import 'auth_service.dart';

class NotificationService implements ValueDisposable {
  final AuthService _authService;
  final IUserRepository _userRepository;
  final _messaging = FirebaseMessaging.instance;
  late FlutterLocalNotificationsPlugin _localNotificationsPlugin;
  late AndroidNotificationChannel _channel;
  StreamSubscription<String>? _onTokenRefresh;
  StreamSubscription<RemoteMessage>? _onMessage;
  bool _notificationsInitialized = false;
  String? _chatId;

  NotificationService(this._authService, this._userRepository);

  Future<void> initialize() async {
    if (_notificationsInitialized) return;

    if (!await _hasPermission()) return;

    await _getToken();

    await _setupAndroidNotificationChannel();

    /// Atualize as opções de apresentação de notificação de foreground do iOS para permitir
    /// alerta as notificações.
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    _configureBackground();

    _configureForeground();

    _notificationsInitialized = true;
  }

  /// O [chatId] definido, não vai mostrar notificação. (Esse método é chamado
  /// na tela de mensagens, para que o usuário não receba notificação enquanto
  /// está vendo as mensagens em tempo real.)
  void setChatId(String? chatId) => _chatId = chatId;

  Future<Result> sendNotification({
    required String title,
    required String body,
    required List<String> tokens,
    Map<String, dynamic>? data,
  }) async {
    try {
      if (tokens.isEmpty || tokens.length > 1000) {
        return Result.error(
          'Para enviar a notificação push, psrecisa informar pelo menos 1 e no máximo 1.000 tokens de registro',
        );
      }

      Response response = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'key=${CloudMessasingConstant.token}'
        },
        body: jsonEncode({
          "registration_ids": tokens,
          "notification": {
            "title": title,
            "body": body,
          },
          "data": data,
        }),
      );

      if (response.statusCode == 200) return Result.ok();

      return Result.error(
        'Ocorreu um problema ao enviar uma notificação push, status code: ${response.statusCode}. Aguarde alguns instantes e tente novamente.',
      );
    } catch (e) {
      return Result.error(
        'Ocorreu um problema inesperado ao enviar uma notificação push. Aguarde alguns instantes e tente novamente.',
      );
    }
  }

  void _configureBackground() {
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  }

  void _configureForeground() {
    _onMessage?.cancel();
    _onMessage = FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) async {
        _showLocalNotificationAndroid(message);

        print("=====================Foreground=========================");
        print(message.notification?.title);
        print(message.notification?.body);
        print("========================================================");
      },
    );
  }

  void _showLocalNotificationAndroid(RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = notification?.android;

    if (notification == null || android == null) return;

    var chatId = message.data['chatId'];

    /// Se [_chatId] e [chatId] é igual, não mostra a notificação pq o usuário
    /// está na tela de mensagens do [chatId].
    if (_chatId != null && _chatId == chatId) return;

    _localNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _channel.id,
          _channel.name,
          channelDescription: _channel.description,
          icon: android.smallIcon,
        ),
      ),
    );
  }

  Future<bool> _hasPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    return settings.authorizationStatus == AuthorizationStatus.authorized;
  }

  Future<void> _getToken() async {
    try {
      String? token = await _messaging.getToken();

      await _saveToken(token);

      _onTokenRefresh?.cancel();
      _onTokenRefresh = _messaging.onTokenRefresh.listen(_saveToken);

      print("=====================Token=========================");
      print(token);
      print("===================================================");
    } catch (e) {
      // TODO: Tratar erro ao obter token
    }
  }

  Future<void> _saveToken(String? token) async {
    if (token == null || token.isEmpty || !_authService.signedIn) return;

    await _userRepository.saveToken(token, _authService.userId);
  }

  Future<void> _setupAndroidNotificationChannel() async {
    _channel = const AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.max,
    );

    _localNotificationsPlugin = FlutterLocalNotificationsPlugin();

    /// Cria um canal de notificação do Android.
    /// Usamos este canal no arquivo `AndroidManifest.xml` para substituir o
    /// canal FCM padrão para habilitar notificações heads-up.
    await _localNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);

    await _localNotificationsPlugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      ),
    );
  }

  Future<void> _deleteToken() async {
    try {
      String? token = await _messaging.getToken();

      if (token != null && _authService.signedIn) {
        await _userRepository.deleteToken(token, _authService.userId);
      }

      await _messaging.deleteToken();
    } catch (e) {
      // TODO: Tratar erro ao excluir token.
    }
  }

  @override
  Future<void> disposeValue() async {
    _notificationsInitialized = false;
    _onTokenRefresh?.cancel();
    _onMessage?.cancel();
    await _deleteToken();
  }
}
