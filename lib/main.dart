import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/screens/login_screen.dart';

void main() {
  runApp(const EvegahApp());
}

class EvegahApp extends StatelessWidget {
  const EvegahApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Evegah Rider',
      theme: AppTheme.lightTheme,
      home: const LoginScreen(),
    );
  }
}