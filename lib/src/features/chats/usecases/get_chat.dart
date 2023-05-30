import 'package:clickchat_app/src/global/exceptions/repository_exception.dart';
import 'package:clickchat_app/src/global/helpers/result_with.dart';
import 'package:clickchat_app/src/global/services/auth_service.dart';

import '../models/chat_model.dart';
import '../repositories/chat_repository.dart';

abstract class IGetChat {
  /// Retorna um chat existente. Caso não tenha um chat entre os usuários, é
  /// criado um.
  Future<ResultWith<ChatModel>> call(String userId);
}

class GetChat implements IGetChat {
  final IChatRepository _chatRepository;
  final AuthService _authService;

  GetChat(this._chatRepository, this._authService);

  @override
  Future<ResultWith<ChatModel>> call(String userId) async {
    if (!_authService.signedIn) {
      return ResultWith.error('Sua conta está desconectada.');
    }

    try {
      final chat = await _chatRepository.get(userId, _authService.userId);

      return ResultWith.ok(chat);
    } on RepositoryException catch (_) {
      return ResultWith.error(
        'Ocorreu um problema inesperado ao obter uma conversa na base de dados. Aguarde alguns instantes e tente novamente.',
      );
    }
  }
}
