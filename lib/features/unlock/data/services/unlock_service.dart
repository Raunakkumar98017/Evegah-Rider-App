class UnlockService {
  // VALID VEHICLES
  final List<String> validVehicles = ["EV123", "EV456", "EV789"];

  // MOCK VEHICLE LOCATIONS
  final Map<String, Map<String, double>> vehicleLocations = {
    "EV123": {"lat": 23.0225, "lng": 72.5714},

    "EV456": {"lat": 23.0228, "lng": 72.5718},

    "EV789": {"lat": 23.0230, "lng": 72.5720},
  };

  // VALIDATE VEHICLE
  Future<bool> validateVehicle(String vehicleId) async {
    await Future.delayed(const Duration(seconds: 2));

    return validVehicles.contains(vehicleId.toUpperCase());
  }

  // MOCK UNLOCK API
  Future<bool> unlockVehicle(String vehicleId) async {
    await Future.delayed(const Duration(seconds: 3));

    return true;
  }
}
