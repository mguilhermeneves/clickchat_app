abstract class SignupState {
  SignupState();

  bool get isLoading => this is LoadingSignupState;
  bool get isSuccess => this is SuccessSignupState;
  bool get isError => this is ErrorSignupState;

  ErrorSignupState get asError => this as ErrorSignupState;

  factory SignupState.initial() {
    return InitialSignupState();
  }

  factory SignupState.loading() {
    return LoadingSignupState();
  }

  factory SignupState.success() {
    return SuccessSignupState();
  }

  factory SignupState.error(String message) {
    return ErrorSignupState(message);
  }
}

class InitialSignupState extends SignupState {}

class SuccessSignupState extends SignupState {}

class LoadingSignupState extends SignupState {}

class ErrorSignupState extends SignupState {
  final String message;

  ErrorSignupState(this.message);
}
