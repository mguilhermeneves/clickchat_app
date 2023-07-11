import '../models/chat_model.dart';

abstract class ChatsState {
  ChatsState();

  bool get isInitial => this is InitialChatsState;
  bool get isLoading => this is LoadingChatsState;
  bool get isSuccess => this is SuccessChatsState;
  bool get isError => this is ErrorChatsState;

  SuccessChatsState get asSuccess => this as SuccessChatsState;
  ErrorChatsState get asError => this as ErrorChatsState;

  factory ChatsState.initial() {
    return InitialChatsState();
  }

  factory ChatsState.loading() {
    return LoadingChatsState();
  }

  factory ChatsState.success(List<ChatModel> chats) {
    return SuccessChatsState(chats);
  }

  factory ChatsState.error(String message) {
    return ErrorChatsState(message);
  }
}

class InitialChatsState extends ChatsState {}

class SuccessChatsState extends ChatsState {
  final List<ChatModel> chats;

  SuccessChatsState(this.chats);
}

class LoadingChatsState extends ChatsState {}

class ErrorChatsState extends ChatsState {
  final String message;

  ErrorChatsState(this.message);
}
