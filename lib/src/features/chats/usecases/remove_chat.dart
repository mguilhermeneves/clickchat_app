import 'package:clickchat_app/src/global/exceptions/repository_exception.dart';
import 'package:clickchat_app/src/global/helpers/result.dart';
import 'package:clickchat_app/src/global/services/auth_service.dart';

import '../repositories/chat_repository.dart';

abstract class IRemoveChat {
  Future<Result> call(String chatId);
}

class RemoveChat implements IRemoveChat {
  final IChatRepository _chatRepository;
  final AuthService _authService;

  RemoveChat(this._chatRepository, this._authService);

  @override
  Future<Result> call(String chatId) async {
    if (!_authService.signedIn) {
      return Result.error('Sua conta está desconectada.');
    }

    try {
      await _chatRepository.remove(chatId, _authService.userId);

      return Result.ok();
    } on RepositoryException catch (_) {
      return Result.error(
        'Ocorreu um problema inesperado ao remover o chat na base de dados. Aguarde alguns instantes e tente novamente.',
      );
    }
  }
}
