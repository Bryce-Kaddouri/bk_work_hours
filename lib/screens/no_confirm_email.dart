import 'package:bk_work_hours/api.dart';
import 'package:bk_work_hours/screens/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NoConfirmEmailScreen extends StatefulWidget {
  const NoConfirmEmailScreen({super.key});

  @override
  State<NoConfirmEmailScreen> createState() => _NoConfirmEmailScreenState();
}

class _NoConfirmEmailScreenState extends State<NoConfirmEmailScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Text('Please confirm your email');
                }),
            Text('Please confirm your email', style: TextStyle(fontSize: 20)),
            ElevatedButton(
              onPressed: () async {
                // refresh the page
                User? user = await ApiInit().getCurrentUser();
                if (user != null) {
                  await user.reload();
                  user = await ApiInit().getCurrentUser();
                  if (user!.emailVerified) {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomeScreen()));
                  }
                }
              },
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
