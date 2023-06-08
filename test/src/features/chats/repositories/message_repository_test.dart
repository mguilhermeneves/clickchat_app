import 'package:flutter_test/flutter_test.dart';

import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';

import 'package:clickchat_app/src/features/chats/repositories/message_repository.dart';
import 'package:clickchat_app/src/global/constants/firestore_constant.dart';

void main() {
  const String requestedByUserId = '1AjBWVDFgrMnCdh26QS0fKNkO3n7';

  test('send: deve enviar uma mensagem para outro usuário', () async {
    final firestore = FakeFirebaseFirestore();
    final messageRepository = MessageRepository(firestore);
    const chatId = '2DjBWVDFgrMnCdh26QS0fKNkO3n2';
    final chatRef =
        firestore.collection(FirestoreConstant.collectionChats).doc(chatId);

    chatRef.set({
      'usersId': {
        requestedByUserId: true,
        '3AjBWVDFgrMnCdh26QS0fKNkO3nd': true,
      },
    });

    await messageRepository.send(chatId, 'Olá', requestedByUserId);

    final messages =
        await chatRef.collection(FirestoreConstant.collectionMessages).get();

    expect(messages.docs.length, 1);
    expect(messages.docs.first['text'], 'Olá');
    expect(messages.docs.first.data().containsKey('id'), false);
  });

  test('remove: deve remover uma mensagem apenas para um usuário', () async {
    final firestore = FakeFirebaseFirestore();
    final messageRepository = MessageRepository(firestore);
    const chatId = '2DjBWVDFgrMnCdh26QS0fKNkO3n2';
    const messageId = '9CjBWVDFgrMnCdh26QS0fKNkO3d1';
    final messagesRef = firestore
        .collection(FirestoreConstant.collectionChats)
        .doc(chatId)
        .collection(FirestoreConstant.collectionMessages);

    await messagesRef.doc(messageId).set({
      'userIdSender': requestedByUserId,
      'text': 'tudo bem',
      'dateTime': DateTime(2023, 4, 17, 8, 30),
      'userIdRemove': '',
      'read': false,
    });

    await messagesRef.add({
      'userIdSender': requestedByUserId,
      'text': '?',
      'dateTime': DateTime(2023, 4, 17, 8, 32),
      'userIdRemove': '',
      'read': false,
    });

    await messageRepository.remove(chatId, messageId, requestedByUserId);

    final messages = await messagesRef.get();

    final messagesRequestedByUserId = await messagesRef
        .where('userIdRemove', isNotEqualTo: requestedByUserId)
        .get();

    expect(messages.docs.length, 2);
    expect(messagesRequestedByUserId.docs.length, 1);
  });

  test(
      'remove: deve excluir a mensagem quando o outro usuário já removeu a mensagem',
      () async {
    final firestore = FakeFirebaseFirestore();
    final messageRepository = MessageRepository(firestore);
    const chatId = '2DjBWVDFgrMnCdh26QS0fKNkO3n2';
    const messageId = '9CjBWVDFgrMnCdh26QS0fKNkO3d1';
    final messagesRef = firestore
        .collection(FirestoreConstant.collectionChats)
        .doc(chatId)
        .collection(FirestoreConstant.collectionMessages);

    await messagesRef.doc(messageId).set({
      'userIdSender': requestedByUserId,
      'text': 'tudo bem',
      'dateTime': DateTime(2023, 4, 17, 8, 30),
      'userIdRemove': '5CjBWVDFgrMnCdh26QS0fKNkO3c2',
      'read': false,
    });

    await messagesRef.add({
      'userIdSender': requestedByUserId,
      'text': '?',
      'dateTime': DateTime(2023, 4, 17, 8, 32),
      'userIdRemove': '',
      'read': false,
    });

    await messageRepository.remove(chatId, messageId, requestedByUserId);

    final messages = await messagesRef.get();

    final messagesRequestedByUserId = await messagesRef
        .where('userIdRemove', isNotEqualTo: requestedByUserId)
        .get();

    expect(messages.docs.length, 1);
    expect(messagesRequestedByUserId.docs.length, 1);
  });

  test('getAll: deve trazer uma lista de messages', () async {
    final firestore = FakeFirebaseFirestore();
    final messageRepository = MessageRepository(firestore);
    const chatId = '2DjBWVDFgrMnCdh26QS0fKNkO3n2';
    final chatRef =
        firestore.collection(FirestoreConstant.collectionChats).doc(chatId);
    final messagesRef =
        chatRef.collection(FirestoreConstant.collectionMessages);

    chatRef.set({
      "usersId": {
        requestedByUserId: true,
        '8AjBWVDFgrMnCdh26QS0fKNkO3e8': true,
      }
    });

    await messagesRef.add({
      'userIdSender': requestedByUserId,
      'text': 'tudo bem',
      'dateTime': DateTime(2023, 4, 17, 8, 30),
      'userIdRemove': '',
      'read': false,
    });

    await messagesRef.add({
      'userIdSender': requestedByUserId,
      'text': '?',
      'dateTime': DateTime(2023, 4, 17, 8, 32),
      'userIdRemove': '',
      'read': false,
    });

    final stream =
        await messageRepository.getAll(chatId, requestedByUserId, 10);

    final messages = await stream.first;

    expect(messages.length, 2);
  });

  test('getAll: deve trazer uma lista vazia de messages', () async {
    final firestore = FakeFirebaseFirestore();
    final messageRepository = MessageRepository(firestore);
    const chatId = '2DjBWVDFgrMnCdh26QS0fKNkO3n2';
    final chatRef =
        firestore.collection(FirestoreConstant.collectionChats).doc(chatId);

    chatRef.set({
      "usersId": {
        requestedByUserId: true,
        '8AjBWVDFgrMnCdh26QS0fKNkO3e8': true,
      }
    });

    final stream =
        await messageRepository.getAll(chatId, requestedByUserId, 10);

    final messages = await stream.first;

    expect(messages.isEmpty, true);
  });
}
