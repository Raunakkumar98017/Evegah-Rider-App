import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';

import 'features/auth/presentation/screens/login_screen.dart';

import 'features/notifications/data/services/notification_service.dart';
import 'features/dashboard/presentation/screens/bottom_nav_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🚀 INITIALIZE NOTIFICATIONS
  await NotificationService().init();

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

      home: const BottomNavScreen(),
    );
  }
}
