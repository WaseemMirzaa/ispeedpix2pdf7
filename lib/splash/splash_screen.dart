import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(seconds: 3), () {
      if (!mounted) return;
      context.go('/converter');
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFE0E3E7),
      alignment: Alignment.center,
      child: Image.asset(
        'assets/images/70769789-ECA9-4E75-AE97-86FF559889DF.jpg',
        width: 300,
        height: 300,
        fit: BoxFit.contain,
      ),
    );
  }
}

