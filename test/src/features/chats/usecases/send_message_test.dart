import 'package:clickchat_app/src/features/chats/models/chat_model.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mocktail/mocktail.dart';

import 'package:clickchat_app/src/features/chats/usecases/send_message.dart';

import '../../../../mocks/repositories_mock.dart';
import '../../../../mocks/services_mock.dart';

void main() {
  const String requestedByUserId = '1AjBWVDFgrMnCdh26QS0fKNkO3n7';

  test('deve enviar uma message', () async {
    final messageRepository = MessageRepositoryMock();
    final userRepository = UserRepositoryMock();
    final notificationService = NotificationServiceMock();
    final authService = AuthServiceMock();
    final sendMessage = SendMessage(
        messageRepository, userRepository, notificationService, authService);
    const text = 'Olá, tudo bem?';

    var chat = ChatModel(
      id: '9ZjBWVDFgrMnCdh26QS0fKNkO3n1',
      usersId: [
        requestedByUserId,
        '3CjBWVDFgrMnCdh26QS0fKNkO3n1',
      ],
    );

    when(() => authService.signedIn).thenReturn(true);
    when(() => authService.userId).thenReturn(requestedByUserId);
    when(() => userRepository.getTokens('3CjBWVDFgrMnCdh26QS0fKNkO3n1'))
        .thenAnswer((_) => Future.value([]));
    when(() => messageRepository.send(chat.id, text, requestedByUserId))
        .thenAnswer((_) => Future.value());

    final result = await sendMessage.call(chat, text);

    expect(result.succeeded, true);
  });
}
