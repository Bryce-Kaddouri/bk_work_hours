import 'package:bk_work_hours/api.dart';
import 'package:bk_work_hours/screens/home.dart';
import 'package:bk_work_hours/screens/no_confirm_email.dart';
import 'package:bk_work_hours/screens/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // global key for the form
  final _formKey = GlobalKey<FormState>();
  // controller for the email field
  final _emailController = TextEditingController();
  // controller for the password field
  final _passwordController = TextEditingController();
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
                }
                return null;
              },
            ),
            TextButton(
              onPressed: () {
                context.go('/forgot-password');
              },
              child: const Text('Forgot Password'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SignupScreen()));
              },
              child: const Text('Signup'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  print('Email: ${_emailController.text}');
                  print('Password: ${_passwordController.text}');
                  User? user = await ApiInit()
                      .signIn(_emailController.text, _passwordController.text);
                  if (user != null) {
                    if (user.emailVerified) {
                      // Navigator.of(context).pushNamed('/home');
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomeScreen()));
                    } else {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const NoConfirmEmailScreen()));
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Invalid email or password'),
                      ),
                    );
                  }
                }
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      )),
    );
  }
}
