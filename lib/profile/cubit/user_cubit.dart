import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_block/profile/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserInitial());

  Future<void> setUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final user = User(
        uid: prefs.getString('uid') ?? '',
        name: prefs.getString('name') ?? '',
        email: prefs.getString('email') ?? '',
        profilepic: prefs.getString('profile-pic') ?? '');

    emit(UserLoaded(user));
  }

  void setError(String error) {
    emit(UserError(error));
  }
}
