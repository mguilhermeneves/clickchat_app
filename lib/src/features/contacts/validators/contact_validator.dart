import 'package:clickchat_app/src/global/helpers/result.dart';

import '../models/contact_model.dart';

class ContactValidator {
  static String? validateName(String? value) {
    if (value?.isEmpty ?? true) {
      return 'Informe o nome';
    }

    return null;
  }

  static String? validateEmail(String? value) {
    if (value?.isEmpty ?? true) {
      return 'Informe o e-mail';
    }
    if (!value!.contains('@') || !value.contains('.')) {
      return 'E-mail não é valido';
    }

    return null;
  }

  static Result validate(ContactModel contact) {
    final result = Result();

    String? name = validateName(contact.name);
    if (name != null) result.addError(name);

    String? email = validateEmail(contact.email);
    if (email != null) result.addError(email);

    return result;
  }
}
