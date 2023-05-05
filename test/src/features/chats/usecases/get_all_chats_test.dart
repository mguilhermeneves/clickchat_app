import 'package:flutter_test/flutter_test.dart';

import 'package:mocktail/mocktail.dart';

import 'package:clickchat_app/src/features/chats/models/chat_model.dart';
import 'package:clickchat_app/src/features/chats/usecases/get_all_chats.dart';

import '../../../../mocks/repositories_mock.dart';
import '../../../../mocks/services_mock.dart';

void main() {
  const String requestedByUserId = '1AjBWVDFgrMnCdh26QS0fKNkO3n7';
  final chatRepository = ChatRepositoryMock();
  final authService = AuthServiceMock();
  final getAllChats = GetAllChats(chatRepository, authService);

  test('deve trazer uma lista de chats', () async {
    when(() => authService.signedIn).thenReturn(true);
    when(() => authService.userId).thenReturn(requestedByUserId);
    when(() => chatRepository.getAll(requestedByUserId)).thenAnswer(
      (_) => Stream.value([
        ChatModel(id: '', usersId: []),
        ChatModel(id: '', usersId: []),
      ]),
    );

    final result = getAllChats.call();
    final length = await result.data?.first;

    expect(result.succeeded, true);
    expect(length?.length, 2);
  });

  test('quando a conta está desconectada, deve dar erro', () async {
    when(() => authService.signedIn).thenReturn(false);

    final result = getAllChats.call();

    expect(result.succeeded, false);
  });
}
