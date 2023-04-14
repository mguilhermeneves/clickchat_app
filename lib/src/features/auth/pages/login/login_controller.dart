import 'package:flutter/material.dart';

import 'package:clickchat_app/src/global/helpers/app.dart';

import '../../models/login_model.dart';
import '../../states/login_state.dart';
import '../../stores/login_store.dart';

class LoginController {
  final LoginStore loginStore;
  final login = LoginModel();
  final formKey = GlobalKey<FormState>();

  LoginState get loginState => loginStore.value;

  LoginController(this.loginStore);

  Future<void> signIn() async {
    if (!formKey.currentState!.validate()) return;

    formKey.currentState!.save();

    await loginStore.signIn(login);

    if (loginState.isError) {
      App.dialog.alert(loginState.asError.message);
    }
  }
}
