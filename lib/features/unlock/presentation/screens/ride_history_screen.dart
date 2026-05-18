import 'package:flutter/material.dart';
import 'ride_detail_screen.dart';

class RideHistoryScreen extends StatefulWidget {
  const RideHistoryScreen({super.key});

  @override
  State<RideHistoryScreen> createState() => _RideHistoryScreenState();
}

class _RideHistoryScreenState extends State<RideHistoryScreen> {
  bool isLoading = true;
  List<Map<String, dynamic>> pastRides = [];

  @override
  void initState() {
    super.initState();
    _fetchRideHistory();
  }

  // --- 🚨 MOCK API CALL ---
  // Replace this with your real HTTP GET request later
  Future<void> _fetchRideHistory() async {
    await Future.delayed(const Duration(seconds: 2)); // Simulate network delay

    if (!mounted) return;

    setState(() {
      isLoading = false;
      // Dummy JSON array mimicking what your backend will return
      pastRides = [
        {
          "rideId": "RIDE-9021",
          "date": "May 18, 2026",
          "vehicleId": "EVM1025029",
          "distance": "2.4 km",
          "time": "14 mins",
          "cost": "₹ 45"
        },
        {
          "rideId": "RIDE-9018",
          "date": "May 16, 2026",
          "vehicleId": "EVM1025088",
          "distance": "5.1 km",
          "time": "28 mins",
          "cost": "₹ 110"
        },
        {
          "rideId": "RIDE-8944",
          "date": "May 10, 2026",
          "vehicleId": "EVM1025029",
          "distance": "1.2 km",
          "time": "8 mins",
          "cost": "₹ 25"
        }
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Text(
          "Ride History",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.green),
            )
          : pastRides.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: pastRides.length,
                  itemBuilder: (context, index) {
                    final ride = pastRides[index];
                    return _buildRideCard(ride);
                  },
                ),
    );
  }

  // --- EMPTY STATE UI ---
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history_rounded, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          const Text(
            "No past rides yet",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          const Text(
            "Your completed trips will appear here.",
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  // --- RIDE CARD UI ---
  Widget _buildRideCard(Map<String, dynamic> ride) {
    return GestureDetector(
      onTap: () {
     Navigator.push(
       context, 
       MaterialPageRoute(
         builder: (context) => RideDetailScreen(rideData: ride),
       ),
     );
   },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Date & ID
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  ride['date'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFF111827),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    ride['rideId'],
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Middle Row: Vehicle Info
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.electric_bike, color: Colors.black87),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Vehicle Scanned", style: TextStyle(color: Colors.grey, fontSize: 12)),
                    Text(
                      ride['vehicleId'],
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  ride['cost'],
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(color: Color(0xFFF1F5F9), thickness: 1.5),
            const SizedBox(height: 12),
            
            // Bottom Row: Metrics
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildMetric(Icons.route_outlined, ride['distance']),
                _buildMetric(Icons.timer_outlined, ride['time']),
                const Row(
                  children: [
                    Text("View Details", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                    Icon(Icons.chevron_right, color: Colors.blue, size: 20),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetric(IconData icon, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey.shade600),
        const SizedBox(width: 6),
        Text(
          value,
          style: TextStyle(color: Colors.grey.shade700, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}