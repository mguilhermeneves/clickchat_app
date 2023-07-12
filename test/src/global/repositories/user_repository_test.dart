import 'package:flutter_test/flutter_test.dart';

import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';

import 'package:clickchat_app/src/global/constants/firestore_constant.dart';
import 'package:clickchat_app/src/global/models/user_model.dart';
import 'package:clickchat_app/src/global/repositories/user_repository.dart';

void main() {
  test('add: deve adicionar um novo user', () async {
    final firestore = FakeFirebaseFirestore();
    final userRepository = UserRepository(firestore);

    await userRepository.add(UserModel(
      id: '4GjBWVDFgrMnCgh26QS0fKNkO3n1',
      email: 'user@clickchat.com',
    ));

    final users =
        await firestore.collection(FirestoreConstant.collectionUsers).get();

    expect(users.docs.length, 1);
    expect(users.docs.first['email'], 'user@clickchat.com');
    expect(users.docs.first.id, '4GjBWVDFgrMnCgh26QS0fKNkO3n1');
    expect(users.docs.first.data().containsKey('id'), false);
  });

  test(
      'getByEmail: deve trazer um user quando passado um email de um user já cadastrado',
      () async {
    final firestore = FakeFirebaseFirestore();
    final userRepository = UserRepository(firestore);

    await firestore
        .collection(FirestoreConstant.collectionUsers)
        .doc('4GjBWVDFgrMnCgh26QS0fKNkO3n1')
        .set(
      {
        'email': 'user@clickchat.com',
        'profilePictureUrl': '',
      },
    );

    final user = await userRepository.getByEmail('user@clickchat.com');

    expect(user == null, false);
    expect(user?.id, '4GjBWVDFgrMnCgh26QS0fKNkO3n1');
    expect(user?.email, 'user@clickchat.com');
  });

  test(
      'getByEmail: deve trazer um user null quando passado um email de um user não existe',
      () async {
    final firestore = FakeFirebaseFirestore();
    final userRepository = UserRepository(firestore);

    await firestore
        .collection(FirestoreConstant.collectionUsers)
        .doc('4GjBWVDFgrMnCgh26QS0fKNkO3n1')
        .set(
      {
        'email': 'user@clickchat.com',
      },
    );

    final user = await userRepository.getByEmail('user@flutter.com');

    expect(user == null, true);
  });
}
