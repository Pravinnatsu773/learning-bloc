part of 'create_profile_cubit.dart';

@immutable
sealed class CreateProfileState {}

final class CreateProfileInitial extends CreateProfileState {}

final class CreateProfileAvatarFetchSuccess extends CreateProfileState {
  final List images;

  CreateProfileAvatarFetchSuccess({required this.images});
}

final class CreateProfileSuccess extends CreateProfileState {}

final class CreateProfileLoading extends CreateProfileState {}
