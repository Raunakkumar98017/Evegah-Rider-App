import 'dart:async';
import 'dart:convert'; // Added for JSON decoding
import 'dart:ui' as ui; 
import 'package:flutter/services.dart'; 
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http; // Added for API calls
import '../../../../core/services/session_service.dart';
import '../screens/vehicle_details_screen.dart'; // Adjust path if needed
import '../../../../core/constants/app_constants.dart'; // Adjust the path if needed!

class MapDiscoveryScreen extends StatefulWidget {
  const MapDiscoveryScreen({super.key});

  @override
  State<MapDiscoveryScreen> createState() => _MapDiscoveryScreenState();
}

class _MapDiscoveryScreenState extends State<MapDiscoveryScreen> {
  final Completer<GoogleMapController> _mapController = Completer();
  Set<Marker> _markers = {};
  
  BitmapDescriptor? _customZoneMarker;
  // 🚨 AUTO-REFRESH VARIABLE
  Timer? _refreshTimer;
  // 🚨 THE SILENT BACKGROUND REFRESH
  Future<void> _silentRefreshData() async {
    try {
      // 1. Fetch the absolute latest data from the API
      // (Make sure to pass your queryParams if your function requires them)
      final liveZones = await _fetchLiveZonesFromApi(); 

      if (liveZones.isNotEmpty && mounted) {
        // 2. Silently update our Master List
        _allLiveZones = liveZones;
        
        // 3. Run the Sieve to re-apply any active filters and redraw the map!
        _applyFilters(); 
      }
    } catch (e) {
      // If the background refresh fails (e.g. bad internet), we just ignore it 
      // so we don't bother the user with error popups while they are using the app.
      print("Background refresh failed silently: $e");
    }
  }
  void _startAutoRefreshEngine() {
    // This timer will tick exactly every 10 seconds
    _refreshTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      _silentRefreshData();
    });
  }



  // 🚨 FILTER STATE VARIABLES
  String _selectedVehicleType = "All";
  double _minBatteryLevel = 0; // 0% to 100%
  double _maxPrice = 0.50; // ₹0.10 to ₹1.00
  // 🚨 ADD THIS: The Master List to remember all zones before filtering
  List<Map<String, dynamic>> _allLiveZones = [];

 @override
  void initState() {
    super.initState();
    _loadMapData(); // Your existing first-load function
    
    // 🚨 START THE ENGINE
    _startAutoRefreshEngine(); 
  }
  @override
  void dispose() {
    // Kill the engine to prevent battery drain and memory leaks
    _refreshTimer?.cancel(); 
    super.dispose();
  }
  Future<void> _loadMapData() async {
    // 1. Load the custom icon from assets
    try {
      _customZoneMarker = await _loadCustomIconFromAsset(
        'assets/evegah-zone-1.png', 
        size: 130 
      );
    } catch (e) {
      debugPrint("Error loading custom icon: $e");
    }

    setState(() => _markers = {});

    // 2. Fetch REAL data from the API instead of mock data
    final liveZones = await _fetchLiveZonesFromApi();

    // 3. Handle the UI based on the response
    if (liveZones.isEmpty) {
      // If no zones are returned, show the alert
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showNoZonesAlert(context);
      });
    } else {
      /// 🚨 SAVE TO MASTER LIST AND RUN THE SIEVE
      _allLiveZones = liveZones; 
      _applyFilters();
    }
  }

  /// REAL API CALL LOGIC
  Future<List<Map<String, dynamic>>> _fetchLiveZonesFromApi() async {
    try {
      // 1. GET THE REAL TOKEN FROM MEMORY
      final SessionService sessionService = SessionService();
      String? savedToken = await sessionService.getToken(); 

      // 2. Safety check: If the token is null, don't even try to call the API
      if (savedToken == null || savedToken.isEmpty) {
        debugPrint("ERROR: No token found. User might not be logged in.");
        return [];
      }

      final queryParams = {
        'zoneId': '0',
        'mapCityId': '0',
        'mapCountryName': 'India',
        'mapStateName': 'Gujarat',
        'mapCityName': 'Vadodara', 
        'dataFor': 'ForMapSearch',
        'access_token': savedToken, 
      };

      final uri = Uri.parse(AppConstants.getLiveZones).replace(queryParameters: queryParams);

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        debugPrint("LIVE API RESPONSE: ${response.body}");

        final decodedData = json.decode(response.body);
        
        List<dynamic> zonesList = decodedData['data'] ?? decodedData;
        List<Map<String, dynamic>> mappedZones = [];
        
        for (var item in zonesList) {
          double lat = double.tryParse(item['latitude']?.toString() ?? '0') ?? 0.0;
          double lng = double.tryParse(item['longitude']?.toString() ?? '0') ?? 0.0;
          
          if (lat != 0.0 && lng != 0.0) {
            mappedZones.add({
              'id': item['zoneId']?.toString() ?? DateTime.now().toString(),
              'center': LatLng(lat, lng),
              'bikeCount': item['bikeCount'] ?? 0, 
              // 🚨 ADD THIS: Capture the real vehicle list from the backend!
              // (Using the exact spelling from your API document)
              'vehicles': item['avaialableBikeListData'] ?? [], 
            });
          }
        }
        return mappedZones;
      } else {
        debugPrint("API Failed: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      debugPrint("Network Error: $e");
      return [];
    }
  }

  Set<Marker> _createZoneMarkers(List<Map<String, dynamic>> zoneData) {
    return zoneData.map((zone) {
      return Marker(
        markerId: MarkerId(zone['id'].toString()),
        position: zone['center'],
        
        icon: _customZoneMarker ?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
        
        // 🚨 ADDED THIS: Trigger the Bottom Sheet when the pin is tapped!
        onTap: () {
          // 🚨 We now pass the specific zone's 'vehicles' list!
          _showZoneVehiclesSheet(context, zone['id'].toString(), zone['vehicles']);
        },
      );
    }).toSet();
  }

  // HELPER METHOD: Loads the image from assets and resizes it for Google Maps
  Future<BitmapDescriptor> _loadCustomIconFromAsset(String path, {int size = 100}) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: size);
    ui.FrameInfo fi = await codec.getNextFrame();
    
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint = Paint()..filterQuality = ui.FilterQuality.high;

    canvas.drawImageRect(
      fi.image,
      Rect.fromLTWH(0, 0, fi.image.width.toDouble(), fi.image.height.toDouble()),
      Rect.fromLTWH(0, 0, size.toDouble(), size.toDouble()),
      paint,
    );

    final ui.Image image = await pictureRecorder.endRecording().toImage(size, size);
    final ByteData? bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    
    return BitmapDescriptor.fromBytes(bytes!.buffer.asUint8List());
  }
  // 🚨 THE MAGIC SIEVE 
  void _applyFilters() {
    List<Map<String, dynamic>> filteredZones = [];

    // 1. Check if the user has actually moved the battery slider above 0%
    bool isFilterActive = _minBatteryLevel > 0;

    for (var zone in _allLiveZones) {
      List<dynamic> allVehiclesInZone = zone['vehicles'] ?? [];
      
      // 2. Filter the internal list of bikes
      List<dynamic> validVehicles = allVehiclesInZone.where((vehicle) {
        
        // 🚨 THE FIX: If the filter is completely cleared, keep EVERY bike automatically!
        if (!isFilterActive) return true; 

        // Otherwise, do the math for the active filter
        int battery = int.tryParse(vehicle['batteryPercentage']?.toString() ?? '-1') ?? -1;
        return battery >= _minBatteryLevel; 
      }).toList();

      // 3. The Smart Rule:
      if (isFilterActive ? validVehicles.isNotEmpty : true) {
        
        Map<String, dynamic> updatedZone = Map<String, dynamic>.from(zone);
        
        // 🚨 ANOTHER FIX: If filter is inactive, put the ORIGINAL list back, not the filtered one
        updatedZone['vehicles'] = isFilterActive ? validVehicles : allVehiclesInZone;
        updatedZone['bikeCount'] = isFilterActive ? validVehicles.length : allVehiclesInZone.length; 
        
        filteredZones.add(updatedZone);
      }
    }

    // 4. Redraw the map
    setState(() {
      _markers = _createZoneMarkers(filteredZones);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA), 
      body: Stack(
        children: [
          // A. THE MAP BASE
          GoogleMap(
            initialCameraPosition: _initialCameraPosition,
            markers: _markers,
            onMapCreated: (GoogleMapController controller) {
              _mapController.complete(controller);
            },
            zoomControlsEnabled: false,
            myLocationButtonEnabled: false,
            compassEnabled: false,
            mapToolbarEnabled: false,
          ),

          
        // B. UI OVERLAYS (Hamburger & Filter)
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // Pushes them to opposite sides
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hamburger Menu (Left)
                  Container(
                    height: 50, width: 50,
                    decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, spreadRadius: 2)]),
                    child: IconButton(
                      icon: const Icon(Icons.menu, color: Colors.black87),
                      onPressed: () { },
                    ),
                  ),
                  
                  // 🚨 NEW: Filter Button (Right)
                  Container(
                    height: 50, width: 50,
                    decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, spreadRadius: 2)]),
                    child: IconButton(
                      // We use 'tune' because it looks like a modern settings/filter icon
                      icon: Icon(Icons.tune, color: _minBatteryLevel > 0 || _selectedVehicleType != "All" ? Colors.purple : Colors.black87),
                      onPressed: () {
                        _showFilterSheet(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          // C. SCAN BUTTON
          Positioned(
            bottom: 24, left: 20, right: 20,
            child: SizedBox(
              height: 60, width: double.infinity,
              child: ElevatedButton(
                onPressed: () { },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E1452), 
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
                  elevation: 10, shadowColor: const Color(0x661E1452),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.qr_code_scanner, color: Colors.white),
                    SizedBox(width: 10),
                    Text("Scan", style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showNoZonesAlert(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false, 
          child: Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Container(
              width: 320, 
              padding: const EdgeInsets.all(28),
              child: Column(
                mainAxisSize: MainAxisSize.min, 
                children: [
                  const Text("Alert", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  const Text(
                    "No eVegah zones found in the specified location.\nExplore other areas for available zones.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15, color: Colors.black87, height: 1.5),
                  ),
                  const SizedBox(height: 28),
                  SizedBox(
                    width: 160, height: 48,
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        side: BorderSide(color: Colors.grey.shade400, width: 1),
                      ),
                      child: const Text("OK", style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold)),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // 🚨 THE NEW BOTTOM SHEET UI
 // 🚨 THE REAL DATA BOTTOM SHEET
  void _showZoneVehiclesSheet(BuildContext context, String zoneId, List<dynamic> zoneVehicles) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, 
      backgroundColor: Colors.transparent, 
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.55, 
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              // 1. Drag Handle
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                height: 5, width: 50,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300, 
                  borderRadius: BorderRadius.circular(10)
                ),
              ),
              
             // 2. Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // 🚨 WE ADDED THE DYNAMIC COUNT RIGHT HERE:
                    Text(
                      "Available Vehicles (${zoneVehicles.length})", 
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.black54), 
                      onPressed: () => Navigator.pop(context)
                    )
                  ],
                ),
              ),
              const Divider(height: 1),
              
              // 3. Table Columns
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Vehicle No.", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey.shade600)),
                    Text("Status", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey.shade600)),
                  ],
                ),
              ),
              
              // 4. Scrollable List of REAL Bikes
              Expanded(
                // If there are no bikes, show a friendly message instead of an empty white screen
                child: zoneVehicles.isEmpty 
                  ? const Center(child: Text("No vehicles currently available here.", style: TextStyle(color: Colors.grey, fontSize: 16)))
                  : ListView.separated(
                  itemCount: zoneVehicles.length,
                  separatorBuilder: (context, index) => Divider(color: Colors.grey.shade200, indent: 24, endIndent: 24, height: 1),
                  itemBuilder: (context, index) {
                    final vehicle = zoneVehicles[index];
                    
                    // Reading the exact keys from the API Document
                    final String vehicleId = vehicle['lockNumber'] ?? "Unknown";
                    final int battery = int.tryParse(vehicle['batteryPercentage']?.toString() ?? '-1') ?? -1;
                    
                    final String statusText = battery < 0 ? "Available - NA" : "Available - $battery%";

                    return InkWell(
                      onTap: () {
                        // Pass ONLY the vehicle ID to the details screen, exactly as we set it up before!
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VehicleDetailsScreen(vehicleId: vehicleId),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(vehicleId, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                            Text(
                              statusText,
                              style: TextStyle(
                                color: battery < 0 ? Colors.grey.shade600 : Colors.green.shade700,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      }
    );
  }

  // Vadodara Coordinates
  final CameraPosition _initialCameraPosition = const CameraPosition(
    target: LatLng(22.3072, 73.1812), 
    zoom: 12.0,
  );
 // 🚨 THE FILTER BOTTOM SHEET
  void _showFilterSheet(BuildContext context) {
    // We create temporary variables so changes aren't saved until they hit "Apply"
    String tempType = _selectedVehicleType;
    double tempBattery = _minBatteryLevel;
    double tempPrice = _maxPrice;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        // StatefulBuilder allows the sliders to update smoothly inside the sheet
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              padding: const EdgeInsets.all(24),
              height: MediaQuery.of(context).size.height * 0.60,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Header Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Filter Options", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1E1452))),
                      TextButton(
                        onPressed: () {
                          setModalState(() {
                            tempType = "All";
                            tempBattery = 0;
                            tempPrice = 0.50;
                          });
                        },
                        child: const Text("Clear All", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),

                  // 2. Vehicle Type Chips
                  const Text("Vehicle Type", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    children: ["All", "Scooter", "E-Bike"].map((type) {
                      final isSelected = tempType == type;
                      return ChoiceChip(
                        label: Text(type),
                        selected: isSelected,
                        selectedColor: const Color(0xFF1E1452),
                        labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black87, fontWeight: FontWeight.bold),
                        backgroundColor: Colors.grey.shade100,
                        onSelected: (bool selected) {
                          setModalState(() => tempType = type);
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 30),

                  // 3. Battery Slider
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Minimum Battery", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      Text("${tempBattery.toInt()}%", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green)),
                    ],
                  ),
                  Slider(
                    value: tempBattery,
                    min: 0,
                    max: 100,
                    divisions: 10,
                    activeColor: Colors.green,
                    inactiveColor: Colors.green.shade100,
                    onChanged: (value) => setModalState(() => tempBattery = value),
                  ),
                  const SizedBox(height: 20),

                  // 4. Price Slider
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Max Fare/Min", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      Text("₹${tempPrice.toStringAsFixed(2)}", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red)),
                    ],
                  ),
                  Slider(
                    value: tempPrice,
                    min: 0.10,
                    max: 1.00,
                    divisions: 18,
                    activeColor: Colors.red,
                    inactiveColor: Colors.red.shade100,
                    onChanged: (value) => setModalState(() => tempPrice = value),
                  ),
                  
                  const Spacer(), // Pushes the apply button to the very bottom

                  // 5. Apply Button
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () {
                        // Save the temporary choices to the real memory
                        setState(() {
                          _selectedVehicleType = tempType;
                          _minBatteryLevel = tempBattery;
                          _maxPrice = tempPrice;
                        });
                        Navigator.pop(context); // Close the sheet
                        
                        // 🚨 RUN THE SIEVE!
                        _applyFilters();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E1452),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: const Text("Apply Filters", style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            );
          }
        );
      }
    );
  }
}