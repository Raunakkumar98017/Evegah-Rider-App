import 'package:flutter/material.dart';

import '../../../auth/presentation/screens/create_profile_screen.dart';
import '../../../unlock/presentation/screens/bluetooth_unlock_screen.dart';
import '../../../unlock/presentation/screens/scan_qr_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int selectedIndex = 0;

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
              // TOP BAR
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

                        style: TextStyle(color: Colors.grey, fontSize: 15),
                      ),
                    ],
                  ),

                  // PROFILE BUTTON
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

              // HERO CARD
              Container(
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
                        Icon(
                          Icons.electric_bike,

                          color: Colors.white,

                          size: 44,
                        ),

                        SizedBox(width: 16),

                        Expanded(
                          child: Text(
                            "Welcome Back 🚀",

                            style: TextStyle(
                              color: Colors.white,

                              fontSize: 28,

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
                        buildHeroStat("23", "Nearby EVs"),

                        buildHeroStat("12.4kg", "CO₂ Saved"),

                        buildHeroStat("87%", "Battery"),
                      ],
                    ),

                    const SizedBox(height: 28),

                    Container(
                      padding: const EdgeInsets.all(18),

                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.18),

                        borderRadius: BorderRadius.circular(24),
                      ),

                      child: Row(
                        children: const [
                          Icon(Icons.auto_awesome, color: Colors.white),

                          SizedBox(width: 14),

                          Expanded(
                            child: Text(
                              "AI found a fully charged EV only 120m away ⚡",

                              style: TextStyle(
                                color: Colors.white,

                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 34),

              // TITLE
              const Text(
                "Quick Actions",

                style: TextStyle(
                  color: Color(0xFF111827),

                  fontSize: 26,

                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 22),

              // ACTION GRID
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

                    onTap: () {},
                  ),

                  buildActionCard(
                    context,

                    icon: Icons.history_rounded,

                    title: "Ride History",

                    subtitle: "Past trips",

                    color: Colors.blue,

                    bg: Colors.blue.shade50,

                    onTap: () {},
                  ),
                ],
              ),

              const SizedBox(height: 34),

              // LIVE STATUS
              Container(
                padding: const EdgeInsets.all(24),

                decoration: BoxDecoration(
                  color: Colors.white,

                  borderRadius: BorderRadius.circular(30),

                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),

                      blurRadius: 18,
                    ),
                  ],
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,

                      children: const [
                        Text(
                          "Live EV Status",

                          style: TextStyle(
                            color: Color(0xFF111827),

                            fontSize: 22,

                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        Icon(Icons.bolt, color: Color(0xFF22C55E)),
                      ],
                    ),

                    const SizedBox(height: 24),

                    buildLiveStatus("Available EVs", "23", Colors.green),

                    const SizedBox(height: 16),

                    buildLiveStatus("Active Riders", "12", Colors.purple),

                    const SizedBox(height: 16),

                    buildLiveStatus("Charging Stations", "8", Colors.orange),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // IMPACT CARD
              Container(
                padding: const EdgeInsets.all(26),

                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.green.shade400, Colors.green.shade600],
                  ),

                  borderRadius: BorderRadius.circular(32),
                ),

                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(18),

                      decoration: BoxDecoration(
                        color: Colors.white24,

                        shape: BoxShape.circle,
                      ),

                      child: const Icon(
                        Icons.eco,

                        color: Colors.white,

                        size: 42,
                      ),
                    ),

                    const SizedBox(width: 20),

                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          Text(
                            "Green Impact 🌱",

                            style: TextStyle(
                              color: Colors.white,

                              fontSize: 24,

                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          SizedBox(height: 8),

                          Text(
                            "You saved enough carbon to power 18 smart homes today.",

                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      // BOTTOM NAV
      bottomNavigationBar: Container(
        margin: const EdgeInsets.fromLTRB(18, 0, 18, 18),

        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius: BorderRadius.circular(30),

          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 20),
          ],
        ),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,

          children: [
            buildNavItem(Icons.home_rounded, 0),

            buildNavItem(Icons.map_rounded, 1),

            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,

                  MaterialPageRoute(builder: (context) => const ScanQrScreen()),
                );
              },

              child: Container(
                padding: const EdgeInsets.all(18),

                decoration: BoxDecoration(
                  shape: BoxShape.circle,

                  gradient: LinearGradient(
                    colors: [Colors.green.shade400, Colors.purple.shade400],
                  ),

                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withOpacity(0.25),

                      blurRadius: 20,
                    ),
                  ],
                ),

                child: const Icon(
                  Icons.qr_code_scanner,

                  color: Colors.white,

                  size: 30,
                ),
              ),
            ),

            buildNavItem(Icons.wallet_rounded, 2),

            buildNavItem(Icons.person_rounded, 3),
          ],
        ),
      ),
    );
  }

  Widget buildHeroStat(String value, String label) {
    return Column(
      children: [
        Text(
          value,

          style: const TextStyle(
            color: Colors.white,

            fontSize: 24,

            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 6),

        Text(
          label,

          style: const TextStyle(color: Colors.white70, fontSize: 14),
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
            BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 14),
          ],
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            // ICON BOX
            Container(
              padding: const EdgeInsets.all(16),

              decoration: BoxDecoration(
                color: Colors.white,

                borderRadius: BorderRadius.circular(22),
              ),

              child: Icon(icon, color: color, size: 34),
            ),

            const Spacer(),

            // TITLE
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

            // SUBTITLE
            Text(
              subtitle,

              maxLines: 2,

              overflow: TextOverflow.ellipsis,

              style: const TextStyle(color: Colors.grey, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildLiveStatus(String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),

        borderRadius: BorderRadius.circular(24),
      ),

      child: Row(
        children: [
          Container(
            height: 14,
            width: 14,

            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Text(
              title,

              style: const TextStyle(color: Color(0xFF111827), fontSize: 16),
            ),
          ),

          Text(
            value,

            style: TextStyle(
              color: color,

              fontSize: 22,

              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildNavItem(IconData icon, int index) {
    bool active = selectedIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },

      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),

        padding: const EdgeInsets.all(10),

        decoration: BoxDecoration(
          color: active ? Colors.green.withOpacity(0.12) : Colors.transparent,

          borderRadius: BorderRadius.circular(16),
        ),

        child: Icon(icon, color: active ? Colors.green : Colors.grey, size: 28),
      ),
    );
  }
}
