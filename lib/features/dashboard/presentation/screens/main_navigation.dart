import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../dashboard/presentation/screens/dashboard_screen.dart';
import '../../../dashboard/presentation/screens/map_discovery_screen.dart';
import '../../../profile/presentation/screens/profile_screen.dart';
import '../../../wallet/presentation/screens/wallet_screen.dart';
import '../../../rides/presentation/screen/ride_history_screen.dart';
import '../../../unlock/presentation/screens/scan_qr_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  // Start at Home tab (index 0)
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const MapDiscoveryScreen(), // Home
    const RideHistoryScreen(), // Bookings
    const DashboardScreen(), // Scan (Placeholder for now, although Scan pushes a route)
    const WalletScreen(), // Wallet
    const ProfileScreen(), // Profile
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        height: 90,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
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
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      )
                    ],
                  )
                : const BoxDecoration(color: Colors.transparent),
            child: Icon(
              isSelected ? selectedIcon : unselectedIcon,
              size: isSelected ? 28 : 24,
              color: isSelected ? const Color(0xFF4B1DB8) : Colors.grey.shade600, // Design: Primary Purple
            ),
          ),
          if (!isSelected) const SizedBox(height: 4),
          if (!isSelected)
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 11,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w600,
              ),
            ),
          if (isSelected) const SizedBox(height: 4),
          if (isSelected)
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: const Color(0xFF4B1DB8), // Design: Primary Purple
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
              color: Color(0xFFD8F238), // Design: Lime Green
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
            style: GoogleFonts.poppins(
              fontSize: 11,
              color: isSelected ? const Color(0xFF4B1DB8) : Colors.grey.shade800,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}