import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../helpers/result.dart';

class AuthService extends ChangeNotifier {
  final _auth = FirebaseAuth.instance;
  User? user;
  bool get signedIn => user != null;

  AuthService() {
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

      user!.updateDisplayName(displayName);

      return Result.ok();
    } on FirebaseAuthException catch (e) {
      String? exceptionMessage = _getFirebaseAuthExceptioMessage(e) ??
          'Ocorreu um erro inesperado ao criar a conta. Tente mais tarde.';

      return Result.error(exceptionMessage);
    }
  }

  Future<Result> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      return Result.ok();
    } on FirebaseAuthException catch (e) {
      String? exceptionMessage = _getFirebaseAuthExceptioMessage(e) ??
          'Ocorreu um erro inesperado ao fazer login. Tente mais tarde.';

      return Result.error(exceptionMessage);
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
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
