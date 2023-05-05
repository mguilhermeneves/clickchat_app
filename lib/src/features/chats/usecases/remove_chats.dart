import 'package:clickchat_app/src/global/exceptions/repository_exception.dart';
import 'package:clickchat_app/src/global/helpers/result.dart';
import 'package:clickchat_app/src/global/services/auth_service.dart';

import '../repositories/chat_repository.dart';

abstract class IRemoveChats {
  Future<Result> call(List<String> chatsId);
}

class RemoveChats implements IRemoveChats {
  final IChatRepository _chatRepository;
  final AuthService _authService;

  RemoveChats(this._chatRepository, this._authService);

  @override
  Future<Result> call(List<String> chatsId) async {
    if (!_authService.signedIn) {
      return Result.error('Sua conta está desconectada.');
    }

    if (chatsId.isEmpty) {
      return Result.error('Informe pelo menos 1 chat para remover.');
    }

    try {
      for (var chatId in chatsId) {
        await _chatRepository.remove(chatId, _authService.userId);
      }

      return Result.ok();
    } on RepositoryException catch (_) {
      return Result.error(
        'Ocorreu um problema inesperado ao remover o chat na base de dados. Aguarde alguns instantes e tente novamente.',
      );
    }
  }
}
