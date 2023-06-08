import 'package:clickchat_app/src/global/repositories/contact_repository.dart';
import 'package:clickchat_app/src/features/contacts/validators/contact_validator.dart';
import 'package:clickchat_app/src/global/exceptions/repository_exception.dart';
import 'package:clickchat_app/src/global/helpers/result.dart';
import 'package:clickchat_app/src/global/services/auth_service.dart';

abstract class IUpdateContact {
  Future<Result> call(String id, String name);
}

class UpdateContact implements IUpdateContact {
  final IContactRepository _contactRepository;
  final AuthService _authService;

  UpdateContact(this._contactRepository, this._authService);

  @override
  Future<Result> call(String id, String name) async {
    final String? nameValidation = ContactValidator.validateName(name);
    if (nameValidation != null) {
      return Result.error(nameValidation);
    }

    if (!_authService.signedIn) {
      return Result.error('Sua conta está desconectada.');
    }

    try {
      name = name.trim();

      await _contactRepository.update(id, name, _authService.userId);

      return Result.ok();
    } on RepositoryException catch (_) {
      return Result.error(
        'Ocorreu um problema inesperado ao atualizar o nome do contato na base de dados. Aguarde alguns instantes e tente novamente.',
      );
    }
  }
}
