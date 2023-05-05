import 'package:flutter_test/flutter_test.dart';

import 'package:mocktail/mocktail.dart';

import 'package:clickchat_app/src/global/models/contact_model.dart';
import 'package:clickchat_app/src/global/usecases/get_all_contacts.dart';

import '../../../../mocks/repositories_mock.dart';
import '../../../../mocks/services_mock.dart';

void main() {
  const String requestedByUserId = '1AjBWVDFgrMnCdh26QS0fKNkO3n7';
  final contactRepository = ContactRepositoryMock();
  final authService = AuthServiceMock();
  final getAllContacts = GetAllContacts(contactRepository, authService);

  test('deve trazer uma lista de contacts', () async {
    when(() => authService.signedIn).thenReturn(true);
    when(() => authService.userId).thenReturn(requestedByUserId);
    when(() => contactRepository.getAll(requestedByUserId)).thenAnswer(
      (_) => Stream.value([
        ContactModel(),
        ContactModel(),
      ]),
    );

    final result = getAllContacts.call();
    final length = await result.data?.first;

    expect(result.succeeded, true);
    expect(length?.length, 2);
  });

  test('quando a conta está desconectada, deve dar erro', () async {
    when(() => authService.signedIn).thenReturn(false);

    final result = getAllContacts.call();

    expect(result.succeeded, false);
  });
}
