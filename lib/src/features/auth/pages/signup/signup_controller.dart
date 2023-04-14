import 'package:clickchat_app/src/features/auth/states/singup_state.dart';
import 'package:flutter/material.dart';

import 'package:clickchat_app/src/features/auth/stores/signup_store.dart';
import 'package:clickchat_app/src/global/helpers/app.dart';

import '../../models/signup_model.dart';

class SignupController {
  final SignupStore signupStore;
  final signup = SignupModel();
  final formKey = GlobalKey<FormState>();

  SignupState get signupState => signupStore.value;

  SignupController(this.signupStore);

  Future<void> createUser() async {
    if (!formKey.currentState!.validate()) return;

    formKey.currentState!.save();

    await signupStore.createUser(signup);

    if (signupState.isError) {
      App.dialog.alert(signupState.asError.message);
    }

    if (signupState.isSuccess) {
      App.to.pop();
    }
  }
}
