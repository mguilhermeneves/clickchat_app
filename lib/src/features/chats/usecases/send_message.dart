import 'package:clickchat_app/src/global/exceptions/repository_exception.dart';
import 'package:clickchat_app/src/global/helpers/result.dart';
import 'package:clickchat_app/src/global/services/auth_service.dart';

import '../repositories/message_repository.dart';

abstract class ISendMessage {
  Future<Result> call(String chatId, String text);
}

class SendMessage implements ISendMessage {
  final IMessageRepository _messageRepository;
  final AuthService _authService;

  SendMessage(this._messageRepository, this._authService);

  @override
  Future<Result> call(String chatId, String text) async {
    if (!_authService.signedIn) {
      return Result.error('Sua conta está desconectada.');
    }

    if (chatId.isEmpty) {
      return Result.error('Chat ID inválido.');
    }

    if (text.isEmpty) {
      return Result.error('A mensagem não pode ser vazia.');
    }

    try {
      await _messageRepository.send(chatId, text, _authService.userId);

      return Result.ok();
    } on RepositoryException catch (_) {
      return Result.error(
        'Ocorreu um problema inesperado na base de dados ao enviar a mensagem. Aguarde alguns instantes e tente novamente.',
      );
    }
  }
}
