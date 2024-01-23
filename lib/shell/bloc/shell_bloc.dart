// navigation_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';

enum NavigationItem { home, quotes, groups }

class NavigationCubit extends Cubit<NavigationItem> {
  NavigationCubit() : super(NavigationItem.home);

  void navigateTo(NavigationItem item) => emit(item);
}
