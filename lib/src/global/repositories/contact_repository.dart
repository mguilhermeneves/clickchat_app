import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:clickchat_app/src/global/models/user_model.dart';
import 'package:clickchat_app/src/global/constants/firestore_constant.dart';
import 'package:clickchat_app/src/global/exceptions/repository_exception.dart';

import '../models/contact_model.dart';

abstract class IContactRepository {
  Future<void> add(ContactModel contact, String requestedByUserId);

  Future<void> update(ContactModel contact, String requestedByUserId);

  Future<void> delete(String id, String requestedByUserId);

  Future<ContactModel?> getByUserId(String userId, String requestedByUserId);

  Stream<List<ContactModel>> getAll(String requestedByUserId);
}

class ContactRepository implements IContactRepository {
  final FirebaseFirestore _firestore;

  ContactRepository(this._firestore);

  @override
  Future<void> add(ContactModel contact, String requestedByUserId) async {
    try {
      await _firestore
          .collection(FirestoreConstant.collectionUsers)
          .doc(requestedByUserId)
          .collection(FirestoreConstant.collectionContacts)
          .add({'name': contact.name, 'userId': contact.userId});
    } catch (e) {
      throw RepositoryException(e.toString());
    }
  }

  @override
  Future<void> update(ContactModel contact, String requestedByUserId) async {
    try {
      await _firestore
          .collection(FirestoreConstant.collectionUsers)
          .doc(requestedByUserId)
          .collection(FirestoreConstant.collectionContacts)
          .doc(contact.id)
          .update({'name': contact.name});
    } catch (e) {
      throw RepositoryException(e.toString());
    }
  }

  @override
  Future<void> delete(String id, String requestedByUserId) async {
    try {
      await _firestore
          .collection(FirestoreConstant.collectionUsers)
          .doc(requestedByUserId)
          .collection(FirestoreConstant.collectionContacts)
          .doc(id)
          .delete();
    } catch (e) {
      throw RepositoryException(e.toString());
    }
  }

  @override
  Future<ContactModel?> getByUserId(
      String userId, String requestedByUserId) async {
    try {
      final contacts = await _firestore
          .collection(FirestoreConstant.collectionUsers)
          .doc(requestedByUserId)
          .collection(FirestoreConstant.collectionContacts)
          .where('userId', isEqualTo: userId)
          .get();

      if (contacts.docs.isEmpty) return null;

      final doc = contacts.docs.first;

      final user = await _getUser(userId);

      final contact = ContactModel.fromJson({'id': doc.id, ...doc.data()})
        ..email = user.email;

      return contact;
    } catch (e) {
      throw RepositoryException(e.toString());
    }
  }

  @override
  Stream<List<ContactModel>> getAll(String requestedByUserId) {
    try {
      final snapshots = _firestore
          .collection(FirestoreConstant.collectionUsers)
          .doc(requestedByUserId)
          .collection(FirestoreConstant.collectionContacts)
          .orderBy('name', descending: false)
          .snapshots();

      return snapshots.asyncMap(_convert);
    } catch (e) {
      throw RepositoryException(e.toString());
    }
  }

  Future<List<ContactModel>> _convert(
      QuerySnapshot<Map<String, dynamic>> snapshot) async {
    final contacts = snapshot.docs.map(
      (doc) async {
        final contact = ContactModel.fromJson({
          'id': doc.id,
          ...doc.data(),
        });

        final user = await _getUser(contact.userId!);

        contact.email = user.email;

        return contact;
      },
    ).toList();

    return await Future.wait(contacts);
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
