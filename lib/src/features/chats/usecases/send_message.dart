import 'package:clickchat_app/src/global/exceptions/repository_exception.dart';
import 'package:clickchat_app/src/global/helpers/result.dart';
import 'package:clickchat_app/src/global/repositories/user_repository.dart';
import 'package:clickchat_app/src/global/services/auth_service.dart';
import 'package:clickchat_app/src/global/services/notification_service.dart';

import '../models/chat_model.dart';
import '../repositories/message_repository.dart';

abstract class ISendMessage {
  Future<Result> call(ChatModel chat, String text);
}

class SendMessage implements ISendMessage {
  final IMessageRepository _messageRepository;
  final IUserRepository _userRepository;
  final NotificationService _notificationService;
  final AuthService _authService;

  SendMessage(
    this._messageRepository,
    this._userRepository,
    this._notificationService,
    this._authService,
  );

  @override
  Future<Result> call(ChatModel chat, String text) async {
    if (!_authService.signedIn) {
      return Result.error('Sua conta está desconectada.');
    }

    if (chat.id.isEmpty) {
      return Result.error('Chat ID inválido.');
    }

    if (text.isEmpty) {
      return Result.error('A mensagem não pode ser vazia.');
    }

    try {
      await _messageRepository.send(chat.id, text, _authService.userId);

      String userId;
      if (chat.usersId[0] == _authService.userId) {
        userId = chat.usersId[1];
      } else {
        userId = chat.usersId[0];
      }

      var tokens = await _userRepository.getTokens(userId);
      if (tokens.isNotEmpty) {
        _notificationService.sendNotification(
          title: _authService.user!.displayName!,
          body: text,
          tokens: tokens,
          data: {'chatId': chat.id},
        );
      }

      return Result.ok();
    } on RepositoryException catch (_) {
      return Result.error(
        'Ocorreu um problema inesperado na base de dados ao enviar a mensagem. Aguarde alguns instantes e tente novamente.',
      );
    }
  }
}
