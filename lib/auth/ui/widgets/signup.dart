import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_block/auth/bloc/auth_bloc.dart';
import 'package:learning_block/create_profile_screen/ui/create_profile_screen.dart';
import 'package:learning_block/home/ui/home.dart';
import 'package:learning_block/shell/ui/shell.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage(
      {super.key,
      required this.moveToLoginUpPage,
      required this.emailController,
      required this.passwordController});

  final VoidCallback moveToLoginUpPage;

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
              MaterialPageRoute(
                  builder: (context) => const CreateProfileScreen()),
              (route) => false);
        }
      },
      builder: (context, state) {
        return Column(
          children: [
            Text(
              'Create an account',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall!
                  .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 18,
            ),
            Text(
              'Please enter your email and \n password to create an account.',
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
                            context.read<AuthBloc>().signUp(
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
                              'Sign Up',
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
                    text: 'Already have an account? ',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Colors.white,
                        ),
                    children: [
                  TextSpan(
                      text: 'Login',
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => moveToLoginUpPage(),
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
