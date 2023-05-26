import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:clickchat_app/src/global/models/user_model.dart';
import 'package:clickchat_app/src/global/repositories/user_repository.dart';

import '../../app_provider.dart';
import '../helpers/app.dart';
import '../helpers/result.dart';

class AuthService extends ChangeNotifier {
  final _auth = FirebaseAuth.instance;
  final IUserRepository _userRepository;
  User? user;
  bool get signedIn => user != null;
  String get userId => user?.uid ?? '';

  AuthService(this._userRepository) {
    _auth.authStateChanges().listen((User? userChanges) {
      user = userChanges;
      notifyListeners();
    });
  }

  Future<Result> createUser({
    required String displayName,
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential credentials =
          await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      user = credentials.user;

      await user!.updateDisplayName(displayName);

      _userRepository.add(UserModel(id: user!.uid, email: email.trim()));

      return Result.ok();
    } on FirebaseAuthException catch (e) {
      String? exceptionMessage = _getFirebaseAuthExceptioMessage(e) ??
          'Ocorreu um erro inesperado ao criar a conta. Tente mais tarde.';

      return Result.error(exceptionMessage);
    } catch (_) {
      return Result.error(
          'Ocorreu um erro inesperado ao criar a conta. Tente mais tarde.');
    }
  }

  Future<Result> signIn(String email, String password) async {
    try {
      final UserCredential credentials = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      user = credentials.user;

      return Result.ok();
    } on FirebaseAuthException catch (e) {
      String? exceptionMessage = _getFirebaseAuthExceptioMessage(e) ??
          'Ocorreu um erro inesperado ao fazer login. Tente mais tarde.';

      return Result.error(exceptionMessage);
    }
  }

  Future<void> signOut(BuildContext context) async {
    await AppProvider.disposeValues(context);

    await _auth.signOut();

    App.to.pushReplacementNamed('/login');
  }

  String? _getFirebaseAuthExceptioMessage(FirebaseAuthException exception) {
    switch (exception.code) {
      case 'email-already-in-use':
        return 'Já existe uma conta criada com esse e-mail.';
      case 'invalid-email':
        return 'E-mail não é valido.';
      case 'weak-password':
        return 'Senha fraca.';
      case 'user-disabled':
        return 'Sua conta está desativada.';
      case 'user-not-found':
        return 'E-mail ou senha inválido.';
      case 'wrong-password':
        return 'E-mail ou senha inválido.';
      default:
        return null;
    }
  }
}
