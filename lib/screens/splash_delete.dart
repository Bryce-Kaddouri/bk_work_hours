import 'package:flutter/material.dart';

class SplashDeleteScreen extends StatefulWidget {
  const SplashDeleteScreen({super.key});

  @override
  State<SplashDeleteScreen> createState() => _SplashDeleteScreenState();
}

class _SplashDeleteScreenState extends State<SplashDeleteScreen>
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
            child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return FutureBuilder(
                      future: Future.delayed(const Duration(seconds: 3)),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return const Text('Splash Screen');
                        } else {
                          return const CircularProgressIndicator();
                        }
                      });
                })));
  }
}
