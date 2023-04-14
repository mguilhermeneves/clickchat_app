import 'package:flutter_test/flutter_test.dart';

import 'package:mocktail/mocktail.dart';

import 'package:clickchat_app/src/features/contacts/usecases/delete_contact.dart';

import '../../../../mocks/repositories_mock.dart';
import '../../../../mocks/services_mock.dart';

void main() {
  const String requestedByUserId = '1AjBWVDFgrMnCdh26QS0fKNkO3n7';

  test('deve excluir o contato', () async {
    final authService = AuthServiceMock();
    final contactRepository = ContactRepositoryMock();
    final deleteContact = DeleteContact(contactRepository, authService);
    const contactId = '3BjBWVDFgrMnCdh26QS0fKNkO3n1';

    when(() => authService.userId).thenReturn(requestedByUserId);
    when(() => authService.signedIn).thenReturn(true);
    when(() => contactRepository.delete(contactId, requestedByUserId))
        .thenAnswer((_) => Future.value());

    final result = await deleteContact.call(contactId);

    expect(result.succeeded, true);
  });
}
