import 'package:flutter_test/flutter_test.dart';

import 'package:mocktail/mocktail.dart';

import 'package:clickchat_app/src/features/chats/models/message_model.dart';
import 'package:clickchat_app/src/features/chats/usecases/get_all_messages.dart';

import '../../../../mocks/repositories_mock.dart';
import '../../../../mocks/services_mock.dart';

void main() {
  const String requestedByUserId = '1AjBWVDFgrMnCdh26QS0fKNkO3n7';

  test('deve trazer uma lista de messages', () async {
    final authService = AuthServiceMock();
    final messageRepository = MessageRepositoryMock();
    final getAllMessages = GetAllMessages(messageRepository, authService);
    const chatId = '3BjBWVDFgrMnCeh26QS0fKNkO3n1';
    const limit = 10;

    when(() => authService.signedIn).thenReturn(true);
    when(() => authService.userId).thenReturn(requestedByUserId);
    when(() => messageRepository.getAll(chatId, requestedByUserId, limit))
        .thenAnswer(
      (_) => Future.value(Stream.value([
        MessageModel(
          id: '',
          userIdSender: '',
          text: '',
          dateTime: DateTime.now(),
          read: false,
        ),
        MessageModel(
          id: '',
          userIdSender: '',
          text: '',
          dateTime: DateTime.now(),
          read: false,
        ),
      ])),
    );

    final result = await getAllMessages.call(chatId, limit);
    final messages = await result.data?.first;

    expect(result.succeeded, true);
    expect(messages?.length, 2);
  });
}
