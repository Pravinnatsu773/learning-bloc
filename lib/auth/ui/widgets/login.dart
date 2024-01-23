// ignore_for_file: must_be_immutable

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_block/auth/bloc/auth_bloc.dart';
import 'package:learning_block/shell/ui/shell.dart';

class LoginPage extends StatelessWidget {
  const LoginPage(
      {super.key,
      required this.moveToSignUpPage,
      required this.emailController,
      required this.passwordController});

  final VoidCallback moveToSignUpPage;

  final TextEditingController emailController;

  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthFailure) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.error)));
        } else if (state is AuthSuccess) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const Shell()),
              (route) => false);
        }
      },
      builder: (context, state) {
        return Column(
          children: [
            Text(
              'Welcome back!',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall!
                  .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 18,
            ),
            Text(
              'Please enter your email and \n password to login.',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(color: Colors.white),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Colors.white,
                  ),
              controller: emailController,
              decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xff111315),
                  hintText: 'Enter your email',
                  hintStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Colors.white.withOpacity(0.7),
                      ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50))),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Colors.white,
                  ),
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xff111315),
                  hintText: 'Enter your password',
                  hintStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Colors.white.withOpacity(0.7),
                      ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50))),
            ),
            const SizedBox(
              height: 20,
            ),
            (state is AuthLoading)
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            context.read<AuthBloc>().login(
                                email: emailController.text.trim(),
                                password: passwordController.text.trim());
                          },
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            // width: MediaQuery.of(context).size.width * 0.6,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Colors.deepPurple),
                            child: const Text(
                              'Login',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
            const SizedBox(
              height: 20,
            ),
            RichText(
                text: TextSpan(
                    text: 'Don\'t have an account? ',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Colors.white,
                        ),
                    children: [
                  TextSpan(
                      text: 'Sign up',
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => moveToSignUpPage(),
                      style: const TextStyle(
                          color: Colors.deepPurple,
                          fontWeight: FontWeight.bold))
                ]))
          ],
        );
      },
    );
  }
}
