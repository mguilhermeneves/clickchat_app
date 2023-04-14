import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:clickchat_app/src/global/exceptions/repository_exception.dart';

import '../constants/firestore_constant.dart';
import '../models/user_model.dart';

abstract class IUserRepository {
  Future<void> add(UserModel user);
  Future<UserModel?> getByEmail(String email);
}

class UserRepository implements IUserRepository {
  final FirebaseFirestore _firestore;

  UserRepository(this._firestore);

  @override
  Future<void> add(UserModel user) async {
    try {
      _firestore
          .collection(FirestoreConstant.collectionUsers)
          .doc(user.id)
          .set({'email': user.email});
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
