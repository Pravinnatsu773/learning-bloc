// bottom_nav_bar.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:learning_block/shell/bloc/shell_bloc.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationCubit, NavigationItem>(
      builder: (context, currentNavItem) {
        return BottomNavigationBar(
          useLegacyColorScheme: false,
          backgroundColor: const Color(0xff1b1d22),
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedLabelStyle: const TextStyle(color: Colors.white),
          unselectedLabelStyle: TextStyle(color: Colors.white.withOpacity(0.8)),
          currentIndex: currentNavItem.index,
          onTap: (index) {
            final nextNavItem = NavigationItem.values[index];
            context.read<NavigationCubit>().navigateTo(nextNavItem);
          },
          items: [
            BottomNavigationBarItem(
              icon: currentNavItem.index == 0
                  ? SvgPicture.asset(
                      'assets/images/exercise-yoga-outline.svg',
                      width: 28,
                    )
                  : SvgPicture.asset(
                      'assets/images/exercise-yoga-outline-unselected.svg',
                      width: 28,
                    ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: currentNavItem.index == 1
                  ? SvgPicture.asset(
                      'assets/images/double-quotes-r.svg',
                      width: 28,
                    )
                  : SvgPicture.asset(
                      'assets/images/double-quotes-r-unselected.svg',
                      width: 28,
                    ),
              label: 'Quotes',
            ),
            BottomNavigationBarItem(
              icon: currentNavItem.index == 2
                  ? const Icon(
                      Icons.group,
                      color: Colors.white,
                      weight: 28,
                    )
                  : Icon(
                      Icons.group,
                      color: Colors.white.withOpacity(0.65),
                      weight: 28,
                    ),
              label: 'Groups',
            ),
          ],
        );
      },
    );
  }
}
