import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'auth_state.dart';

class AuthBloc extends Cubit<AuthState> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  AuthBloc() : super(AuthInitial());

  login({required String email, required String password}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    emit(AuthLoading());
    try {
      if (email.isEmpty) {
        emit(AuthFailure(error: 'Please enter email'));

        return;
      }
      if (password.length < 8) {
        emit(AuthFailure(error: 'Password must be atleast 8 characters long'));

        return;
      }

      UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user != null) {
        prefs.setString('uid', userCredential.user!.uid);
        return emit(AuthSuccess(uid: 'xyz'));
      } else {
        return emit(AuthFailure(error: 'Something went wrong!'));
      }
    } catch (e) {
      return emit(AuthFailure(error: e.toString()));
    }
  }

  signUp({required String email, required String password}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    {
      emit(AuthLoading());
      try {
        if (email.isEmpty) {
          emit(AuthFailure(error: 'Please enter email'));

          return;
        }
        if (password.length < 8) {
          emit(
              AuthFailure(error: 'Password must be atleast 8 characters long'));

          return;
        }

        UserCredential userCredential =
            await _firebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        if (userCredential.user != null) {
          prefs.setString('uid', userCredential.user!.uid);
          return emit(AuthSuccess(uid: 'xyz'));
        } else {
          return emit(AuthFailure(error: 'Something went wrong!'));
        }
      } catch (e) {
        return emit(AuthFailure(error: e.toString()));
      }
    }
  }
}
