import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:evegah_rider_app/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'feedback_bottom_sheet.dart';

class RideStartedScreen extends StatefulWidget {
  final String vehicleId;
  
  // Note: In your real app, pass these from the Unlock Screen!
  // final int rideBookingId;
  // final int userId;

  const RideStartedScreen({super.key, required this.vehicleId});

  @override
  State<RideStartedScreen> createState() => _RideStartedScreenState();
}

class _RideStartedScreenState extends State<RideStartedScreen> {
  // --- TIMERS & API ---
  int seconds = 0;
  Timer? timer;
  Timer? apiPollingTimer;
  final String apiUrl = "https://admin.evegah.com/api";
  final String dummyToken = "YOUR_ACCESS_TOKEN";

  // --- LIVE DATA STATS ---
  String batteryPercentage = "--%";
  String speed = "0 km/h";
  
  // --- STATE TOGGLES ---
  bool isEndingRide = false;
  bool isPaused = false;
  bool isProcessingPause = false;

  // --- MAP & TRACKING VARIABLES ---
  GoogleMapController? _mapController;
  StreamSubscription<Position>? _positionStream;
  List<LatLng> _routePoints = []; // Stores the path they have driven
  Marker? _riderMarker; // The icon showing their current spot

  // Default starting position (will instantly update when GPS connects)
  static const CameraPosition _initialCameraPosition = CameraPosition(
    target: LatLng(20.5937, 78.9629), // Center of India
    zoom: 16.0,
  );

  @override
  void initState() {
    super.initState();
    _startTimers();
    _startLocationTracking(); // Start tracking the GPS trail
  }

  void _startTimers() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!isPaused) {
        setState(() => seconds++);
      }
    });

    apiPollingTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _fetchLiveRideDetails();
    });
  }

  // --- MAP & GPS TRACKING ---
  Future<void> _startLocationTracking() async {
    // Check permissions first
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    // 🚨 This stream listens to the phone's GPS continuously
    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 5, // Only update if they moved 5 meters (saves battery)
      ),
    ).listen((Position position) {
      LatLng currentPos = LatLng(position.latitude, position.longitude);

      setState(() {
        // 1. Add new point to the blue line
        _routePoints.add(currentPos);

        // 2. Update the arrow marker
        _riderMarker = Marker(
          markerId: const MarkerId('rider'),
          position: currentPos,
          rotation: position.heading, // Points the arrow the way they are facing!
          anchor: const Offset(0.5, 0.5),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          // Note: Later, replace defaultMarker with a custom EV icon image!
        );
      });

      // 3. Move the camera to follow them smoothly
      _mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: currentPos,
            zoom: 17.5,
            bearing: position.heading, // Tilts the map based on their direction
            tilt: 45.0, // Gives a cool 3D navigation look
          ),
        ),
      );

      // 🚨 WEBSOCKET NOTE: This is where you would send the GPS point to your WebSocket
      // webSocketChannel.sink.add(jsonEncode({"lat": position.latitude, "lng": position.longitude}));
    });
  }

  // --- APIs ---
  Future<void> _fetchLiveRideDetails() async {
    // If it's our magic test ID, just fake the data so it looks cool
    if (widget.vehicleId == "TEST123") {
      if (mounted) {
        setState(() {
          batteryPercentage = "86%";
          speed = isPaused ? "0 km/h" : "18 km/h";
        });
      }
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('$apiUrl/v1/getLastRideBookingDetails?rideBookingId=0&statusEnumId=1&id=123&access_token=$dummyToken')
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (mounted) {
          setState(() {
            batteryPercentage = "${data['batteryPercentage'] ?? 0}%";
            speed = "${data['speed'] ?? 0} km/h";
          });
        }
      }
    } catch (e) {
      print("Polling API Error: $e");
    }
  }

  Future<void> _togglePause() async {
    setState(() => isProcessingPause = true);

    // Simulate API call for pausing/resuming the IoT lock
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() {
        isPaused = !isPaused;
        isProcessingPause = false;
        if (isPaused) speed = "0 km/h";
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(isPaused ? "Ride Paused ⏸️ Bike Locked" : "Ride Resumed ▶️ Bike Unlocked")),
      );
    }
  }

 Future<void> _endRide() async {
    setState(() => isEndingRide = true);

    Position? finalPos;
    try {
      finalPos = await Geolocator.getLastKnownPosition();
    } catch (e) {
      print("Couldn't get final GPS");
    }

    // 🚨 1. UPDATE TEST BYPASS
    if (widget.vehicleId == "TEST123") {
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) {
        // Show the Rating Sheet first!
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(32))),
          builder: (context) => FeedbackBottomSheet(rideId: widget.vehicleId),
        ).then((_) {
          // .then() waits for the sheet to close, THEN goes to Dashboard
          if (mounted) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const DashboardScreen()),
              (route) => false,
            );
          }
        });
      }
      return;
    }

    // 🚨 2. UPDATE REAL API BLOCK
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/v1/updateDetailsRideEnds?access_token=$dummyToken'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "rideBookingId": 456, 
          "id": 123,           
          "rideEndLatitude": finalPos?.latitude ?? 0.0,
          "rideEndLongitude": finalPos?.longitude ?? 0.0,
          "remarks": "",
          "endRideUserId": 123
        })
      );

      if (response.statusCode == 200) {
        if (mounted) {
          // Show Rating Sheet on Real API Success
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.white,
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(32))),
            builder: (context) => FeedbackBottomSheet(rideId: widget.vehicleId),
          ).then((_) {
            if (mounted) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const DashboardScreen()),
                (route) => false, 
              );
            }
          });
        }
      } else {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Failed to end ride.")));
      }
    } catch (e) {
      print("End Ride API Error: $e");
    } finally {
      if (mounted) setState(() => isEndingRide = false);
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    apiPollingTimer?.cancel();
    _positionStream?.cancel(); // 🚨 Stop listening to GPS to save phone battery
    _mapController?.dispose();
    super.dispose();
  }

  // Helper to format seconds into MM:SS
  String _formatTime(int totalSeconds) {
    int minutes = totalSeconds ~/ 60;
    int remainingSeconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // -------------------------------------------------------------
          // LAYER 1: THE FULL SCREEN MAP & BLUE ROUTE LINE
          // -------------------------------------------------------------
          GoogleMap(
            initialCameraPosition: _initialCameraPosition,
            myLocationEnabled: false, // We use a custom marker instead of the default blue dot
            compassEnabled: false,
            zoomControlsEnabled: false, // Hides bulky Google buttons
            mapToolbarEnabled: false,
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
            },
            markers: _riderMarker != null ? {_riderMarker!} : {},
            polylines: {
              Polyline(
                polylineId: const PolylineId('route'),
                points: _routePoints,
                color: Colors.blue, // The beautiful blue trail
                width: 6,
                jointType: JointType.round,
                endCap: Cap.roundCap,
              )
            },
          ),

          // -------------------------------------------------------------
          // LAYER 2: TOP APP BAR (Floating over map)
          // -------------------------------------------------------------
          Positioned(
            top: 0, left: 0, right: 0,
            child: Container(
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top, bottom: 16, left: 16, right: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter, end: Alignment.bottomCenter,
                  colors: [Colors.black.withOpacity(0.7), Colors.transparent],
                ),
              ),
              child: Row(
                children: [
                  Container(
                    decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () => Navigator.pop(context), // Let them minimize the map
                    ),
                  ),
                  /*const SizedBox(width: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(20)),
                    child: const Text("Ride in Progress 🚀", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),*/
                ],
              ),
            ),
          ),

          // -------------------------------------------------------------
          // LAYER 3: THE BOTTOM DASHBOARD
          // -------------------------------------------------------------
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 20, offset: Offset(0, -5))],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // --- GAUGES ROW ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildGauge(Icons.timer_outlined, Colors.blue, _formatTime(seconds), "Time"),
                      _buildGauge(Icons.speed_rounded, Colors.orange, speed, "Speed"),
                      _buildGauge(Icons.battery_charging_full_rounded, Colors.green, batteryPercentage, "Battery"),
                    ],
                  ),
                  const SizedBox(height: 30),
                  
                  // --- BUTTONS ROW ---
                  Row(
                    children: [
                      // PAUSE / RESUME BUTTON
                      Expanded(
                        child: SizedBox(
                          height: 56,
                          child: ElevatedButton(
                            onPressed: isProcessingPause || isEndingRide ? null : _togglePause,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isPaused ? Colors.green : Colors.orange.shade400,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                              elevation: 0,
                            ),
                            child: isProcessingPause
                                ? const CircularProgressIndicator(color: Colors.white)
                                : Text(
                                    isPaused ? "Resume" : "Pause",
                                    style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // END RIDE BUTTON
                      Expanded(
                        child: SizedBox(
                          height: 56,
                          child: ElevatedButton(
                            onPressed: isEndingRide ? null : _endRide,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                              elevation: 0,
                            ),
                            child: isEndingRide
                                ? const CircularProgressIndicator(color: Colors.white)
                                : const Text("End Ride", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Safe area padding for iPhones/Androids with swipe bars
                  SizedBox(height: MediaQuery.of(context).padding.bottom),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- HELPER TO DRAW THE DASHBOARD GAUGES ---
  Widget _buildGauge(IconData icon, Color color, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(height: 8),
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E1452))),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
      ],
    );
  }
}