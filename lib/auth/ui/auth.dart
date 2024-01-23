import 'package:flutter/material.dart';
import 'package:learning_block/auth/ui/widgets/login.dart';
import 'package:learning_block/auth/ui/widgets/signup.dart';

class Auth extends StatelessWidget {
  const Auth({super.key});

  static final _pageController = PageController();

  static final emailController = TextEditingController();

  static final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff111315),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Image.network(
                'https://images.pexels.com/photos/4954706/pexels-photo-4954706.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
                bottom: 0,
                child: Container(
                  // padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20)),
                      color: Color(0xff1b1d22)),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: PageView(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: _pageController,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: LoginPage(
                          emailController: emailController,
                          passwordController: passwordController,
                          moveToSignUpPage: () {
                            _pageController.nextPage(
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeIn);
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SignUpPage(
                          emailController: emailController,
                          passwordController: passwordController,
                          moveToLoginUpPage: () {
                            _pageController.previousPage(
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeIn);
                          },
                        ),
                      )
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
