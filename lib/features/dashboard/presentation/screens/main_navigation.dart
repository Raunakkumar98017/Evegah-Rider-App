import 'package:flutter/material.dart';
import '../../../dashboard/presentation/screens/dashboard_screen.dart';
import '../../../profile/presentation/screens/profile_screen.dart';
import '../../../wallet/presentation/screens/wallet_screen.dart';
import '../../../notifications/presentation/screens/notification_screen.dart';
import '../../../rides/presentation/screen/ride_history_screen.dart'; 
// (Adjust the path if you saved it somewhere else!)

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  // This variable remembers which tab is currently selected (Starts at 0: Home)
  int _currentIndex = 0;

  // These are the placeholder screens. We will replace these with your actual 
  // WalletScreen, ProfileScreen, etc., as we build them!
  final List<Widget> _screens = [
    const DashboardScreen(),
    const WalletScreen(),
    const RideHistoryScreen(),
    const NotificationScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The body changes based on which tab is tapped
      body: _screens[_currentIndex],
      
      // The actual Bottom Navigation Bar
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            )
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            // When a tab is clicked, update the state to switch the screen
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed, // Forces all 5 icons to stay visible
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFF4CAF50), // EV Green
          unselectedItemColor: Colors.grey.shade400,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet), label: "Wallet"),
            BottomNavigationBarItem(icon: Icon(Icons.history), label: "Rides"),
            BottomNavigationBarItem(icon: Icon(Icons.notifications), label: "Alerts"),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          ],
        ),
      ),
    );
  }

  // A quick helper widget just to make our placeholders look nice
 /* static Widget _buildPlaceholder(String title, IconData icon, Color color) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 80, color: color.withOpacity(0.5)),
          const SizedBox(height: 16),
          Text(
            title, 
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87)
          ),
          const SizedBox(height: 8),
          const Text("Screen architecture coming soon...", style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }*/
}