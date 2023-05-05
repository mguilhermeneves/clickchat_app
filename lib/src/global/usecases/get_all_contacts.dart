import 'package:clickchat_app/src/global/models/contact_model.dart';
import 'package:clickchat_app/src/global/repositories/contact_repository.dart';
import 'package:clickchat_app/src/global/exceptions/repository_exception.dart';
import 'package:clickchat_app/src/global/helpers/result_with.dart';
import 'package:clickchat_app/src/global/services/auth_service.dart';

abstract class IGetAllContacts {
  ResultWith<Stream<List<ContactModel>>> call();
}

class GetAllContacts implements IGetAllContacts {
  final IContactRepository _contactRepository;
  final AuthService _authService;

  GetAllContacts(this._contactRepository, this._authService);

  @override
  ResultWith<Stream<List<ContactModel>>> call() {
    if (!_authService.signedIn) {
      return ResultWith.error('Sua conta está desconectada.');
    }

    try {
      final contacts = _contactRepository.getAll(_authService.userId);

      return ResultWith.ok(contacts);
    } on RepositoryException catch (_) {
      return ResultWith.error(
        'Ocorreu um problema inesperado ao buscar os contatos na base de dados. Aguarde alguns instantes e tente novamente.',
      );
    }
  }
}
