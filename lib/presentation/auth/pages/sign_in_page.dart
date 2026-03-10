import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_list/core/di/injection.dart';
import 'package:to_do_list/core/theme/app_theme.dart';
import 'package:to_do_list/domain/auth/usecases/auth_usecases.dart';
import 'package:to_do_list/presentation/auth/bloc/auth_bloc.dart';
import 'package:to_do_list/presentation/auth/pages/sign_up_page.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Gradient Header
            Container(
              height: 320,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(80),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.check_circle_outline, color: Colors.white, size: 60),
                    const SizedBox(height: 20),
                    Text(
                      'Ultimate To-Do',
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                            color: Colors.white,
                            fontSize: 36,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Welcome back! Please login\nto manage your daily tasks.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Login Form
            Padding(
              padding: const EdgeInsets.all(32),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Email Address',
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                      validator: (value) => (value == null || value.isEmpty) ? 'Required' : null,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        prefixIcon: Icon(Icons.lock_outline),
                      ),
                      validator: (value) => (value == null || value.isEmpty) ? 'Required' : null,
                    ),
                    const SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _signIn,
                      child: _isLoading
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
                            )
                          : const Text('Sign In'),
                    ),
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "New here? ",
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const SignUpPage()),
                          ),
                          child: const Text(
                            "Create Account",
                            style: TextStyle(
                              color: AppTheme.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _signIn() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      final logIn = getIt<LogIn>();
      final result = await logIn(_emailController.text, _passwordController.text);
      if (mounted) setState(() => _isLoading = false);
      
      result.fold(
        (l) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l.map(
                serverError: (_) => 'Server Error',
                networkError: (_) => 'Network Connection Failed',
                authenticationFailure: (e) => e.message,
                unexpectedError: (_) => 'An unexpected error occurred',
              )),
              backgroundColor: Colors.redAccent,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          );
        },
        (r) {
          context.read<AuthBloc>().add(const AuthEvent.authCheckRequested());
        },
      );
    }
  }
}

