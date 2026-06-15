import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'map_discovery_screen.dart';

import '../../../auth/presentation/screens/create_profile_screen.dart';
import '../../../unlock/presentation/screens/bluetooth_unlock_screen.dart';
import '../../../unlock/presentation/screens/scan_qr_screen.dart';
import '../../../rides/presentation/screen/ride_history_screen.dart';
import '../../../battery/presentation/screens/battery_dashboard_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  
  // 🚨 UI TOGGLE: Change this to 'true' to see the Active Ride dashboard elements!
  bool hasActiveRide = true; 

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Determine number of columns for grid based on screen width
    int crossAxisCount = MediaQuery.of(context).size.width > 600 ? 3 : 2;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 16,
              bottom: MediaQuery.of(context).padding.bottom + 100,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 24),
                _buildHeroCard(),
                if (hasActiveRide) ...[
                  const SizedBox(height: 20),
                  _buildActiveVehicleCard(),
                ],
                const SizedBox(height: 28),
                Text(
                  "Quick Actions",
                  style: GoogleFonts.poppins(
                    color: const Color(0xFF1E1452),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                GridView.count(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: 1.05,
                  children: [
                    _buildActionCard(
                      context,
                      icon: Icons.qr_code_scanner_rounded,
                      title: "Scan Vehicle",
                      color: Colors.green.shade600,
                      bg: Colors.green.shade50,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ScanQrScreen())),
                    ),
                    _buildActionCard(
                      context,
                      icon: Icons.bluetooth_connected_rounded,
                      title: "Connect Vehicle",
                      color: const Color(0xFF4B1DB8),
                      bg: const Color(0xFF2A1B70).withValues(alpha: 0.08),
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BluetoothUnlockScreen())),
                    ),
                    _buildActionCard(
                      context,
                      icon: Icons.battery_charging_full_rounded,
                      title: "My Battery",
                      color: const Color(0xFF1E1452),
                      bg: const Color(0xFFD8F238).withValues(alpha: 0.25),
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BatteryDashboardScreen())),
                    ),
                    _buildActionCard(
                      context,
                      icon: Icons.history_rounded,
                      title: "Ride History",
                      color: Colors.blue.shade600,
                      bg: Colors.blue.shade50,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RideHistoryScreen())),
                    ),
                    _buildActionCard(
                      context,
                      icon: Icons.map_rounded,
                      title: "Smart Maps",
                      color: Colors.orange.shade600,
                      bg: Colors.orange.shade50,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MapDiscoveryScreen())),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                Text(
                  "Recent Activity",
                  style: GoogleFonts.poppins(
                    color: const Color(0xFF1E1452),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _buildRecentRideCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset(
                  'assets/Evegah_login_page_logo.png',
                  height: 22,
                  errorBuilder: (context, error, stackTrace) => Text(
                    "EVagah",
                    style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: const Color(0xFF4B1DB8)),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.green.shade200),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "Connected",
                        style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.green.shade700),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              "Hello, Daksh",
              style: GoogleFonts.poppins(
                color: const Color(0xFF1E1452),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CreateProfileScreen(),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFD8F238), width: 2),
            ),
            child: const CircleAvatar(
              radius: 22,
              backgroundColor: Color(0xFF1E1452),
              child: Text("DP", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeroCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2A1B70), Color(0xFF4B1DB8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4B1DB8).withValues(alpha: 0.35),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            top: -20,
            child: Icon(Icons.account_balance_wallet, size: 140, color: Colors.white.withValues(alpha: 0.04)),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Wallet Balance",
                style: GoogleFonts.poppins(color: Colors.white.withValues(alpha: 0.8), fontSize: 13, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 4),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "₹240",
                    style: GoogleFonts.poppins(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold, height: 1.1),
                  ),
                  const SizedBox(width: 4),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Text(
                      ".00",
                      style: GoogleFonts.poppins(color: Colors.white.withValues(alpha: 0.7), fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildHeroStat("14", "Total Rides"),
                    Container(width: 1, height: 30, color: Colors.white.withValues(alpha: 0.2)),
                    _buildHeroStat("12.4 kg", "CO₂ Saved"),
                    Container(width: 1, height: 30, color: Colors.white.withValues(alpha: 0.2)),
                    _buildHeroStat(hasActiveRide ? "EVG-102" : "None", "Active Vehicle"),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeroStat(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.poppins(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: GoogleFonts.poppins(color: Colors.white.withValues(alpha: 0.7), fontSize: 11),
        ),
      ],
    );
  }

  Widget _buildActiveVehicleCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 15, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFD8F238).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.electric_scooter, color: Color(0xFF1E1452), size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Assigned Vehicle",
                      style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey.shade500),
                    ),
                    Text(
                      "EVG-SCOOTER-102",
                      style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xFF1E1452)),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "Connected",
                  style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.green.shade700),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Divider(color: Colors.grey.shade100, thickness: 1),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(Icons.battery_charging_full_rounded, color: const Color(0xFF4B1DB8), size: 20),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Battery", style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey.shade500)),
                        Text("87%", style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: const Color(0xFF1E1452))),
                      ],
                    ),
                  ],
                ),
              ),
              Container(width: 1, height: 30, color: Colors.grey.shade200),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Row(
                    children: [
                      Icon(Icons.route_rounded, color: const Color(0xFF4B1DB8), size: 20),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Est. Range", style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey.shade500)),
                          Text("42 km", style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: const Color(0xFF1E1452))),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Color color,
    required Color bg,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey.shade100, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: bg,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const Spacer(),
              Text(
                title,
                maxLines: 2,
                style: GoogleFonts.poppins(
                  color: const Color(0xFF1E1452),
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentRideCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 15, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.history_rounded, color: Colors.blue.shade600, size: 18),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "Last Ride",
                    style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold, color: const Color(0xFF1E1452)),
                  ),
                ],
              ),
              Text(
                "Yesterday, 4:30 PM",
                style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey.shade500),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildRideStat("4.2 km", "Distance"),
              _buildRideStat("18 min", "Duration"),
              _buildRideStat("₹ 45", "Cost", isHighlight: true),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRideStat(String value, String label, {bool isHighlight = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isHighlight ? const Color(0xFF4B1DB8) : const Color(0xFF1E1452),
          ),
        ),
        Text(
          label,
          style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey.shade500),
        ),
      ],
    );
  }
}