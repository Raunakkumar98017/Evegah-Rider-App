import 'package:flutter/material.dart';
import '../../../dashboard/presentation/screens/dashboard_screen.dart';
import '../../../profile/presentation/screens/profile_screen.dart';
import '../../../wallet/presentation/screens/wallet_screen.dart';
import '../../../notifications/presentation/screens/notification_screen.dart';
import '../../../rides/presentation/screen/ride_history_screen.dart';
import '../../../unlock/presentation/screens/scan_qr_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  // Start at Wallet tab (index 3) to show the new screen directly
  int _currentIndex = 3;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const RideHistoryScreen(), // Bookings
    const DashboardScreen(), // Scan (Placeholder for now)
    const WalletScreen(), // Wallet
    const ProfileScreen(), // Profile
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        height: 90, // Taller to accommodate the bubble effect
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, -5),
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildNavItem(0, "Home", Icons.home_filled, Icons.home_outlined),
              _buildNavItem(1, "Bookings", Icons.assignment, Icons.assignment_outlined),
              _buildScanItem(),
              _buildNavItem(3, "Wallet", Icons.account_balance_wallet, Icons.account_balance_wallet_outlined),
              _buildNavItem(4, "Profile", Icons.person, Icons.person_outline),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, String label, IconData selectedIcon, IconData unselectedIcon) {
    bool isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(isSelected ? 16 : 8),
            decoration: isSelected
                ? BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      )
                    ],
                  )
                : const BoxDecoration(color: Colors.transparent),
            child: Icon(
              isSelected ? selectedIcon : unselectedIcon,
              size: isSelected ? 28 : 24,
              color: isSelected ? const Color(0xFF3E1E90) : Colors.grey.shade600,
            ),
          ),
          if (!isSelected) const SizedBox(height: 4),
          if (!isSelected)
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w600,
              ),
            ),
          if (isSelected) const SizedBox(height: 4),
          if (isSelected)
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF3E1E90),
                fontWeight: FontWeight.bold,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildScanItem() {
    bool isSelected = _currentIndex == 2;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ScanQrScreen()),
        );
      },
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: const BoxDecoration(
              color: Color(0xFFD6F53D), // Lime Green
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.qr_code_scanner,
              size: 26,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Scan",
            style: TextStyle(
              fontSize: 11,
              color: isSelected ? const Color(0xFF3E1E90) : Colors.grey.shade800,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}