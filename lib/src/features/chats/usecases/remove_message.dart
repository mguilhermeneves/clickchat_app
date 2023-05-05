import 'package:clickchat_app/src/global/exceptions/repository_exception.dart';
import 'package:clickchat_app/src/global/helpers/result.dart';
import 'package:clickchat_app/src/global/services/auth_service.dart';

import '../repositories/message_repository.dart';

abstract class IRemoveMessage {
  Future<Result> call(String chatId, String messageId);
}

class RemoveMessage implements IRemoveMessage {
  final IMessageRepository _messageRepository;
  final AuthService _authService;

  RemoveMessage(this._messageRepository, this._authService);

  @override
  Future<Result> call(String chatId, String messageId) async {
    if (!_authService.signedIn) {
      return Result.error('Sua conta está desconectada.');
    }

    try {
      await _messageRepository.remove(chatId, messageId, _authService.userId);

      return Result.ok();
    } on RepositoryException catch (_) {
      return Result.error(
        'Ocorreu um problema inesperado ao remover a mensagem na base de dados. Aguarde alguns instantes e tente novamente.',
      );
    }
  }
}
