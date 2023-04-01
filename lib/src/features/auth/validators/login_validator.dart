class LoginValidator {
  static String? validateEmail(String? value) {
    if (value?.isEmpty ?? true) {
      return 'Informe o e-mail';
    }
    if (!value!.contains('@') || !value.contains('.')) {
      return 'E-mail não é valido';
    }

    return null;
  }

  static String? validatePassword(String? value) {
    if (value?.isEmpty ?? true) {
      return 'Informe a senha';
    }
    if (value!.length < 4) {
      return 'A senha tem que ter no mínimo 4 caracteres';
    }

    return null;
  }
}
