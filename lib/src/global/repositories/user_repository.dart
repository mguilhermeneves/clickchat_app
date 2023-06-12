import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:clickchat_app/src/global/exceptions/repository_exception.dart';

import '../constants/firestore_constant.dart';
import '../models/user_model.dart';

abstract class IUserRepository {
  Future<void> add(UserModel user);
  Future<void> saveToken(String token, String userId);
  Future<void> setProfilePicture(String? profilePictureUrl, String userId);
  Future<String?> getProfilePicture(String userId);
  Future<UserModel?> getByEmail(String email);
  Future<List<String>> getTokens(String userId);
  Future<void> deleteToken(String token, String userId);
}

class UserRepository implements IUserRepository {
  final FirebaseFirestore _firestore;

  UserRepository(this._firestore);

  @override
  Future<void> add(UserModel user) async {
    try {
      await _firestore
          .collection(FirestoreConstant.collectionUsers)
          .doc(user.id)
          .set({
        'email': user.email,
        'messasingTokens': [],
        'profilePictureUrl': '',
      });
    } catch (e) {
      throw RepositoryException(e.toString());
    }
  }

  @override
  Future<void> setProfilePicture(
      String? profilePictureUrl, String userId) async {
    try {
      await _firestore
          .collection(FirestoreConstant.collectionUsers)
          .doc(userId)
          .update({'profilePictureUrl': profilePictureUrl ?? ''});
    } catch (e) {
      throw RepositoryException(e.toString());
    }
  }

  @override
  Future<String?> getProfilePicture(String userId) async {
    try {
      final doc = await _firestore
          .collection(FirestoreConstant.collectionUsers)
          .doc(userId)
          .get();

      var profilePictureUrl = doc.data()!['profilePictureUrl'] as String;

      if (profilePictureUrl.isEmpty) return null;

      return profilePictureUrl;
    } catch (e) {
      throw RepositoryException(e.toString());
    }
  }

  @override
  Future<void> saveToken(String token, String userId) async {
    try {
      await _firestore
          .collection(FirestoreConstant.collectionUsers)
          .doc(userId)
          .update({
        'messasingTokens': FieldValue.arrayUnion([token])
      });
    } catch (e) {
      throw RepositoryException(e.toString());
    }
  }

  @override
  Future<void> deleteToken(String token, String userId) async {
    try {
      await _firestore
          .collection(FirestoreConstant.collectionUsers)
          .doc(userId)
          .update({
        'messasingTokens': FieldValue.arrayRemove([token])
      });
    } catch (e) {
      throw RepositoryException(e.toString());
    }
  }

  @override
  Future<List<String>> getTokens(String userId) async {
    try {
      final doc = await _firestore
          .collection(FirestoreConstant.collectionUsers)
          .doc(userId)
          .get();

      var tokens = doc.data()!['messasingTokens'].cast<String>();

      return tokens;
    } catch (e) {
      throw RepositoryException(e.toString());
    }
  }

  @override
  Future<UserModel?> getByEmail(String email) async {
    try {
      final users = await _firestore
          .collection(FirestoreConstant.collectionUsers)
          .where('email', isEqualTo: email)
          .get();

      if (users.docs.isEmpty) return null;

      final user = users.docs.first;

      return UserModel.fromJson({
        'id': user.id,
        ...user.data(),
      });
    } catch (e) {
      throw RepositoryException(e.toString());
    }
  }
}
