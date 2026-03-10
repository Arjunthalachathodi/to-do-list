import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_list/core/di/injection.dart';
import 'package:to_do_list/core/theme/app_theme.dart';
import 'package:to_do_list/presentation/auth/bloc/auth_bloc.dart';
import 'package:to_do_list/presentation/auth/pages/sign_in_page.dart';
import 'package:to_do_list/presentation/tasks/bloc/task_bloc.dart';
import 'package:to_do_list/presentation/tasks/pages/home_page.dart';
import 'package:to_do_list/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await configureInjection();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<AuthBloc>()..add(const AuthEvent.authCheckRequested()),
        ),
        BlocProvider(
          create: (context) => getIt<TaskBloc>(),
        ),
      ],
      child: MaterialApp(
        title: 'To-Do List',
        theme: AppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        home: const AuthWrapper(),
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return state.map(
          initial: (_) => const Scaffold(body: Center(child: CircularProgressIndicator())),
          authenticated: (e) => HomePage(userId: e.user.uid),
          unauthenticated: (_) => const SignInPage(),
        );
      },
    );
  }
}
