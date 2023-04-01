abstract class LoginState {
  LoginState();

  bool get isLoading => this is LoadingLoginState;
  bool get isSuccess => this is SuccessLoginState;
  bool get isError => this is ErrorLoginState;

  ErrorLoginState get asError => this as ErrorLoginState;

  factory LoginState.initial() {
    return InitialLoginState();
  }

  factory LoginState.loading() {
    return LoadingLoginState();
  }

  factory LoginState.success() {
    return SuccessLoginState();
  }

  factory LoginState.error(String message) {
    return ErrorLoginState(message);
  }
}

class InitialLoginState extends LoginState {}

class SuccessLoginState extends LoginState {}

class LoadingLoginState extends LoginState {}

class ErrorLoginState extends LoginState {
  final String message;

  ErrorLoginState(this.message);
}
