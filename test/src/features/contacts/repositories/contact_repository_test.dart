import 'package:flutter_test/flutter_test.dart';

import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:mocktail/mocktail.dart';

import 'package:clickchat_app/src/global/exceptions/repository_exception.dart';
import 'package:clickchat_app/src/global/constants/firestore_constant.dart';
import 'package:clickchat_app/src/global/models/contact_model.dart';
import 'package:clickchat_app/src/global/repositories/contact_repository.dart';

import '../../../../mocks/dependencies_mock.dart';

void main() {
  const String requestedByUserId = '1AjBWVDFgrMnCdh26QS0fKNkO3n7';

  test('add: deve adicionar um novo contact', () async {
    final firestore = FakeFirebaseFirestore();
    final contactRepository = ContactRepository(firestore);

    await contactRepository.add(
      ContactModel(
        name: 'João',
        userId: '3djBWVDFgrMnCdh26QS0fKNkO3n1',
      ),
      requestedByUserId,
    );

    final contacts = await firestore
        .collection(FirestoreConstant.collectionUsers)
        .doc(requestedByUserId)
        .collection(FirestoreConstant.collectionContacts)
        .get();

    expect(contacts.docs.length, 1);
    expect(contacts.docs.first['userId'], '3djBWVDFgrMnCdh26QS0fKNkO3n1');
    expect(contacts.docs.first.data().containsKey('id'), false);
  });

  test('update: deve atualizar o name do contact', () async {
    final firestore = FakeFirebaseFirestore();
    final contactRepository = ContactRepository(firestore);
    final contactsRef = firestore
        .collection(FirestoreConstant.collectionUsers)
        .doc(requestedByUserId)
        .collection(FirestoreConstant.collectionContacts);

    await contactsRef.doc('9djBWVfFgrMnCdh26QS0fKNkO3n0').set({
      'name': 'João',
      'userId': '3djBWVDFgrMnCdh26QS0fKNkO3n1',
    });

    await contactRepository.update(
      '9djBWVfFgrMnCdh26QS0fKNkO3n0',
      'Pedro',
      requestedByUserId,
    );

    final contacts = await contactsRef.get();

    expect(contacts.docs.length, 1);
    expect(contacts.docs.first['name'], 'Pedro');
    expect(contacts.docs.first['userId'], '3djBWVDFgrMnCdh26QS0fKNkO3n1');
  });

  test('delete: deve remover um contact', () async {
    final firestore = FakeFirebaseFirestore();
    final contactRepository = ContactRepository(firestore);
    final contactsRef = firestore
        .collection(FirestoreConstant.collectionUsers)
        .doc(requestedByUserId)
        .collection(FirestoreConstant.collectionContacts);

    await contactsRef.doc('9djBWVfFgrMnCdh26QS0fKNkO3n0').set({
      'name': 'João',
      'userId': '3djBWVDFgrMnCdh26QS0fKNkO3n1',
    });

    await contactRepository.delete(
        '9djBWVfFgrMnCdh26QS0fKNkO3n0', requestedByUserId);

    final contacts = await contactsRef.get();

    expect(contacts.docs.length, 0);
  });

  test('getByUserId: deve trazer um contact quando passado um userId',
      () async {
    final firestore = FakeFirebaseFirestore();
    final contactRepository = ContactRepository(firestore);
    final usersRef = firestore.collection(FirestoreConstant.collectionUsers);
    const userId = '3djBWVDFgrMnCdh26QS0fKNkO3n1';

    await usersRef.doc(userId).set({'email': ''});

    await firestore
        .collection(FirestoreConstant.collectionUsers)
        .doc(requestedByUserId)
        .collection(FirestoreConstant.collectionContacts)
        .doc('9djBWVfFgrMnCdh26QS0fKNkO3n0')
        .set({
      'name': 'João',
      'userId': userId,
    });

    final contact =
        await contactRepository.getByUserId(userId, requestedByUserId);

    expect(contact == null, false);
    expect(contact?.userId, userId);
  });

  test(
      'getByUserId: deve trazer um contact null quando passado um userId inválido',
      () async {
    final firestore = FakeFirebaseFirestore();
    final contactRepository = ContactRepository(firestore);

    final contact = await contactRepository.getByUserId(
        '3djBWVDFgrMnCdh26QS0fKNkO3n1', requestedByUserId);

    expect(contact == null, true);
  });

  test('getAll: deve trazer uma lista de contacts', () async {
    final firestore = FakeFirebaseFirestore();
    final contactRepository = ContactRepository(firestore);
    final usersRef = firestore.collection(FirestoreConstant.collectionUsers);
    final contactsRef = usersRef
        .doc(requestedByUserId)
        .collection(FirestoreConstant.collectionContacts);

    await usersRef.doc('3djBWVDFgrMnCdh26QS0fKNkO3n1').set({
      'email': 'joao@clickchat.com',
    });
    await usersRef.doc('2djBWVDFgrMnCdh26QS0fKNkO3n1').set({
      'email': 'pedro@clickchat.com',
    });

    await contactsRef.add({
      'name': 'João',
      'userId': '3djBWVDFgrMnCdh26QS0fKNkO3n1',
    });
    await contactsRef.add({
      'name': 'Pedro',
      'userId': '2djBWVDFgrMnCdh26QS0fKNkO3n1',
    });

    final contacts = await contactRepository.getAll(requestedByUserId).first;
    final contact = contacts
        .where((contact) => contact.userId == '3djBWVDFgrMnCdh26QS0fKNkO3n1')
        .first;

    expect(contacts.length, 2);
    expect(contact.email, 'joao@clickchat.com');
  });

  test('getAll: deve trazer uma lista vazia de contacts', () async {
    final firestore = FakeFirebaseFirestore();
    final contactRepository = ContactRepository(firestore);

    final contacts = await contactRepository.getAll(requestedByUserId).first;

    expect(contacts.isEmpty, true);
  });

  test('getAll: deve lançar um RepositoryException', () async {
    final firestoreMock = FirebaseFirestoreMock();
    final contactRepository = ContactRepository(firestoreMock);

    when(() => firestoreMock.collection('')).thenThrow(Exception());

    expect(() => contactRepository.getAll(requestedByUserId),
        throwsA(isA<RepositoryException>()));
  });
}
