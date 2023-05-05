import '../models/message_model.dart';

abstract class MessagesState {
  MessagesState();

  bool get isInitial => this is InitialMessagesState;
  bool get isLoading => this is LoadingMessagesState;
  bool get isSuccess => this is SuccessMessagesState;
  bool get isError => this is ErrorMessagesState;

  SuccessMessagesState get asSuccess => this as SuccessMessagesState;
  ErrorMessagesState get asError => this as ErrorMessagesState;

  factory MessagesState.initial() {
    return InitialMessagesState();
  }

  factory MessagesState.loading() {
    return LoadingMessagesState();
  }

  factory MessagesState.success(Stream<List<MessageModel>> messages) {
    return SuccessMessagesState(messages);
  }

  factory MessagesState.error(String message) {
    return ErrorMessagesState(message);
  }
}

class InitialMessagesState extends MessagesState {}

class SuccessMessagesState extends MessagesState {
  final Stream<List<MessageModel>> messages;

  SuccessMessagesState(this.messages);
}

class LoadingMessagesState extends MessagesState {}

class ErrorMessagesState extends MessagesState {
  final String message;

  ErrorMessagesState(this.message);
}
