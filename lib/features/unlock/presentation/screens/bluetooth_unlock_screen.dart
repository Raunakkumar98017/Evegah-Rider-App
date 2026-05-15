import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import 'unlocking_screen.dart';

class BluetoothUnlockScreen extends StatefulWidget {
  const BluetoothUnlockScreen({super.key});

  @override
  State<BluetoothUnlockScreen> createState() => _BluetoothUnlockScreenState();
}

class _BluetoothUnlockScreenState extends State<BluetoothUnlockScreen> {
  List<ScanResult> devices = [];

  bool scanning = false;

  @override
  void initState() {
    super.initState();

    startScan();
  }

  Future<void> startScan() async {
    setState(() {
      scanning = true;
    });

    devices.clear();

    FlutterBluePlus.startScan(timeout: const Duration(seconds: 5));

    FlutterBluePlus.scanResults.listen((results) {
      setState(() {
        devices = results;
      });
    });

    await Future.delayed(const Duration(seconds: 5));

    FlutterBluePlus.stopScan();

    setState(() {
      scanning = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),

      appBar: AppBar(
        title: const Text("Bluetooth Unlock 📶"),

        backgroundColor: Colors.green,
      ),

      body: Column(
        children: [
          const SizedBox(height: 20),

          // STATUS
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),

            padding: const EdgeInsets.all(20),

            decoration: BoxDecoration(
              color: Colors.white,

              borderRadius: BorderRadius.circular(20),
            ),

            child: Row(
              children: [
                Icon(
                  scanning ? Icons.bluetooth_searching : Icons.bluetooth,

                  color: Colors.green,

                  size: 40,
                ),

                const SizedBox(width: 20),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Text(
                        scanning
                            ? "Searching Nearby EVs..."
                            : "Nearby EVs Found",

                        style: const TextStyle(
                          fontSize: 18,

                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 6),

                      const Text("Bluetooth EV unlock system"),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // DEVICE LIST
          Expanded(
            child: devices.isEmpty
                ? const Center(child: Text("No Nearby EV Found"))
                : ListView.builder(
                    itemCount: devices.length,

                    itemBuilder: (context, index) {
                      final device = devices[index].device;

                      return Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 8,
                        ),

                        decoration: BoxDecoration(
                          color: Colors.white,

                          borderRadius: BorderRadius.circular(20),
                        ),

                        child: ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: Colors.green,

                            child: Icon(
                              Icons.electric_bike,

                              color: Colors.white,
                            ),
                          ),

                          title: Text(
                            device.platformName.isNotEmpty
                                ? device.platformName
                                : "Unknown EV",
                          ),

                          subtitle: Text(device.remoteId.toString()),

                          trailing: ElevatedButton(
                            onPressed: () async {
                              Navigator.push(
                                context,

                                MaterialPageRoute(
                                  builder: (context) => UnlockingScreen(
                                    vehicleId: device.remoteId.toString(),
                                  ),
                                ),
                              );
                            },

                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                            ),

                            child: const Text(
                              "Unlock",

                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),

          // RESCAN BUTTON
          Padding(
            padding: const EdgeInsets.all(20),

            child: SizedBox(
              width: double.infinity,

              height: 56,

              child: ElevatedButton(
                onPressed: startScan,

                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),

                child: const Text(
                  "Scan Again",

                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
