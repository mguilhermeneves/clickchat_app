import 'package:clickchat_app/src/global/repositories/user_repository.dart';

import '../exceptions/repository_exception.dart';
import '../helpers/result_with.dart';
import '../models/user_model.dart';

abstract class IGetUserByEmail {
  Future<ResultWith<UserModel?>> call(String email);
}

class GetUserByEmail implements IGetUserByEmail {
  final IUserRepository _userRepository;

  GetUserByEmail(this._userRepository);

  @override
  Future<ResultWith<UserModel?>> call(String email) async {
    try {
      final UserModel? user = await _userRepository.getByEmail(email);

      return ResultWith.ok(user);
    } on RepositoryException catch (_) {
      return ResultWith.error(
        'Ocorreu um problema inesperado ao buscar o usuário por e-mail na base de dados. Aguarde alguns instantes e tente novamente.',
      );
    }
  }
}
