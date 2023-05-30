import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../../../main.dart';
import '../constants/cloud_messasing_constant.dart';
import '../helpers/app.dart';
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
  StreamSubscription<String>? _onTokenRefreshSubscription;
  StreamSubscription<RemoteMessage>? _onMessageSubscription;
  StreamSubscription<RemoteMessage>? _onMessageOpenedAppSubscription;
  bool _notificationsInitialized = false;
  String? _chatId;

  NotificationService(this._authService, this._userRepository);

  Future<void> initialize() async {
    if (_notificationsInitialized) return;

    if (!await _hasPermission()) return;

    await _getToken();

    await _setupAndroidNotificationChannel();

    /// Atualize as opções de apresentação de notificação de foreground do iOS
    /// para permitir alerta as notificações.
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    await _configureInteractedMessage();

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

  /// Trata interações dos usuários com as notificações (pressionando-os)
  Future<void> _configureInteractedMessage() async {
    /// Obtém todas as mensagens que causaram a abertura do aplicativo de
    /// um estado finalizado.
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      _interactedMessageHandler(initialMessage);
    }

    _onMessageOpenedAppSubscription?.cancel();

    /// Também lida com qualquer interação quando o aplicativo está em segundo
    /// plano por meio de um ouvinte do stream.
    _onMessageOpenedAppSubscription =
        FirebaseMessaging.onMessageOpenedApp.listen(_interactedMessageHandler);
  }

  void _interactedMessageHandler(RemoteMessage message) {
    if (message.data['type'] == 'chat') {
      var userIdSender = message.data['userIdSender'];

      _toPageChat(userIdSender);
    }
  }

  /// Mostra notificações em segundo plano e quando o app está em estado terminado.
  void _configureBackground() {
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  }

  /// Mostra notificações em primeiro plano
  void _configureForeground() {
    _onMessageSubscription?.cancel();
    _onMessageSubscription =
        FirebaseMessaging.onMessage.listen(_showLocalNotificationAndroid);
  }

  void _showLocalNotificationAndroid(RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = notification?.android;

    if (notification == null || android == null) return;

    String? payload;

    if (message.data['type'] == 'chat') {
      /// Se [_chatId] e [message.data['chatId']] é igual, não mostra a
      /// notificação pq o usuário está na tela de mensagens do [chatId].
      if (_chatId != null && _chatId == message.data['chatId']) return;

      var userIdSender = message.data['userIdSender'];
      payload = '/chat-messages/user?$userIdSender';
    }

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
      payload: payload,
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

      _onTokenRefreshSubscription?.cancel();
      _onTokenRefreshSubscription =
          _messaging.onTokenRefresh.listen(_saveToken);
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
      onDidReceiveNotificationResponse: (response) {
        if (response.payload?.contains('/chat-messages/user?') ?? false) {
          var userIdSender =
              response.payload!.replaceAll('/chat-messages/user?', '');

          _toPageChat(userIdSender);
        }
      },
    );
  }

  void _toPageChat(String userIdSender) {
    if (_chatId != null) {
      App.to.pushReplacementNamed(
        '/chat-messages/user',
        arguments: userIdSender,
      );
    } else {
      App.to.pushNamed(
        '/chat-messages/user',
        arguments: userIdSender,
      );
    }
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

    _onTokenRefreshSubscription?.cancel();

    _onMessageSubscription?.cancel();

    _onMessageOpenedAppSubscription?.cancel();

    await _deleteToken();
  }
}
