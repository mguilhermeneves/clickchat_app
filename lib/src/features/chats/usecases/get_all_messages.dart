import 'package:clickchat_app/src/global/exceptions/repository_exception.dart';
import 'package:clickchat_app/src/global/helpers/result_with.dart';
import 'package:clickchat_app/src/global/services/auth_service.dart';

import '../models/message_model.dart';
import '../repositories/message_repository.dart';

abstract class IGetAllMessages {
  Future<ResultWith<Stream<List<MessageModel>>>> call(String chatId, int limit);
}

class GetAllMessages implements IGetAllMessages {
  final IMessageRepository _messageRepository;
  final AuthService _authService;

  GetAllMessages(this._messageRepository, this._authService);

  @override
  Future<ResultWith<Stream<List<MessageModel>>>> call(
      String chatId, int limit) async {
    if (!_authService.signedIn) {
      return ResultWith.error('Sua conta está desconectada.');
    }

    if (chatId.isEmpty) {
      return ResultWith.error('Chat ID inválido.');
    }

    try {
      final messages =
          await _messageRepository.getAll(chatId, _authService.userId, limit);

      return ResultWith.ok(messages);
    } on RepositoryException catch (_) {
      return ResultWith.error(
        'Ocorreu um problema inesperado ao buscar as mensagens na base de dados. Aguarde alguns instantes e tente novamente.',
      );
    }
  }
}
