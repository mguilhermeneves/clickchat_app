import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

import 'package:provider/provider.dart';
import 'package:iconsax/iconsax.dart';

import 'package:clickchat_app/src/features/auth/validators/login_validator.dart';
import 'package:clickchat_app/src/global/theme/extensions/circular_progress_indicator_extension.dart';
import 'package:clickchat_app/src/global/theme/extensions/text_extension.dart';
import 'package:clickchat_app/src/global/theme/extensions/elevated_button_extension.dart';

import 'login_controller.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.read<LoginController>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        toolbarHeight: 0,
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
                      Container(),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 260,
                            child:
                                Image.asset('assets/images/logo_clickchat.png'),
                          ),
                          const SizedBox(height: 50),
                          TextFormField(
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Iconsax.sms),
                              labelText: 'E-mail',
                              hintText: 'Digite o e-mail',
                            ),
                            validator: LoginValidator.validateEmail,
                            onSaved: (value) => controller.login.email = value,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: 15),
                          TextFormField(
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Iconsax.lock),
                              labelText: 'Senha',
                              hintText: 'Digite a senha',
                              suffixIcon: Icon(Iconsax.eye_slash),
                            ),
                            validator: LoginValidator.validatePassword,
                            onSaved: (value) =>
                                controller.login.password = value,
                          ),
                          const SizedBox(height: 30),
                          ValueListenableBuilder(
                            valueListenable: controller.loginStore,
                            builder: (context, state, child) {
                              return SizedBox(
                                height: 47,
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: state.isLoading
                                      ? () {}
                                      : controller.signIn,
                                  child: state.isLoading
                                      ? const CircularProgressIndicator()
                                          .elevatedButton()
                                      : const Text('Entrar'),
                                ).gradient(),
                              );
                            },
                          ),
                          const SizedBox(height: 30),
                          GestureDetector(
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Função não implementada'),
                                  showCloseIcon: true,
                                ),
                              );
                            },
                            child: const Text('Esqueceu sua senha?').link(),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Não tem uma conta? ',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              TextSpan(
                                text: 'Criar conta',
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.of(context).pushNamed('/signup');
                                  },
                              ).link()
                            ],
                          ),
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
