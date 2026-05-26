import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// 🚨 Make sure these imports match your actual file paths!
import '../screens/login_screen.dart';
import '../../../dashboard/presentation/screens/main_navigation.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    // 1. Look for the token in the device's local storage
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('access_token');

    // 2. Add a tiny delay so the screen doesn't instantly flash (feels more premium)
    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;

    // 3. Route the user based on whether they have a token!
    if (token != null && token.isNotEmpty) {
      // 🟢 Token exists -> Auto-login to Main App
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainNavigation()),
      );
    } else {
      // 🔴 No token -> Go to Login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // This is the "Splash Screen" the user sees for half a second while the app checks their login status.
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        // You can replace this with your EVegah App Logo later!
        child: CircularProgressIndicator(color: Colors.green),
      ),
    );
  }
}