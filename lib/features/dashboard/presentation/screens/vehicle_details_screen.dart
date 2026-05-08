import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../../core/services/session_service.dart';
import '../../../../core/constants/app_constants.dart';

class VehicleDetailsScreen extends StatefulWidget {
  final String vehicleId; // This is the lockNumber passed from the Map

  const VehicleDetailsScreen({super.key, required this.vehicleId});

  @override
  State<VehicleDetailsScreen> createState() => _VehicleDetailsScreenState();
}

class _VehicleDetailsScreenState extends State<VehicleDetailsScreen> {
  bool _isLoading = true;
  String? _errorMessage;
  Map<String, dynamic>? _vehicleData;

  @override
  void initState() {
    super.initState();
    _fetchLiveVehicleDetails();
  }

  // 🚨 THE API CHAINING MAGIC
  Future<void> _fetchLiveVehicleDetails() async {
    try {
      final SessionService sessionService = SessionService();
      String? savedToken = await sessionService.getToken();

      if (savedToken == null || savedToken.isEmpty) {
        setState(() {
          _errorMessage = "Authentication error. Please log in again.";
          _isLoading = false;
        });
        return;
      }

      // ==========================================
      // CHAIN LINK 1: Get the Secret JSON Object
      // ==========================================
      final qrDecryptedUri = Uri.parse("${AppConstants.decryptQr}?access_token=$savedToken");
      
      final qrResponse = await http.post(
        qrDecryptedUri,
        headers: {"Content-Type": "application/json"},
        // Using manual search logic: qrString is null, lockNumber has the ID
        body: jsonEncode({
          "qrString": null,
          "userId": 0, // Assuming 0 is safe for a generic search if we don't have the userId handy
          "lockNumber": widget.vehicleId 
        }),
      );

      if (qrResponse.statusCode != 200) {
        throw Exception("Failed to find vehicle on server.");
      }

      final qrDecoded = json.decode(qrResponse.body);
      if (qrDecoded['data'] == null || qrDecoded['data'].isEmpty) {
         throw Exception("Vehicle not found in database.");
      }

      // Grab the specific secret object and turn it into a string!
      final secretJsonObject = qrDecoded['data'][0];
      final String jsonStringifiedDetails = jsonEncode(secretJsonObject);


      // ==========================================
      // CHAIN LINK 2: Get the Full Vehicle Model
      // ==========================================
      final getModelParams = {
        'VehicleId': jsonStringifiedDetails,
        'statusEnumId': '1',
        'access_token': savedToken,
      };

      final getModelUri = Uri.parse(AppConstants.getVehicleModel).replace(queryParameters: getModelParams);
      final modelResponse = await http.get(getModelUri);

      if (modelResponse.statusCode != 200) {
        throw Exception("Failed to load vehicle details.");
      }

      final modelDecoded = json.decode(modelResponse.body);
      if (modelDecoded['data'] != null && modelDecoded['data'].isNotEmpty) {
        setState(() {
          _vehicleData = modelDecoded['data'][0]; // Save the real data!
          _isLoading = false;
        });
      } else {
         throw Exception("No model data returned.");
      }

    } catch (e) {
      debugPrint("API Chain Error: $e");
      setState(() {
        _errorMessage = "Could not load live vehicle data.";
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // 1. Show Spinner while chaining APIs
    if (_isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xFFF8F9FE),
        appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
        body: const Center(child: CircularProgressIndicator(color: Color(0xFF1E1452))),
      );
    }

    // 2. Show Error if the chain breaks
    if (_errorMessage != null || _vehicleData == null) {
      return Scaffold(
        backgroundColor: const Color(0xFFF8F9FE),
        appBar: AppBar(
          backgroundColor: Colors.transparent, elevation: 0,
          leading: IconButton(icon: const Icon(Icons.arrow_back_ios, color: Colors.black87), onPressed: () => Navigator.pop(context)),
        ),
        body: Center(child: Text(_errorMessage ?? "Something went wrong.", style: const TextStyle(color: Colors.red, fontSize: 16))),
      );
    }

   // 3. EXTRACT THE LIVE DATA FROM THE RESPONSE
    final String model = _vehicleData!['modelName']?.toString() ?? "Unknown";
    
    // 🚨 BULLETPROOF PARSING ADDED HERE
    final int range = int.tryParse(_vehicleData!['maxRangeOn100PercentageBatteryKM']?.toString() ?? '0') ?? 0;
    
    // Safety checks because nested arrays can sometimes be null
    int battery = 0;
    if (_vehicleData!['lockDetails'] != null && _vehicleData!['lockDetails'].isNotEmpty) {
       // 🚨 BULLETPROOF PARSING ADDED HERE
       battery = int.tryParse(_vehicleData!['lockDetails'][0]['battery']?.toString() ?? '0') ?? 0;
    }

    double fare = 0.0;
    int minHire = 0;
    if (_vehicleData!['farePlanData'] != null && _vehicleData!['farePlanData'].isNotEmpty) {
       fare = double.tryParse(_vehicleData!['farePlanData'][0]['todaysRate']?.toString() ?? '0') ?? 0.0;
       // 🚨 BULLETPROOF PARSING ADDED HERE
       minHire = int.tryParse(_vehicleData!['farePlanData'][0]['minimumHireMinuts']?.toString() ?? '0') ?? 0;
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE), 
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
          onPressed: () => Navigator.pop(context), 
        ),
        title: const Text("Vehicle Details", style: TextStyle(color: Color(0xFF1E1452), fontWeight: FontWeight.bold)),
        centerTitle: false,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 20, top: 12, bottom: 12),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Container(height: 8, width: 8, decoration: BoxDecoration(color: Colors.green.shade400, shape: BoxShape.circle)),
                const SizedBox(width: 6),
                Text("Live", style: TextStyle(color: Colors.green.shade700, fontWeight: FontWeight.bold, fontSize: 12)),
              ],
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // 1. THE VEHICLE IMAGE SECTION
                  Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 5))],
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(color: Colors.purple.shade50, shape: BoxShape.circle),
                        ),
                        // Replace with Image.asset if you have the .webp ready!
                        const Icon(Icons.electric_scooter, size: 100, color: Color(0xFF1E1452)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 2. Vehicle Identity Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 2))],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(color: Colors.purple.shade50, borderRadius: BorderRadius.circular(12)),
                          child: Icon(Icons.fingerprint, color: Colors.purple.shade300, size: 28),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("VEHICLE IDENTITY", style: TextStyle(color: Colors.grey.shade500, fontSize: 12, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text(widget.vehicleId, style: const TextStyle(color: Color(0xFF1E1452), fontSize: 22, fontWeight: FontWeight.bold)),
                          ],
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 3. The 6-Item Grid
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 2.2, 
                    children: [
                      _buildInfoCard(Icons.pedal_bike, Colors.blue, "MODEL", model),
                      _buildInfoCard(Icons.battery_charging_full, Colors.green, "ENERGY", "$battery%"),
                      _buildInfoCard(Icons.map_outlined, Colors.orange, "MAX RANGE", "$range km"),
                      _buildInfoCard(Icons.bolt, Colors.red, "FARE/MIN", "₹$fare"),
                      _buildInfoCard(Icons.hourglass_bottom, Colors.purple, "MIN HIRE", "$minHire Min"),
                      _buildInfoCard(Icons.account_balance_wallet, Colors.pink, "WALLET", "₹0.00"), // We will link the wallet API later!
                    ],
                  ),
                ],
              ),
            ),
          ),

          // 4. STICKY BOTTOM ACTION BAR
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -2))],
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: OutlinedButton(
                    onPressed: () { },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      side: BorderSide(color: Colors.blue.shade600, width: 2), 
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.directions_walk, color: Colors.blue.shade700, size: 20),
                        const SizedBox(width: 6),
                        Text("Navigate", style: TextStyle(color: Colors.blue.shade700, fontSize: 16, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 1, 
                  child: ElevatedButton(
                    onPressed: () { },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      backgroundColor: const Color(0xFF1E1452),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Start Ride", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                        SizedBox(width: 8),
                        Icon(Icons.qr_code_scanner, color: Colors.white, size: 20), 
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildInfoCard(IconData icon, MaterialColor color, String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(color: color.shade50, borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, color: color.shade400, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(title, style: TextStyle(color: Colors.grey.shade500, fontSize: 10, fontWeight: FontWeight.bold)),
                const SizedBox(height: 2),
                Text(value, style: const TextStyle(color: Colors.black87, fontSize: 14, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
              ],
            ),
          )
        ],
      ),
    );
  }
}