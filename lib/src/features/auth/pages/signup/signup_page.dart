import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

import 'package:clickchat_app/src/shared/theme/extensions/elevated_button_extension.dart';
import 'package:clickchat_app/src/shared/theme/extensions/text_extension.dart';
import 'package:clickchat_app/src/features/auth/validators/signup_validator.dart';
import 'package:clickchat_app/src/shared/theme/extensions/circular_progress_indicator_exntesion.dart';

import 'signup_controller.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.read<SignupController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Criar conta'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          TextFormField(
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Iconsax.user),
                              labelText: 'Nome e Sobrenome',
                              hintText: 'Digite o nome e sobrenome',
                            ),
                            validator: SignupValidator.validateNameAndSurname,
                            onSaved: (value) =>
                                controller.signup.nameAndSurname = value,
                          ),
                          const SizedBox(height: 15),
                          TextFormField(
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Iconsax.sms),
                              labelText: 'E-mail',
                              hintText: 'Digite o e-mail',
                            ),
                            validator: SignupValidator.validateEmail,
                            onSaved: (value) => controller.signup.email = value,
                          ),
                          const SizedBox(height: 15),
                          TextFormField(
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Iconsax.lock),
                              labelText: 'Senha',
                              hintText: 'Digite a senha',
                              suffixIcon: Icon(Iconsax.eye_slash),
                            ),
                            validator: SignupValidator.validatePassword,
                            onSaved: (value) =>
                                controller.signup.password = value,
                          ),
                          const SizedBox(height: 30),
                          ValueListenableBuilder(
                            valueListenable: controller.signupStore,
                            builder: (context, state, child) {
                              return SizedBox(
                                height: 47,
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: state.isLoading
                                      ? () {}
                                      : controller.createUser,
                                  child: state.isLoading
                                      ? const CircularProgressIndicator()
                                          .elevatedButton()
                                      : const Text('Criar conta'),
                                ).gradient(),
                              );
                            },
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: RichText(
                          text: TextSpan(children: [
                            TextSpan(
                              text: 'Já tem uma conta? ',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            TextSpan(
                              text: 'Entrar',
                              recognizer: TapGestureRecognizer()
                                ..onTap = Navigator.of(context).pop,
                            ).link()
                          ]),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
