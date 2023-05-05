import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:clickchat_app/src/global/exceptions/repository_exception.dart';
import 'package:clickchat_app/src/global/constants/firestore_constant.dart';

import '../models/chat_model.dart';
import '../models/message_model.dart';

abstract class IMessageRepository {
  Future<void> send(String chatId, String text, String requestedByUserId);

  Future<void> remove(
      String chatId, String messageId, String requestedByUserId);

  Future<Stream<List<MessageModel>>> getAll(
      String chatId, String requestedByUserId);
}

class MessageRepository implements IMessageRepository {
  final FirebaseFirestore _firestore;

  MessageRepository(this._firestore);

  @override
  Future<void> send(
      String chatId, String text, String requestedByUserId) async {
    try {
      await _activateChat(chatId);

      final messagesRef = _firestore
          .collection(FirestoreConstant.collectionChats)
          .doc(chatId)
          .collection(FirestoreConstant.collectionMessages);

      await messagesRef.add({
        'userIdSender': requestedByUserId,
        'text': text,
        'dateTime': DateTime.now(),
        'userIdRemove': '',
        'read': false,
      });
    } catch (e) {
      throw RepositoryException(e.toString());
    }
  }

  /// Ativa o chat para mostrar para os 2 usuários. (Os [usersId] podem ter o
  /// valor false. Porque um usuário pode excluir as mensagens, porém, o
  /// outro pode ver elas ainda)
  Future<void> _activateChat(String chatId) async {
    final chatRef =
        _firestore.collection(FirestoreConstant.collectionChats).doc(chatId);

    var doc = await chatRef.get();

    final chat = ChatModel.fromJson({
      'id': doc.id,
      ...doc.data()!,
    });

    bool userId0Active = doc.data()!['usersId'][chat.usersId[0]];
    bool userId1Active = doc.data()!['usersId'][chat.usersId[1]];

    if (userId0Active && userId1Active) return;

    chatRef.update({
      'usersId': {
        chat.usersId[0]: true,
        chat.usersId[1]: true,
      },
    });
  }

  @override
  Future<void> remove(
      String chatId, String messageId, String requestedByUserId) async {
    try {
      final chatRef =
          _firestore.collection(FirestoreConstant.collectionChats).doc(chatId);
      final messagesRef =
          chatRef.collection(FirestoreConstant.collectionMessages);
      final messageRef = messagesRef.doc(messageId);

      final doc = await messageRef.get();

      final message = MessageModel.fromJson({
        'id': doc.id,
        ...doc.data()!,
      });

      if (message.userIdRemove?.isEmpty ?? true) {
        await messageRef.update({'userIdRemove': requestedByUserId});
      } else if (message.userIdRemove != requestedByUserId) {
        /// Caso o outro usuário tenha removido a mensagem também, ela é excluída
        /// do banco de dados.
        await messageRef.delete();
      }

      final messages = await messagesRef
          .where('userIdRemove', isNotEqualTo: requestedByUserId)
          .get();

      /// Caso o usuário não tenha mais mensagens, ele desativa o chat.
      if (messages.docs.isEmpty) {
        await chatRef.update({'usersId.$requestedByUserId': false});
      }
    } catch (e) {
      throw RepositoryException(e.toString());
    }
  }

  @override
  Future<Stream<List<MessageModel>>> getAll(
      String chatId, String requestedByUserId) async {
    try {
      final chatRef =
          _firestore.collection(FirestoreConstant.collectionChats).doc(chatId);

      final doc = await chatRef.get();
      final chat = ChatModel.fromJson({'id': doc.id, ...doc.data()!});

      String userId;

      if (chat.usersId[0] == requestedByUserId) {
        userId = chat.usersId[1];
      } else {
        userId = chat.usersId[0];
      }

      final snapshots = chatRef
          .collection(FirestoreConstant.collectionMessages)
          .where('userIdRemove', whereIn: ['', userId])
          .orderBy('dateTime', descending: true)
          .snapshots();

      return snapshots
          .map((snapshot) => _convert(snapshot, chatId, requestedByUserId));
    } catch (e) {
      throw RepositoryException(e.toString());
    }
  }

  List<MessageModel> _convert(QuerySnapshot<Map<String, dynamic>> snapshot,
      String chatId, String requestedByUserId) {
    final messagesRef = _firestore
        .collection(FirestoreConstant.collectionChats)
        .doc(chatId)
        .collection(FirestoreConstant.collectionMessages);

    return snapshot.docs.map(
      (doc) {
        final message = MessageModel.fromJson({'id': doc.id, ...doc.data()});

        if (message.userIdSender != requestedByUserId && !message.read) {
          messagesRef.doc(message.id).update({'read': true});
        }

        return message;
      },
    ).toList();
  }
}
