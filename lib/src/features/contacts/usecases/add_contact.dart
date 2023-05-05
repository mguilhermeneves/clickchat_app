import 'package:clickchat_app/src/global/models/contact_model.dart';
import 'package:clickchat_app/src/global/repositories/contact_repository.dart';
import 'package:clickchat_app/src/features/contacts/validators/contact_validator.dart';
import 'package:clickchat_app/src/global/exceptions/repository_exception.dart';
import 'package:clickchat_app/src/global/helpers/result.dart';
import 'package:clickchat_app/src/global/models/user_model.dart';
import 'package:clickchat_app/src/global/repositories/user_repository.dart';
import 'package:clickchat_app/src/global/services/auth_service.dart';

abstract class IAddContact {
  Future<Result> call(ContactModel contact);
}

class AddContact implements IAddContact {
  final IContactRepository _contactRepository;
  final IUserRepository _userRepository;
  final AuthService _authService;

  AddContact(this._contactRepository, this._userRepository, this._authService);

  @override
  Future<Result> call(ContactModel contact) async {
    final Result result = ContactValidator.validate(contact);
    if (!result.succeeded) return result;

    if (!_authService.signedIn) {
      return Result.error('Sua conta está desconectada.');
    }

    try {
      contact.name = contact.name?.trim();
      contact.email = contact.email?.trim().toLowerCase();

      final UserModel? user = await _userRepository.getByEmail(contact.email!);
      if (user == null) {
        return Result.error('Não existe uma conta criada com esse e-mail.');
      }

      final ContactModel? contactAdded =
          await _contactRepository.getByUserId(user.id, _authService.userId);
      if (contactAdded != null) {
        return Result.error('Esse contato já foi adicionado.');
      }

      contact.userId = user.id;

      await _contactRepository.add(contact, _authService.userId);

      return Result.ok();
    } on RepositoryException catch (_) {
      return Result.error(
        'Ocorreu um problema inesperado ao adicionar o contato na base de dados. Aguarde alguns instantes e tente novamente.',
      );
    }
  }
}
