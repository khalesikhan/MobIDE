import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/app_theme.dart';
import 'features/splash/splash_screen.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MobIDE(),
    ),
  );
}

class MobIDE extends StatelessWidget {
  const MobIDE({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MobIDE',
      theme: AppTheme.darkTheme,
      home: const SplashScreen(),
    );
  }
}