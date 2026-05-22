import 'package:flutter/material.dart';

import '../../data/services/insights_service.dart';

class InsightsScreen extends StatelessWidget {
  InsightsScreen({super.key});

  final InsightsService insightsService = InsightsService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),

      appBar: AppBar(
        backgroundColor: Colors.transparent,

        elevation: 0,

        title: const Text(
          "Smart Insights",

          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            // HEADER CARD
            Container(
              width: double.infinity,

              padding: const EdgeInsets.all(25),

              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF4CAF50), Color(0xFF9C27B0)],
                ),

                borderRadius: BorderRadius.circular(30),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  const Text(
                    "Your EV Impact 🌱",

                    style: TextStyle(color: Colors.white70),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    "${insightsService.getTotalCO2Saved().toStringAsFixed(1)} KG CO₂ Saved",

                    style: const TextStyle(
                      color: Colors.white,

                      fontSize: 30,

                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            GridView.count(
              crossAxisCount: 2,

              shrinkWrap: true,

              physics: const NeverScrollableScrollPhysics(),

              crossAxisSpacing: 18,

              mainAxisSpacing: 18,

              children: [
                _buildInsightCard(
                  Icons.electric_bike,

                  "Total Rides",

                  "${insightsService.getTotalRides()}",
                ),

                _buildInsightCard(
                  Icons.route,

                  "Distance",

                  "${insightsService.getTotalDistance()} km",
                ),

                _buildInsightCard(
                  Icons.currency_rupee,

                  "Money Spent",

                  "₹${insightsService.getTotalSpent()}",
                ),

                _buildInsightCard(
                  Icons.timer,

                  "Avg Ride",

                  insightsService.getAverageRideTime(),
                ),

                _buildInsightCard(
                  Icons.account_balance_wallet,

                  "Wallet Recharge",

                  "₹${insightsService.getWalletRechargeTotal()}",
                ),

                _buildInsightCard(
                  Icons.battery_charging_full,

                  "Battery Efficiency",

                  "${insightsService.getBatteryEfficiency()}%",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInsightCard(IconData icon, String title, String value) {
    return Container(
      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(25),

        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12),
        ],
      ),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          CircleAvatar(
            radius: 28,

            backgroundColor: Colors.green.shade100,

            child: Icon(icon, color: Colors.green, size: 28),
          ),

          const SizedBox(height: 18),

          Text(
            value,

            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 8),

          Text(
            title,

            textAlign: TextAlign.center,

            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
