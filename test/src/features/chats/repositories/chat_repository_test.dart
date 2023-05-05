import 'package:flutter_test/flutter_test.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';

import 'package:clickchat_app/src/features/chats/repositories/chat_repository.dart';
import 'package:clickchat_app/src/global/constants/firestore_constant.dart';

void main() {
  const String requestedByUserId = '1AjBWVDFgrMnCdh26QS0fKNkO3n7';

  test('getAll: deve trazer uma lista de chats', () async {
    final firestore = FakeFirebaseFirestore();
    final chatRepository = ChatRepository(firestore);
    final chatsRef = firestore.collection(FirestoreConstant.collectionChats);
    const chatId = '4EjBWVDFgrMnCdh26QS0fKNkO3n2';
    final messagesRef =
        chatsRef.doc(chatId).collection(FirestoreConstant.collectionMessages);
    final usersRef = firestore.collection(FirestoreConstant.collectionUsers);

    await usersRef.doc('2CjBWVDFgrMnCdh26QS0fKNkO3n3').set({'email': ''});
    await usersRef.doc('5DjBWVDFgrMnCdh26QS0fKNkO3n0').set({'email': ''});

    await chatsRef.doc(chatId).set({
      'usersId': {
        requestedByUserId: true,
        '2CjBWVDFgrMnCdh26QS0fKNkO3n3': true,
      }
    });
    await chatsRef.add({
      'usersId': {
        '5DjBWVDFgrMnCdh26QS0fKNkO3n0': true,
        requestedByUserId: false,
      }
    });

    await messagesRef.add({
      'userIdSender': requestedByUserId,
      'text': 'Olá',
      'dateTime': DateTime.now(),
      'userIdRemove': '',
    });

    final chats = await chatRepository.getAll(requestedByUserId).first;

    expect(chats.length, 1);
  });

  test('getAll: deve trazer uma lista de chats vazia', () async {
    final firestore = FakeFirebaseFirestore();
    final chatRepository = ChatRepository(firestore);
    final chatsRef = firestore.collection(FirestoreConstant.collectionChats);
    final usersRef = firestore.collection(FirestoreConstant.collectionUsers);

    await usersRef.doc('2CjBWVDFgrMnCdh26QS0fKNkO3n3').set({'email': ''});
    await usersRef.doc('5DjBWVDFgrMnCdh26QS0fKNkO3n0').set({'email': ''});

    await chatsRef.add({
      'usersId': {
        requestedByUserId: false,
        '2CjBWVDFgrMnCdh26QS0fKNkO3n3': true,
      }
    });
    await chatsRef.add({
      'usersId': {
        '5DjBWVDFgrMnCdh26QS0fKNkO3n0': true,
        requestedByUserId: false,
      }
    });

    final chats = await chatRepository.getAll(requestedByUserId).first;

    expect(chats.isEmpty, true);
  });

  test('get: deve retornar um chat existente', () async {
    final firestore = FakeFirebaseFirestore();
    final chatRepository = ChatRepository(firestore);
    final chatsRef = firestore.collection(FirestoreConstant.collectionChats);
    final usersRef = firestore.collection(FirestoreConstant.collectionUsers);
    const userId = '2CjBWVDFgrMnCdh26QS0fKNkO3n3';

    await usersRef.doc(userId).set({'email': ''});

    await chatsRef.add({
      'usersId': {
        requestedByUserId: true,
        '3CjBWVDFgrMnCdh26QS0fKNkO3n1': true,
      }
    });
    await chatsRef.add({
      'usersId': {
        requestedByUserId: true,
        userId: true,
      }
    });

    final chat = await chatRepository.get(userId, requestedByUserId);

    final bool equal =
        const ListEquality().equals(chat.usersId, [requestedByUserId, userId]);

    expect(chat.usersId.length, 2);
    expect(equal, true);
  });

  test('get: deve adicionar um chat e retornar o mesmo', () async {
    final firestore = FakeFirebaseFirestore();
    final chatRepository = ChatRepository(firestore);
    final usersRef = firestore.collection(FirestoreConstant.collectionUsers);
    const userId = '2CjBWVDFgrMnCdh26QS0fKNkO3n3';

    await usersRef.doc(userId).set({'email': ''});

    final chat = await chatRepository.get(userId, requestedByUserId);

    final bool equal =
        const ListEquality().equals(chat.usersId, [requestedByUserId, userId]);

    expect(chat.usersId.length, 2);
    expect(equal, true);
  });

  test(
      'remove: deve remover as mensagens apenas para um usuário e desativar o chat',
      () async {
    final firestore = FakeFirebaseFirestore();
    final chatRepository = ChatRepository(firestore);
    const chatId = '2DjBWVDFgrMnCdh26QS0fKNkO3n2';
    const userId = '3CjBWVDFgrMnCdh26QS0fKNkO3n1';
    final chatRef =
        firestore.collection(FirestoreConstant.collectionChats).doc(chatId);
    final messagesRef =
        chatRef.collection(FirestoreConstant.collectionMessages);

    await chatRef.set({
      'usersId': {
        requestedByUserId: true,
        userId: true,
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

    await chatRepository.remove(chatId, requestedByUserId);

    final messages = await messagesRef.get();

    final messagesRequestedByUserId = await messagesRef
        .where('userIdRemove', isNotEqualTo: requestedByUserId)
        .get();

    final chat = await chatRef.get()
      ..data();

    expect(messages.docs.length, 2);
    expect(messagesRequestedByUserId.docs.length, 0);
    expect(chat['usersId'][requestedByUserId], false);
    expect(chat['usersId'][userId], true);
  });

  test(
      'remove: deve excluir as mensagens quando o outro usuário já removeu as mensagens',
      () async {
    final firestore = FakeFirebaseFirestore();
    final chatRepository = ChatRepository(firestore);
    const chatId = '2DjBWVDFgrMnCdh26QS0fKNkO3n2';
    const userId = '3CjBWVDFgrMnCdh26QS0fKNkO3n1';
    final chatRef =
        firestore.collection(FirestoreConstant.collectionChats).doc(chatId);
    final messagesRef =
        chatRef.collection(FirestoreConstant.collectionMessages);

    await chatRef.set({
      'usersId': {
        requestedByUserId: true,
        userId: true,
      }
    });

    await messagesRef.add({
      'userIdSender': requestedByUserId,
      'text': 'tudo bem',
      'dateTime': DateTime(2023, 4, 17, 8, 30),
      'userIdRemove': userId,
      'read': false,
    });

    await messagesRef.add({
      'userIdSender': requestedByUserId,
      'text': '?',
      'dateTime': DateTime(2023, 4, 17, 8, 32),
      'userIdRemove': userId,
      'read': false,
    });

    await chatRepository.remove(chatId, requestedByUserId);

    final messages = await messagesRef.get();

    final messagesRequestedByUserId = await messagesRef
        .where('userIdRemove', isNotEqualTo: requestedByUserId)
        .get();

    expect(messages.docs.length, 0);
    expect(messagesRequestedByUserId.docs.length, 0);
  });
}
