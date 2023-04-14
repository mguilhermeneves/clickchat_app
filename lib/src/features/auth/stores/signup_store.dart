import 'package:flutter/material.dart';

import 'package:clickchat_app/src/features/auth/models/signup_model.dart';
import 'package:clickchat_app/src/global/services/auth_service.dart';

import '../states/singup_state.dart';

class SignupStore extends ValueNotifier<SignupState> {
  final AuthService _authService;

  SignupStore(this._authService) : super(SignupState.initial());

  Future<void> createUser(SignupModel signup) async {
    value = SignupState.loading();

    final result = await _authService.createUser(
      displayName: signup.nameAndSurname!,
      email: signup.email!,
      password: signup.password!,
    );

    if (result.succeeded) {
      value = SignupState.success();
    } else {
      value = SignupState.error(result.error!);
    }
  }
}
