import 'package:flutter_test/flutter_test.dart';

import 'package:mocktail/mocktail.dart';

import 'package:clickchat_app/src/features/chats/models/chat_model.dart';
import 'package:clickchat_app/src/features/chats/usecases/get_chat.dart';

import '../../../../mocks/repositories_mock.dart';
import '../../../../mocks/services_mock.dart';

void main() {
  const String requestedByUserId = '1AjBWVDFgrMnCdh26QS0fKNkO3n7';

  test('deve retornar um chat', () async {
    final authService = AuthServiceMock();
    final chatRepository = ChatRepositoryMock();
    final getChat = GetChat(chatRepository, authService);
    const userId = '3BjBWVDFgrMnCeh26QS0fKNkO3n1';

    when(() => authService.signedIn).thenReturn(true);
    when(() => authService.userId).thenReturn(requestedByUserId);
    when(() => chatRepository.get(userId, requestedByUserId))
        .thenAnswer((_) => Future.value(
              ChatModel(
                  id: '2DjBWVDFgrMnCeh26QS0fKNkO3n5',
                  usersId: [userId, requestedByUserId]),
            ));

    final result = await getChat.call(userId);

    expect(result.succeeded, true);
  });
}
