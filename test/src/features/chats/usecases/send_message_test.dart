import 'package:flutter_test/flutter_test.dart';

import 'package:mocktail/mocktail.dart';

import 'package:clickchat_app/src/features/chats/usecases/send_message.dart';

import '../../../../mocks/repositories_mock.dart';
import '../../../../mocks/services_mock.dart';

void main() {
  const String requestedByUserId = '1AjBWVDFgrMnCdh26QS0fKNkO3n7';

  test('deve enviar uma message', () async {
    final messageRepository = MessageRepositoryMock();
    final authService = AuthServiceMock();
    final sendMessage = SendMessage(messageRepository, authService);
    const chatId = '9ZjBWVDFgrMnCdh26QS0fKNkO3n1';
    const text = 'Olá, tudo bem?';

    when(() => authService.signedIn).thenReturn(true);
    when(() => authService.userId).thenReturn(requestedByUserId);
    when(() => messageRepository.send(chatId, text, requestedByUserId))
        .thenAnswer((_) => Future.value());

    final result = await sendMessage.call(chatId, text);

    expect(result.succeeded, true);
  });
}
