import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:clickchat_app/src/global/exceptions/repository_exception.dart';
import 'package:clickchat_app/src/global/models/contact_model.dart';
import 'package:clickchat_app/src/global/models/user_model.dart';
import 'package:clickchat_app/src/global/constants/firestore_constant.dart';

import '../models/chat_model.dart';
import '../models/message_model.dart';

abstract class IChatRepository {
  Future<ChatModel> get(String userId, String requestedByUserId);

  Future<void> remove(String chatId, String requestedByUserId);

  Stream<List<ChatModel>> getAll(String requestByUserId);
}

class ChatRepository implements IChatRepository {
  final FirebaseFirestore _firestore;

  ChatRepository(this._firestore);

  /// Retorna um chat existente. Caso não tenha um chat entre os usuários, é
  /// criado um.
  @override
  Future<ChatModel> get(String userId, String requestedByUserId) async {
    try {
      final chatRef = _firestore.collection(FirestoreConstant.collectionChats);

      var chats = await chatRef
          .where('usersId.$requestedByUserId', whereIn: [true, false])
          .where('usersId.$userId', isEqualTo: true)
          .get();

      if (chats.docs.isEmpty) {
        chats = await chatRef
            .where('usersId.$requestedByUserId', whereIn: [true, false])
            .where('usersId.$userId', isEqualTo: false)
            .get();

        if (chats.docs.isEmpty) {
          return await _add(userId, requestedByUserId);
        }
      }

      final doc = chats.docs.first;

      final chat = ChatModel.fromJson({
        'id': doc.id,
        ...doc.data(),
      });

      chat.contact = await _getContact(userId, requestedByUserId);

      return chat;
    } catch (e) {
      throw RepositoryException(e.toString());
    }
  }

  Future<ChatModel> _add(String userId, String requestedByUserId) async {
    final chatsRef = _firestore.collection(FirestoreConstant.collectionChats);

    final doc = await chatsRef.add({
      'usersId': {
        requestedByUserId: false,
        userId: false,
      }
    });

    final chat = ChatModel(
      id: doc.id,
      usersId: [requestedByUserId, userId],
      contact: await _getContact(userId, requestedByUserId),
    );

    return chat;
  }

  @override
  Future<void> remove(String chatId, String requestedByUserId) async {
    try {
      final chatRef =
          _firestore.collection(FirestoreConstant.collectionChats).doc(chatId);

      /// Desativa o chat para o usuário.
      await chatRef.update({'usersId.$requestedByUserId': false});

      final messages = await chatRef
          .collection(FirestoreConstant.collectionMessages)
          .where('userIdRemove', isNotEqualTo: requestedByUserId)
          .get();

      if (messages.docs.isEmpty) return;

      for (var doc in messages.docs) {
        final message = MessageModel.fromJson(
          {'id': doc.id, ...doc.data()},
        );

        if (message.userIdRemove?.isEmpty ?? true) {
          await doc.reference.update({'userIdRemove': requestedByUserId});
        } else {
          /// Caso o outro usuário tenha removido a mensagem também, ela é
          /// excluída do banco de dados.
          await doc.reference.delete();
        }
      }

      final allMessages =
          await chatRef.collection(FirestoreConstant.collectionMessages).get();

      if (allMessages.docs.isEmpty) {
        await chatRef.delete();
      }
    } catch (e) {
      throw RepositoryException(e.toString());
    }
  }

  @override
  Stream<List<ChatModel>> getAll(String requestedByUserId) {
    try {
      final snapshots = _firestore
          .collection(FirestoreConstant.collectionChats)
          .where('usersId.$requestedByUserId', isEqualTo: true)
          .snapshots();

      return snapshots
          .asyncMap((snapshot) => _convert(snapshot, requestedByUserId));
    } catch (e) {
      throw RepositoryException(e.toString());
    }
  }

  Future<List<ChatModel>> _convert(QuerySnapshot<Map<String, dynamic>> snapshot,
      String requestedByUserId) async {
    final chatsFuture = snapshot.docs.map(
      (doc) async {
        final chat = ChatModel.fromJson({'id': doc.id, ...doc.data()});

        String userId;

        if (chat.usersId[0] == requestedByUserId) {
          userId = chat.usersId[1];
        } else {
          userId = chat.usersId[0];
        }

        chat.contact = await _getContact(userId, requestedByUserId);

        chat.lastMessage = _getLastMessage(chat.id, userId);

        chat.unreadMessages =
            _unreadMessages(chat.id, userId, requestedByUserId);

        return chat;
      },
    ).toList();

    final chats = await Future.wait(chatsFuture);

    return chats;
  }

  Stream<int> _unreadMessages(
      String chatId, String userId, String requestedByUserId) {
    final snapshots = _firestore
        .collection(FirestoreConstant.collectionChats)
        .doc(chatId)
        .collection(FirestoreConstant.collectionMessages)
        .where('userIdRemove', isNotEqualTo: requestedByUserId)
        .where('userIdSender', isEqualTo: userId)
        .where('read', isEqualTo: false)
        .snapshots();

    return snapshots.map((snapshot) => snapshot.size);
  }

  Stream<MessageModel?> _getLastMessage(String chatId, String userId) {
    final snapshots = _firestore
        .collection(FirestoreConstant.collectionChats)
        .doc(chatId)
        .collection(FirestoreConstant.collectionMessages)
        .where('userIdRemove', whereIn: ['', userId])
        .orderBy('dateTime', descending: true)
        .limit(1)
        .snapshots();

    final stream = snapshots.map((snapshot) {
      if (snapshot.docs.isEmpty) return null;

      final message = snapshot.docs.first;

      return MessageModel.fromJson({'id': message.id, ...message.data()});
    });

    return stream;
  }

  Future<ContactModel> _getContact(
      String userId, String requestedByUserId) async {
    final contacts = await _firestore
        .collection(FirestoreConstant.collectionUsers)
        .doc(requestedByUserId)
        .collection(FirestoreConstant.collectionContacts)
        .where('userId', isEqualTo: userId)
        .get();

    final user = await _getUser(userId);

    if (contacts.docs.isEmpty) {
      return ContactModel(
        email: user.email,
        userId: user.id,
        userProfilePictureUrl: user.profilePictureUrl,
      );
    }

    final doc = contacts.docs.first;

    final contact = ContactModel.fromJson({'id': doc.id, ...doc.data()})
      ..email = user.email
      ..userProfilePictureUrl = user.profilePictureUrl;

    return contact;
  }

  Future<UserModel> _getUser(String userId) async {
    final user = await _firestore
        .collection(FirestoreConstant.collectionUsers)
        .doc(userId)
        .get();

    return UserModel.fromJson({
      'id': user.id,
      ...user.data()!,
    });
  }
}
