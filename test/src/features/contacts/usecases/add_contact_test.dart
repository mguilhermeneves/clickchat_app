import 'package:flutter_test/flutter_test.dart';

import 'package:mocktail/mocktail.dart';

import 'package:clickchat_app/src/global/models/contact_model.dart';
import 'package:clickchat_app/src/features/contacts/usecases/add_contact.dart';
import 'package:clickchat_app/src/global/exceptions/repository_exception.dart';
import 'package:clickchat_app/src/global/models/user_model.dart';

import '../../../../mocks/repositories_mock.dart';
import '../../../../mocks/services_mock.dart';

void main() {
  const String requestedByUserId = '1AjBWVDFgrMnCdh26QS0fKNkO3n7';
  final contactRepository = ContactRepositoryMock();
  final userRepository = UserRepositoryMock();
  final authService = AuthServiceMock();
  final addContact = AddContact(contactRepository, userRepository, authService);

  test('deve adicionar um contact', () async {
    final user = UserModel(
      id: '8ajBWVDFgrMnCdh26QS0fKNkO3n3',
      email: 'pedro@clickchat.com',
    );
    final contact = ContactModel(
      name: 'Pedro',
      email: user.email,
    );

    when(() => authService.signedIn).thenReturn(true);
    when(() => authService.userId).thenReturn(requestedByUserId);
    when(() => userRepository.getByEmail(contact.email!)).thenAnswer(
      (_) => Future.value(user),
    );
    when(() => contactRepository.getByUserId(user.id, requestedByUserId))
        .thenAnswer(
      (_) => Future.value(null),
    );
    when(() => contactRepository.add(contact, requestedByUserId)).thenAnswer(
      (_) => Future.value(),
    );

    final result = await addContact.call(contact);

    expect(result.succeeded, true);
  });

  test('quando passado um contactModel inválido, deve dar erro', () async {
    final result = await addContact.call(ContactModel());

    expect(result.succeeded, false);
  });

  test('quando a conta está desconectada, deve dar erro', () async {
    final contact = ContactModel(
      name: 'Pedro',
      email: 'pedro@clickchat.com',
    );

    when(() => authService.signedIn).thenReturn(false);

    final result = await addContact.call(contact);

    expect(result.succeeded, false);
  });

  test(
      'quando for adicionar um contato com um email que não tem conta, deve dar erro',
      () async {
    final user = UserModel(
      id: '8ajBWVDFgrMnCdh26QS0fKNkO3n3',
      email: 'pedro@clickchat.com',
    );
    final contact = ContactModel(
      name: 'Pedro',
      email: user.email,
    );

    when(() => authService.signedIn).thenReturn(true);
    when(() => userRepository.getByEmail(contact.email!)).thenAnswer(
      (_) => Future.value(null),
    );

    final result = await addContact.call(contact);

    expect(result.succeeded, false);
  });

  test('quando for adicionar um contato que já foi adicionado, deve dar erro',
      () async {
    final user = UserModel(
      id: '8ajBWVDFgrMnCdh26QS0fKNkO3n3',
      email: 'pedro@clickchat.com',
    );
    final contact = ContactModel(
      name: 'Pedro',
      email: user.email,
      userId: '8ajBWVDFgrMnCdh26QS0fKNkO3n3',
    );

    when(() => authService.signedIn).thenReturn(true);
    when(() => authService.userId).thenReturn(requestedByUserId);
    when(() => userRepository.getByEmail(contact.email!)).thenAnswer(
      (_) => Future.value(user),
    );
    when(() => contactRepository.getByUserId(user.id, requestedByUserId))
        .thenAnswer(
      (_) => Future.value(contact),
    );

    final result = await addContact.call(contact);

    expect(result.succeeded, false);
  });

  test('deve dar um erro de repository', () async {
    final user = UserModel(
      id: '8ajBWVDFgrMnCdh26QS0fKNkO3n3',
      email: 'pedro@clickchat.com',
    );
    final contact = ContactModel(
      name: 'Pedro',
      email: user.email,
      userId: '8ajBWVDFgrMnCdh26QS0fKNkO3n3',
    );

    when(() => authService.signedIn).thenReturn(true);
    when(() => authService.userId).thenReturn(requestedByUserId);
    when(() => userRepository.getByEmail(contact.email!)).thenThrow(
      RepositoryException(''),
    );

    final result = await addContact.call(contact);

    expect(result.succeeded, false);
  });
}
