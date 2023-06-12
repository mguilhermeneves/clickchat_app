import 'dart:io';

import 'package:clickchat_app/src/global/repositories/user_repository.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../helpers/result.dart';
import '../helpers/result_with.dart';

class StorageService {
  final _storageRef = FirebaseStorage.instance.ref();
  final IUserRepository _userRepository;

  StorageService(this._userRepository);

  Future<ResultWith<String>> uploadProfilePicture(
      String path, String? userId) async {
    if (userId == null) {
      return ResultWith.error('Não informado o ID do usuário.');
    }

    final file = File(path);

    final pictureRef = _storageRef.child('pictures/$userId.jpg');

    try {
      await pictureRef.putFile(file);

      final String profilePictureUrl = await pictureRef.getDownloadURL();

      await _userRepository.setProfilePicture(profilePictureUrl, userId);

      return ResultWith.ok(profilePictureUrl);
    } catch (_) {
      return ResultWith.error(
          'Ocorreu um problema inesperado ao salvar a foto. Aguarde alguns instantes e tente novamente.');
    }
  }

  Future<Result> deleteProfilePicture(String? userId) async {
    if (userId == null) {
      return Result.error('Não informado o ID do usuário.');
    }

    try {
      final String? profilePictureUrl =
          await _userRepository.getProfilePicture(userId);

      if (profilePictureUrl == null) return Result.ok();

      final pictureRef = _storageRef.child('pictures/$userId.jpg');
      await pictureRef.delete();

      await _userRepository.setProfilePicture(null, userId);

      return Result.ok();
    } catch (_) {
      return Result.error(
          'Ocorreu um problema inesperado ao remover a foto. Aguarde alguns instantes e tente novamente.');
    }
  }

  Future<ResultWith<String?>> getProfilePicture(String? userId) async {
    if (userId == null) {
      return ResultWith.error('Não informado o ID do usuário.');
    }

    try {
      final String? profilePictureUrl =
          await _userRepository.getProfilePicture(userId);

      return ResultWith.ok(profilePictureUrl);
    } catch (_) {
      return ResultWith.error(
          'Ocorreu um problema inesperado ao obter a foto. Aguarde alguns instantes e tente novamente.');
    }
  }
}
