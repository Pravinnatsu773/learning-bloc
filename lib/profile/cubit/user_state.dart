part of 'user_cubit.dart';

@immutable
sealed class UserState {}

final class UserInitial extends UserState {}

class UserLoaded extends UserState {
  final User user;

  UserLoaded(this.user);
}

class UserError extends UserState {
  final String error;

  UserError(this.error);
}
