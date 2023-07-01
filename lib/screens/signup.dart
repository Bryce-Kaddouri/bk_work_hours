import 'package:bk_work_hours/api.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import 'login.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // global key for the form
  final _formKey = GlobalKey<FormState>();
  // controller for the email field
  final _emailController = TextEditingController();
  // controller for the password field
  final _passwordController = TextEditingController();
  // controller for the password confirmation field
  final _passwordConfirmationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                hintText: 'Email',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(
                hintText: 'Password',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                } else if (value.length < 12) {
                  return 'Password must be at least 6 characters';
                } else if (!value.contains(RegExp(r'[A-Z]'))) {
                  return 'Password must contain at least one uppercase letter';
                } else if (!value.contains(RegExp(r'[a-z]'))) {
                  return 'Password must contain at least one lowercase letter';
                } else if (!value.contains(RegExp(r'[0-9]'))) {
                  return 'Password must contain at least one number';
                } else if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
                  return 'Password must contain at least one special character';
                }

                return null;
              },
            ),
            TextFormField(
              controller: _passwordConfirmationController,
              decoration: const InputDecoration(
                hintText: 'Password Confirmation',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password confirmation';
                }
                if (value != _passwordController.text) {
                  return 'Password confirmation does not match';
                }
                return null;
              },
            ),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  print('Email: ${_emailController.text}');
                  print('Password: ${_passwordController.text}');
                  print(
                      'Password Confirmation: ${_passwordConfirmationController.text}');
                  User? user = await ApiInit().signUp(
                    _emailController.text,
                    _passwordController.text,
                  );

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        user == null
                            ? 'Sign up failed'
                            : 'Sign up successful. Please check your email for verification',
                      ),
                    ),
                  );

                  // Navigator.of(context).pushNamed('/signin');
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()));
                }
              },
              child: const Text('Sign Up'),
            ),
            TextButton(
              onPressed: () {
                // context.go()
              },
              child: const Text('Login'),
            ),
          ],
        ),
      )),
    );
  }
}
