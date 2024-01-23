import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AuthStatus { authenticated, unauthenticated, unknown }

class AuthStatusCubit extends Cubit<AuthStatus> {
  AuthStatusCubit() : super(AuthStatus.unknown);

  Future<void> checkAuthStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String uid = prefs.getString('uid') ?? '';
    print(uid);
    if (uid.isEmpty) {
    
      emit(AuthStatus.unauthenticated);
    } else {
      emit(AuthStatus.authenticated);
    }
  }
}
