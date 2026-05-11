import 'dart:async';
import 'dart:convert';
import 'dart:ui' as ui; 
import 'package:flutter/services.dart'; 
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' hide ClusterManager, Cluster;
import 'package:http/http.dart' as http;
import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart'; // 🚨 ADDED CLUSTER PACKAGE

import '../../../../core/services/session_service.dart';
import '../screens/vehicle_details_screen.dart';
import '../../../../core/constants/app_constants.dart';

class MapDiscoveryScreen extends StatefulWidget {
  const MapDiscoveryScreen({super.key});

  @override
  State<MapDiscoveryScreen> createState() => _MapDiscoveryScreenState();
}

class _MapDiscoveryScreenState extends State<MapDiscoveryScreen> {
  final Completer<GoogleMapController> _mapController = Completer();
  Set<Marker> _markers = {};
  
  BitmapDescriptor? _customZoneMarker;
  Timer? _refreshTimer;
  
  // 🚨 FILTER STATE VARIABLES
  String _selectedVehicleType = "All";
  double _minBatteryLevel = 0; 
  double _maxPrice = 0.50; 
  List<Map<String, dynamic>> _allLiveZones = [];

  // 🚨 NEW CLUSTER VARIABLES
  late ClusterManager<ZonePlace> _clusterManager;
  List<ZonePlace> _clusterItems = [];

  @override
  void initState() {
    super.initState();
    
    // 🚨 1. INITIALIZE CLUSTER MANAGER BEFORE LOADING DATA
    _clusterManager = _initClusterManager();
    
    _loadMapData(); 
    _startAutoRefreshEngine(); 
  }

  @override
  void dispose() {
    _refreshTimer?.cancel(); 
    super.dispose();
  }

  // 🚨 CLUSTER MANAGER SETUP
  ClusterManager<ZonePlace> _initClusterManager() {
    return ClusterManager<ZonePlace>(
      _clusterItems,
      _updateMarkers,
     markerBuilder: (dynamic cluster) => _markerBuilder(cluster as Cluster<ZonePlace>),
    );
  }

  void _updateMarkers(Set<Marker> markers) {
    setState(() {
      _markers = markers;
    });
  }

  // 🚨 THE SMART MARKER BUILDER
  Future<Marker> _markerBuilder(Cluster<ZonePlace> cluster) async {
    return Marker(
      markerId: MarkerId(cluster.getId()),
      position: cluster.location,
      onTap: () async {
        
        // --- THE NEW SMART ZOOM LOGIC ---
        if (cluster.isMultiple) {
          final GoogleMapController controller = await _mapController.future;

          // 1. Find the edges of the hidden pins
          double minLat = cluster.items.first.location.latitude;
          double maxLat = cluster.items.first.location.latitude;
          double minLng = cluster.items.first.location.longitude;
          double maxLng = cluster.items.first.location.longitude;

          for (var item in cluster.items) {
            if (item.location.latitude < minLat) minLat = item.location.latitude;
            if (item.location.latitude > maxLat) maxLat = item.location.latitude;
            if (item.location.longitude < minLng) minLng = item.location.longitude;
            if (item.location.longitude > maxLng) maxLng = item.location.longitude;
          }

          // 2. Zoom to fit the box exactly
          if (minLat == maxLat && minLng == maxLng) {
            // Fallback if they are perfectly on top of each other
            controller.animateCamera(CameraUpdate.newLatLngZoom(
                cluster.location, (await controller.getZoomLevel()) + 4));
          } else {
            // The perfect bounding box
            final LatLngBounds bounds = LatLngBounds(
              southwest: LatLng(minLat, minLng),
              northeast: LatLng(maxLat, maxLng),
            );
            controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 80));
          }
        } 
        // --- END SMART ZOOM LOGIC ---
        
        else {
          // SHOW BOTTOM SHEET for single zone tap
          _showZoneVehiclesSheet(context, cluster.items.first.rawData);
        }
      },
      icon: cluster.isMultiple 
          ? await _getClusterIcon(cluster.count) 
          : _customZoneMarker ?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
    );
  }

  // 🚨 DRAW THE NUMBERED CIRCLE FOR CLUSTERS
  Future<BitmapDescriptor> _getClusterIcon(int clusterSize) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    const double size = 120.0; 
    
    final Paint paint = Paint()
      ..color = const Color(0xFF1E1452) 
      ..style = PaintingStyle.fill;
    canvas.drawCircle(const Offset(size / 2, size / 2), size / 2.2, paint);

    final Paint borderPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(const Offset(size / 2, size / 2), size / 2.2, borderPaint);

    TextPainter painter = TextPainter(textDirection: TextDirection.ltr);
    painter.text = TextSpan(
      text: clusterSize.toString(),
      style: const TextStyle(
        fontSize: size / 3, 
        color: Colors.white, 
        fontWeight: FontWeight.bold
      ),
    );
    
    painter.layout();
    painter.paint(
      canvas, 
      Offset(size / 2 - painter.width / 2, size / 2 - painter.height / 2)
    );

    final img = await pictureRecorder.endRecording().toImage(size.toInt(), size.toInt());
    final data = await img.toByteData(format: ui.ImageByteFormat.png);

    return BitmapDescriptor.fromBytes(data!.buffer.asUint8List());
  }

  Future<void> _silentRefreshData() async {
    try {
      final liveZones = await _fetchLiveZonesFromApi(); 
      if (liveZones.isNotEmpty && mounted) {
        _allLiveZones = liveZones;
        _applyFilters(); 
      }
    } catch (e) {
      print("Background refresh failed silently: $e");
    }
  }

  void _startAutoRefreshEngine() {
    _refreshTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      _silentRefreshData();
    });
  }

  Future<void> _loadMapData() async {
    try {
      _customZoneMarker = await _loadCustomIconFromAsset(
        'assets/evegah-zone-1.png', 
        size: 130 
      );
    } catch (e) {
      debugPrint("Error loading custom icon: $e");
    }

    setState(() => _markers = {});

    final liveZones = await _fetchLiveZonesFromApi();

    if (liveZones.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showNoZonesAlert(context);
      });
    } else {
      _allLiveZones = liveZones; 
      _applyFilters();
    }
  }

  Future<List<Map<String, dynamic>>> _fetchLiveZonesFromApi() async {
    try {
      final SessionService sessionService = SessionService();
      String? savedToken = await sessionService.getToken(); 

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
              'zoneName': item['zoneName'],
              'zone_address': item['zone_address'],
              'bikeCount': item['bikeCount'],
              'vehicles': item['vehicles'] ?? item['avaialableBikeListData'] ?? [],
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

  // 🚨 UPDATED MAGIC SIEVE TO USE CLUSTER MANAGER
  void _applyFilters() {
    List<Map<String, dynamic>> filteredZones = [];
    bool isFilterActive = _minBatteryLevel > 0;

    for (var zone in _allLiveZones) {
      List<dynamic> allVehiclesInZone = zone['vehicles'] ?? [];
      
      List<dynamic> validVehicles = allVehiclesInZone.where((vehicle) {
        if (!isFilterActive) return true; 

        int battery = int.tryParse(vehicle['batteryPercentage']?.toString() ?? '-1') ?? -1;
        return battery >= _minBatteryLevel; 
      }).toList();

      if (isFilterActive ? validVehicles.isNotEmpty : true) {
        Map<String, dynamic> updatedZone = Map<String, dynamic>.from(zone);
        updatedZone['vehicles'] = isFilterActive ? validVehicles : allVehiclesInZone;
        updatedZone['bikeCount'] = isFilterActive ? validVehicles.length : allVehiclesInZone.length; 
        
        filteredZones.add(updatedZone);
      }
    }

    // 🚨 SEND DATA TO CLUSTER MANAGER INSTEAD OF DIRECTLY TO MARKERS
    setState(() {
      _clusterItems = filteredZones.map((zone) => ZonePlace(
        name: zone['zoneName']?.toString() ?? '',
        rawData: zone,
        latLng: zone['center'],
      )).toList();
      
      _clusterManager.setItems(_clusterItems);
    });
  }

  final CameraPosition _initialCameraPosition = const CameraPosition(
    target: LatLng(22.3072, 73.1812), 
    zoom: 12.0,
  );

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
              // 🚨 LINK MANAGER TO THE MAP
              _clusterManager.setMapId(controller.mapId);
            },
            // 🚨 ADD THESE TWO LINES FOR CLUSTERING
            onCameraMove: _clusterManager.onCameraMove,
            onCameraIdle: _clusterManager.updateMap,
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 50, width: 50,
                    decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, spreadRadius: 2)]),
                    child: IconButton(
                      icon: const Icon(Icons.menu, color: Colors.black87),
                      onPressed: () { },
                    ),
                  ),
                  
                  Container(
                    height: 50, width: 50,
                    decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, spreadRadius: 2)]),
                    child: IconButton(
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

  void _showZoneVehiclesSheet(BuildContext context, Map<String, dynamic> zone) {
    String zoneName = zone['zoneName']?.toString() ?? 'eVegah Parking Zone';
    String zoneAddress = zone['zone_address']?.toString() ?? 'Address not available';
    List<dynamic> zoneVehicles = zone['vehicles'] ?? []; 

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
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                height: 5, width: 50,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300, 
                  borderRadius: BorderRadius.circular(10)
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 8, 8), 
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            zoneName,
                            style: const TextStyle(
                              fontSize: 20, 
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.location_on, size: 16, color: Colors.grey),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  zoneAddress,
                                  style: const TextStyle(
                                    fontSize: 14, 
                                    color: Colors.grey,
                                    height: 1.3, 
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.black54), 
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              Divider(thickness: 1, color: Colors.grey[300], height: 24), 
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
              Expanded(
                child: zoneVehicles.isEmpty 
                  ? const Center(child: Text("No vehicles currently available here.", style: TextStyle(color: Colors.grey, fontSize: 16)))
                  : ListView.separated(
                  itemCount: zoneVehicles.length,
                  separatorBuilder: (context, index) => Divider(color: Colors.grey.shade200, indent: 24, endIndent: 24, height: 1),
                  itemBuilder: (context, index) {
                    final vehicle = zoneVehicles[index];
                    final String vehicleId = vehicle['lockNumber'] ?? "Unknown";
                    final int battery = int.tryParse(vehicle['batteryPercentage']?.toString() ?? '-1') ?? -1;
                    final String statusText = battery < 0 ? "Available - NA" : "Available - $battery%";

                    return InkWell(
                      onTap: () {
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

  void _showFilterSheet(BuildContext context) {
    String tempType = _selectedVehicleType;
    double tempBattery = _minBatteryLevel;
    double tempPrice = _maxPrice;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
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
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _selectedVehicleType = tempType;
                          _minBatteryLevel = tempBattery;
                          _maxPrice = tempPrice;
                        });
                        Navigator.pop(context); 
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

// 🚨 Place this at the very bottom of the file, outside of the main class!
class ZonePlace with ClusterItem {
  final String name;
  final Map<String, dynamic> rawData;
  final LatLng latLng;

  ZonePlace({
    required this.name,
    required this.rawData,
    required this.latLng,
  });

  @override
  LatLng get location => latLng;
}