import 'package:flutter/material.dart';
import 'map_discovery_screen.dart';

import '../../../auth/presentation/screens/create_profile_screen.dart';
import '../../../unlock/presentation/screens/bluetooth_unlock_screen.dart';
import '../../../unlock/presentation/screens/scan_qr_screen.dart';
import '../../../rides/presentation/screen/ride_history_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int selectedIndex = 0;

  // 🚨 UI TOGGLE: Change this to 'true' to see the Active Ride dashboard!
  // Later, this will be controlled by your backend API (getLastRideBookingDetails)
  bool hasActiveRide = false; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            left: 22,
            right: 22,
            top: 18,
            bottom: MediaQuery.of(context).padding.bottom + 120,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- TOP BAR ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "⚡ EVegah Rider",
                        style: TextStyle(
                          color: Color(0xFF111827),
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        "Ride Smart. Ride Green.",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 15,
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
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            Colors.green.shade400,
                            Colors.purple.shade300,
                          ],
                        ),
                      ),
                      child: const CircleAvatar(
                        radius: 27,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.person,
                          color: Color(0xFF22C55E),
                          size: 30,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // --- 🚨 DYNAMIC HERO CARD ---
              // This automatically changes depending on if the user is riding or not!
              hasActiveRide ? _buildActiveRideCard() : _buildIdleCard(),

              const SizedBox(height: 34),

              // --- QUICK ACTIONS ---
              const Text(
                "Quick Actions",
                style: TextStyle(
                  color: Color(0xFF111827),
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 22),

              GridView.count(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                crossAxisCount: 2,
                crossAxisSpacing: 18,
                mainAxisSpacing: 18,
                childAspectRatio: 0.90,
                children: [
                  buildActionCard(
                    context,
                    icon: Icons.qr_code_scanner_rounded,
                    title: "Scan EV",
                    subtitle: "Unlock instantly",
                    color: Colors.green,
                    bg: Colors.green.shade50,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ScanQrScreen(),
                        ),
                      );
                    },
                  ),
                  buildActionCard(
                    context,
                    icon: Icons.bluetooth_rounded,
                    title: "Bluetooth",
                    subtitle: "Nearby unlock",
                    color: Colors.purple,
                    bg: Colors.purple.shade50,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const BluetoothUnlockScreen(),
                        ),
                      );
                    },
                  ),
                  buildActionCard(
                    context,
                    icon: Icons.map_rounded,
                    title: "Smart Maps",
                    subtitle: "Nearby rides",
                    color: Colors.orange,
                    bg: Colors.orange.shade50,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MapDiscoveryScreen(),
                        ),
                      );
                    },
                  ),
                  buildActionCard(
                    context,
                    icon: Icons.history_rounded,
                    title: "Ride History",
                    subtitle: "Past trips",
                    color: Colors.blue,
                    bg: Colors.blue.shade50,
                    onTap: () {

                      // 🚨 NEXT STEP: Navigate to Ride History Screen!
                     Navigator.push(
                     context,
                      MaterialPageRoute(builder: (context) => const RideHistoryScreen()),
                    );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 🚨 NEW WIDGET: The Idle Card (Shows Wallet & Stats)
  // ---------------------------------------------------------------------------
  Widget _buildIdleCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(34),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.green.shade400,
            Colors.green.shade500,
            Colors.purple.shade400,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.22),
            blurRadius: 28,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.waving_hand_rounded, color: Colors.white, size: 36),
              SizedBox(width: 16),
              Expanded(
                child: Text(
                  "Welcome Back",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Makes much more sense! Wallet balance is crucial before starting a ride.
              buildHeroStat("₹ 240", "Wallet"),
              buildHeroStat("12.4kg", "CO₂ Saved"),
              buildHeroStat("14", "Total Trips"),
            ],
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 🚨 NEW WIDGET: The Active Ride Card (Shows Live Ride Data)
  // ---------------------------------------------------------------------------
  Widget _buildActiveRideCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(34),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF1E1452), // Deep Evegah Purple
            Colors.blue.shade800,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E1452).withOpacity(0.3),
            blurRadius: 28,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.electric_bike, color: Colors.white, size: 40),
              SizedBox(width: 16),
              Expanded(
                child: Text(
                  "Ride in Progress",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // Optional: Add a pulsing green dot to show it's "Live"
              Icon(Icons.circle, color: Colors.greenAccent, size: 12),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildHeroStat("14:02", "Duration"),
              buildHeroStat("87%", "Battery"),
              buildHeroStat("2.4km", "Distance"),
            ],
          ),
          const SizedBox(height: 24),
          // A mini button to jump straight to the Ride Map/Dashboard
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () {
                // Navigate to the live Ride Screen
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white.withOpacity(0.2),
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: const Text("View Live Ride", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          )
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // HELPER METHODS (Unchanged)
  // ---------------------------------------------------------------------------
  Widget buildHeroStat(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget buildActionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required Color bg,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 14,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
              ),
              child: Icon(icon, color: color, size: 34),
            ),
            const Spacer(),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Color(0xFF111827),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}