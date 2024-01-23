import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_block/auth/bloc/auth_status_cubit.dart';
import 'package:learning_block/auth/ui/auth.dart';
import 'package:learning_block/shell/ui/shell.dart';

class SlpashScreen extends StatelessWidget {
  const SlpashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthStatusCubit, AuthStatus>(
        listener: (context, state) {
          print(state.index);
          if (state.index == 0) {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const Shell()),
                (route) => false);
          } else if (state.index == 1) {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const Auth()),
                (route) => false);
          }
        },
        child: Center(
          child: Text('splash'),
        ),
      ),
    );
  }
}
