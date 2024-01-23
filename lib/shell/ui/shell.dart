import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_block/groups/ui/groups_screen.dart';
import 'package:learning_block/home/ui/home.dart';
import 'package:learning_block/quotes/ui/quotes_screen.dart';
import 'package:learning_block/shell/bloc/shell_bloc.dart';
import 'package:learning_block/shell/ui/widgets/bottom_navbar.dart';

class Shell extends StatelessWidget {
  const Shell({super.key});

  static final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff111315),
      body: BlocConsumer<NavigationCubit, NavigationItem>(
        listener: (context, currentNavItem) {
          _pageController.animateToPage(currentNavItem.index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeIn);
        },
        builder: (context, currentNavItem) {
          return SafeArea(
            child: PageView(
              controller: _pageController,
              children: [Home(), QuotesScreen(), GroupsScreen()],
            ),
          );
        },
      ),
      bottomNavigationBar: const CustomBottomNavBar(),
    );
  }
}
