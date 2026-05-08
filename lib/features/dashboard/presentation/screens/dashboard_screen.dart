import 'package:flutter/material.dart';
import 'map_discovery_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "EVegah Dashboard",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Welcome Rider 👋",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "Your EV journey starts now.",
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
            const SizedBox(height: 30),

            // CARD
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.green.shade400, Colors.green.shade700],
                ),
                borderRadius: BorderRadius.circular(28),
              ),
              child: const Row(
                children: [
                  Icon(Icons.electric_bike, color: Colors.white, size: 50),
                  SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Ready To Ride ⚡",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Find nearby EV vehicles and start your smart ride.",
                          style: TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // QUICK ACTIONS
            const Text(
              "Quick Actions",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                // 1. We pass the Navigator.push function into the Find EV card
                buildActionCard(
                  icon: Icons.map, 
                  title: "Find EV", 
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MapDiscoveryScreen(),
                      ),
                    );
                  }
                ),
                const SizedBox(width: 16),
                
                // 2. Scan Ride gets an empty function for now until you build that screen
                buildActionCard(
                  icon: Icons.qr_code_scanner, 
                  title: "Scan Ride", 
                  onTap: () {
                    // Do nothing for now
                  }
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // 3. We updated this method to accept an onTap function and wrapped the Container in a GestureDetector
  Widget buildActionCard({required IconData icon, required String title, required VoidCallback onTap}) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap, // This triggers the navigation
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            children: [
              Icon(icon, size: 40, color: Colors.green),
              const SizedBox(height: 16),
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}