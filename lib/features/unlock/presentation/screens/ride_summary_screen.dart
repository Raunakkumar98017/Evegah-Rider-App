import 'package:flutter/material.dart';

import '../../../dashboard/presentation/screens/dashboard_screen.dart';

class RideSummaryScreen extends StatelessWidget {
  final String rideTime;

  final double distance;

  final double fare;

  final int batteryUsed;

  const RideSummaryScreen({
    super.key,

    required this.rideTime,

    required this.distance,

    required this.fare,

    required this.batteryUsed,
  });

  @override
  Widget build(BuildContext context) {
    double co2Saved = distance * 0.7;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,

            children: [
              const SizedBox(height: 20),

              // SUCCESS ICON
              Container(
                height: 120,
                width: 120,

                decoration: BoxDecoration(
                  shape: BoxShape.circle,

                  gradient: const LinearGradient(
                    colors: [Color(0xFF4CAF50), Color(0xFF9C27B0)],
                  ),
                ),

                child: const Icon(Icons.check, color: Colors.white, size: 70),
              ),

              const SizedBox(height: 25),

              const Text(
                "Ride Completed 🚀",

                style: TextStyle(
                  fontSize: 32,

                  fontWeight: FontWeight.bold,

                  color: Color(0xFF1E1452),
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                "Thanks for riding with eVegah",

                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),

              const SizedBox(height: 40),

              // SUMMARY CARD
              Container(
                width: double.infinity,

                padding: const EdgeInsets.all(25),

                decoration: BoxDecoration(
                  color: Colors.white,

                  borderRadius: BorderRadius.circular(30),

                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),

                      blurRadius: 15,
                    ),
                  ],
                ),

                child: Column(
                  children: [
                    _buildSummaryRow(Icons.timer, "Ride Time", rideTime),

                    const Divider(height: 35),

                    _buildSummaryRow(
                      Icons.route,

                      "Distance",

                      "${distance.toStringAsFixed(1)} km",
                    ),

                    const Divider(height: 35),

                    _buildSummaryRow(
                      Icons.currency_rupee,

                      "Fare Paid",

                      "₹${fare.toStringAsFixed(0)}",
                    ),

                    const Divider(height: 35),

                    _buildSummaryRow(
                      Icons.battery_alert,

                      "Battery Used",

                      "$batteryUsed%",
                    ),

                    const Divider(height: 35),

                    _buildSummaryRow(
                      Icons.eco,

                      "CO₂ Saved",

                      "${co2Saved.toStringAsFixed(1)} kg",
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // RATING CARD
              Container(
                width: double.infinity,

                padding: const EdgeInsets.all(22),

                decoration: BoxDecoration(
                  color: Colors.white,

                  borderRadius: BorderRadius.circular(25),
                ),

                child: Column(
                  children: [
                    const Text(
                      "Rate Your Ride",

                      style: TextStyle(
                        fontSize: 20,

                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 18),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,

                      children: List.generate(
                        5,

                        (index) => const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5),

                          child: Icon(
                            Icons.star,

                            color: Colors.amber,

                            size: 36,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // BUTTON
              SizedBox(
                width: double.infinity,

                height: 60,

                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,

                      MaterialPageRoute(
                        builder: (context) => const DashboardScreen(),
                      ),

                      (route) => false,
                    );
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E1452),

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22),
                    ),
                  ),

                  child: const Text(
                    "Back To Dashboard",

                    style: TextStyle(
                      color: Colors.white,

                      fontSize: 18,

                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(IconData icon, String title, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),

          decoration: BoxDecoration(
            color: Colors.green.shade100,

            shape: BoxShape.circle,
          ),

          child: Icon(icon, color: Colors.green),
        ),

        const SizedBox(width: 18),

        Expanded(child: Text(title, style: const TextStyle(fontSize: 16))),

        Text(
          value,

          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
