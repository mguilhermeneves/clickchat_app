import 'package:clickchat_app/src/features/contacts/repositories/contact_repository.dart';
import 'package:clickchat_app/src/global/exceptions/repository_exception.dart';
import 'package:clickchat_app/src/global/helpers/result.dart';
import 'package:clickchat_app/src/global/services/auth_service.dart';

abstract class IDeleteContact {
  Future<Result> call(String id);
}

class DeleteContact implements IDeleteContact {
  final IContactRepository _contactRepository;
  final AuthService _authService;

  DeleteContact(this._contactRepository, this._authService);

  @override
  Future<Result> call(String id) async {
    if (!_authService.signedIn) {
      return Result.error('Sua conta está desconectada.');
    }

    try {
      await _contactRepository.delete(id, _authService.userId);

      return Result.ok();
    } on RepositoryException catch (_) {
      return Result.error(
        'Ocorreu um problema inesperado ao excluir contato na base de dados. Aguarde alguns instantes e tente novamente.',
      );
    }
  }
}
