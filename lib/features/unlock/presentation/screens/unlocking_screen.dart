import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../../data/services/unlock_service.dart';
import '../../data/services/location_service.dart';

import 'ride_started_screen.dart';

class UnlockingScreen extends StatefulWidget {
  final String vehicleId;

  const UnlockingScreen({
    super.key,
    required this.vehicleId,
  });

  @override
  State<UnlockingScreen> createState() =>
      _UnlockingScreenState();
}

class _UnlockingScreenState
    extends State<UnlockingScreen> {

  final UnlockService unlockService =
      UnlockService();

  final LocationService locationService =
      LocationService();

  @override
  void initState() {

    super.initState();

    startUnlockFlow();
  }

  Future<void> startUnlockFlow() async {

    // 🚨 DUMMY VEHICLE BYPASS
    if (widget.vehicleId ==
        "TEST123") {

      await Future.delayed(
        const Duration(
          seconds: 2,
        ),
      );

      if (!mounted) return;

      Navigator.pushReplacement(
        context,

        MaterialPageRoute(
          builder: (context) =>
              RideStartedScreen(
            vehicleId:
                widget.vehicleId,
          ),
        ),
      );

      return;
    }

    // VALIDATE VEHICLE
    bool valid =
        await unlockService
            .validateVehicle(
      widget.vehicleId,
    );

    if (!valid) {

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(

        const SnackBar(
          content: Text(
            "Vehicle Not Found ❌",
          ),
        ),
      );

      Navigator.pop(context);

      return;
    }

    // GET USER LOCATION
    Position? userLocation =
        await locationService
            .getCurrentLocation();

    if (userLocation == null) {

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(

        const SnackBar(
          content: Text(
            "Location Permission Required 📍",
          ),
        ),
      );

      Navigator.pop(context);

      return;
    }

    // GET VEHICLE LOCATION
    final vehicleData =
        unlockService
            .vehicleLocations[
                widget.vehicleId];

    if (vehicleData == null) {

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(

        const SnackBar(
          content: Text(
            "Vehicle Location Not Found ❌",
          ),
        ),
      );

      Navigator.pop(context);

      return;
    }

    // CALCULATE DISTANCE
    double distance =
        locationService
            .calculateDistance(

      userLocation.latitude,

      userLocation.longitude,

      (vehicleData["lat"]
              as num)
          .toDouble(),

      (vehicleData["lng"]
              as num)
          .toDouble(),
    );

    // CHECK DISTANCE
    if (distance > 20) {

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(

        SnackBar(
          content: Text(
            "Move closer to vehicle 🚗\nDistance: ${distance.toStringAsFixed(1)} meters",
          ),
        ),
      );

      Navigator.pop(context);

      return;
    }

    // UNLOCK VEHICLE
    bool unlocked =
        await unlockService
            .unlockVehicle(
      widget.vehicleId,
    );

    if (unlocked) {

      if (!mounted) return;

      Navigator.pushReplacement(
        context,

        MaterialPageRoute(
          builder: (context) =>
              RideStartedScreen(
            vehicleId:
                widget.vehicleId,
          ),
        ),
      );
    }
  }

  @override
  Widget build(
    BuildContext context,
  ) {

    return Scaffold(
      backgroundColor:
          Colors.black,

      body: Center(
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment
                  .center,

          children: [

            // ICON
            Container(
              height: 140,
              width: 140,

              decoration:
                  BoxDecoration(
                shape:
                    BoxShape.circle,

                color: Colors
                    .green.shade100,
              ),

              child: const Icon(
                Icons.lock_open,

                size: 70,

                color: Colors.green,
              ),
            ),

            const SizedBox(
              height: 40,
            ),

            // TITLE
            const Text(
              "Unlocking EV 🔓",

              style: TextStyle(
                color:
                    Colors.white,

                fontSize: 30,

                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(
              height: 12,
            ),

            // VEHICLE ID
            Text(
              "Vehicle ID: ${widget.vehicleId}",

              style:
                  const TextStyle(
                color:
                    Colors.white70,

                fontSize: 16,
              ),
            ),

            const SizedBox(
              height: 40,
            ),

            // LOADER
            const CircularProgressIndicator(
              color: Colors.green,
            ),

            const SizedBox(
              height: 30,
            ),

            // MESSAGE
            const Text(
              "Checking GPS & connecting to smart vehicle system...",

              textAlign:
                  TextAlign.center,

              style: TextStyle(
                color:
                    Colors.white54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}