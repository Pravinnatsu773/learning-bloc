import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:learning_block/auth/bloc/auth_bloc.dart';
import 'package:learning_block/auth/bloc/auth_status_cubit.dart';
import 'package:learning_block/auth/ui/auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_block/create_profile_screen/cubit/create_profile_cubit.dart';
import 'package:learning_block/create_profile_screen/ui/create_profile_screen.dart';
import 'package:learning_block/firebase_options.dart';
import 'package:learning_block/groups/cubit/group_cubit.dart';
import 'package:learning_block/home/bloc/home_bloc.dart';
import 'package:learning_block/meditation_screen/cubit/meditation_cubit.dart';
import 'package:learning_block/profile/cubit/user_cubit.dart';
import 'package:learning_block/quotes/cubit/quotes_cubit.dart';
import 'package:learning_block/shell/bloc/shell_bloc.dart';
import 'package:learning_block/shell/ui/shell.dart';
import 'package:learning_block/splash_screen/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthStatusCubit()..checkAuthStatus(),
        ),
        BlocProvider(
          create: (context) => UserCubit()..setUser(),
        ),
        BlocProvider(
          create: (context) => AuthBloc(),
        ),
        BlocProvider(
          create: (context) => NavigationCubit(),
        ),
        BlocProvider(
          create: (context) => HomeCubit(),
        ),
        BlocProvider(
          create: (context) => MeditationCubit(),
        ),
        BlocProvider(
          create: (context) => QuotesCubit(),
        ),
        BlocProvider(
          create: (context) => GroupCubit(),
        ),
        BlocProvider(
          create: (context) => CreateProfileCubit(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Learning BLoC',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const SlpashScreen(),
      ),
    );
  }
}
