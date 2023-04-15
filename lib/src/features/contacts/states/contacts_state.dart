import '../../../global/models/contact_model.dart';

abstract class ContactsState {
  ContactsState();

  bool get isInitial => this is InitialContactsState;
  bool get isLoading => this is LoadingContactsState;
  bool get isSuccess => this is SuccessContactsState;
  bool get isError => this is ErrorContactsState;

  SuccessContactsState get asSuccess => this as SuccessContactsState;
  ErrorContactsState get asError => this as ErrorContactsState;

  factory ContactsState.initial() {
    return InitialContactsState();
  }

  factory ContactsState.loading() {
    return LoadingContactsState();
  }

  factory ContactsState.success(Stream<List<ContactModel>> contacts) {
    return SuccessContactsState(contacts);
  }

  factory ContactsState.error(String message) {
    return ErrorContactsState(message);
  }
}

class InitialContactsState extends ContactsState {}

class SuccessContactsState extends ContactsState {
  final Stream<List<ContactModel>> contacts;

  SuccessContactsState(this.contacts);
}

class LoadingContactsState extends ContactsState {}

class ErrorContactsState extends ContactsState {
  final String message;

  ErrorContactsState(this.message);
}
