import 'package:flutter/material.dart';

import 'package:clickchat_app/src/global/services/auth_service.dart';

import '../models/login_model.dart';
import '../states/login_state.dart';

class LoginStore extends ValueNotifier<LoginState> {
  final AuthService _authService;

  LoginStore(this._authService) : super(LoginState.initial());

  Future<void> signIn(LoginModel login) async {
    value = LoginState.loading();

    final result = await _authService.signIn(login.email!, login.password!);

    if (result.succeeded) {
      value = LoginState.success();
    } else {
      value = LoginState.error(result.error!);
    }
  }
}
