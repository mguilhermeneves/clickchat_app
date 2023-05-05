import 'package:clickchat_app/src/global/exceptions/repository_exception.dart';
import 'package:clickchat_app/src/global/helpers/result_with.dart';
import 'package:clickchat_app/src/global/services/auth_service.dart';

import '../models/chat_model.dart';
import '../repositories/chat_repository.dart';

abstract class IGetAllChats {
  ResultWith<Stream<List<ChatModel>>> call();
}

class GetAllChats implements IGetAllChats {
  final IChatRepository _chatRepository;
  final AuthService _authService;

  GetAllChats(this._chatRepository, this._authService);

  @override
  ResultWith<Stream<List<ChatModel>>> call() {
    if (!_authService.signedIn) {
      return ResultWith.error('Sua conta está desconectada.');
    }

    try {
      final chats = _chatRepository.getAll(_authService.userId);

      return ResultWith.ok(chats);
    } on RepositoryException catch (_) {
      return ResultWith.error(
        'Ocorreu um problema inesperado ao buscar as conversas na base de dados. Aguarde alguns instantes e tente novamente.',
      );
    }
  }
}
