import 'package:flutter/material.dart';

import '../../../dashboard/presentation/screens/dashboard_screen.dart';

import '../../../wallet/presentation/screens/wallet_screen.dart';

import '../../../unlock/presentation/screens/ride_history_screen.dart';

import '../../../notifications/presentation/screens/notification_screen.dart';

class BottomNavScreen extends StatefulWidget {
  const BottomNavScreen({super.key});

  @override
  State<BottomNavScreen> createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  int currentIndex = 0;

  final List<Widget> screens = [
    const DashboardScreen(),

    const WalletScreen(),

    const RideHistoryScreen(),

    const NotificationScreen(),

    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex],

      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 20),
          ],
        ),

        child: BottomNavigationBar(
          currentIndex: currentIndex,

          onTap: (index) {
            setState(() {
              currentIndex = index;
            });
          },

          selectedItemColor: Colors.green,

          unselectedItemColor: Colors.grey,

          type: BottomNavigationBarType.fixed,

          elevation: 0,

          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),

            BottomNavigationBarItem(
              icon: Icon(Icons.account_balance_wallet),

              label: "Wallet",
            ),

            BottomNavigationBarItem(icon: Icon(Icons.history), label: "Rides"),

            BottomNavigationBarItem(
              icon: Icon(Icons.notifications),

              label: "Alerts",
            ),

            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          ],
        ),
      ),
    );
  }
}

// 🚀 TEMP PROFILE SCREEN
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),

      appBar: AppBar(
        backgroundColor: Colors.transparent,

        elevation: 0,

        title: const Text(
          "Profile",

          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            CircleAvatar(
              radius: 50,

              backgroundColor: Colors.green.shade100,

              child: const Icon(Icons.person, size: 50, color: Colors.green),
            ),

            const SizedBox(height: 20),

            const Text(
              "eVegah Rider",

              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            const Text("EV Mobility User 🚀"),
          ],
        ),
      ),
    );
  }
}
