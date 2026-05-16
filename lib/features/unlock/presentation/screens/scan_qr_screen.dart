import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import 'unlocking_screen.dart';

class ScanQrScreen extends StatefulWidget {
  const ScanQrScreen({super.key});

  @override
  State<ScanQrScreen> createState() => _ScanQrScreenState();
}

class _ScanQrScreenState extends State<ScanQrScreen>
    with SingleTickerProviderStateMixin {
  final MobileScannerController controller = MobileScannerController();

  late AnimationController animationController;

  late Animation<double> animation;

  bool flashOn = false;

  bool scanned = false;

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      vsync: this,

      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    animation = Tween<double>(begin: 0, end: 250).animate(animationController);
  }

  @override
  void dispose() {
    controller.dispose();

    animationController.dispose();

    super.dispose();
  }

  void onDetectBarcode(BarcodeCapture capture) {
    if (scanned) return;

    final List<Barcode> barcodes = capture.barcodes;

    for (final barcode in barcodes) {
      final String code = barcode.rawValue ?? "";

      if (code.isNotEmpty) {
        scanned = true;

        showDialog(
          context: context,

          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),

              title: const Text("Vehicle Found 🚀"),

              content: Text("Vehicle ID: $code"),

              actions: [
                TextButton(
                  onPressed: () {
                    scanned = false;

                    Navigator.pop(context);
                  },

                  child: const Text("Cancel"),
                ),

                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);

                    Navigator.push(
                      context,

                      MaterialPageRoute(
                        builder: (context) => UnlockingScreen(vehicleId: code),
                      ),
                    ).then((_) {
                      scanned = false;
                    });
                  },

                  child: const Text("Unlock"),
                ),
              ],
            );
          },
        );

        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      body: Stack(
        children: [
          // CAMERA
          MobileScanner(controller: controller, onDetect: onDetectBarcode),

          // DARK OVERLAY
          Container(color: Colors.black.withOpacity(0.45)),

          // UI
          SafeArea(
            child: Column(
              children: [
                // TOP BAR
                Padding(
                  padding: const EdgeInsets.all(20),

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },

                        child: Container(
                          padding: const EdgeInsets.all(12),

                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.4),

                            shape: BoxShape.circle,
                          ),

                          child: const Icon(
                            Icons.arrow_back,

                            color: Colors.white,
                          ),
                        ),
                      ),

                      const Text(
                        "Scan EV QR",

                        style: TextStyle(
                          color: Colors.white,

                          fontSize: 22,

                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      GestureDetector(
                        onTap: () async {
                          await controller.toggleTorch();

                          setState(() {
                            flashOn = !flashOn;
                          });
                        },

                        child: Container(
                          padding: const EdgeInsets.all(12),

                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.4),

                            shape: BoxShape.circle,
                          ),

                          child: Icon(
                            flashOn ? Icons.flash_on : Icons.flash_off,

                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // SCANNER AREA
                Center(
                  child: SizedBox(
                    width: 280,
                    height: 280,

                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.green, width: 4),

                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),

                        // ANIMATED LINE
                        AnimatedBuilder(
                          animation: animation,

                          builder: (context, child) {
                            return Positioned(
                              top: animation.value,

                              left: 0,
                              right: 0,

                              child: Container(
                                height: 4,

                                decoration: BoxDecoration(
                                  color: Colors.green,

                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.green.withOpacity(0.7),

                                      blurRadius: 12,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // HINT
                const Text(
                  "Point camera toward EV QR sticker",

                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),

                const SizedBox(height: 40),

                // MANUAL ENTRY
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),

                  child: SizedBox(
                    width: double.infinity,

                    height: 58,

                    child: ElevatedButton.icon(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          backgroundColor: Colors.white,
                          isScrollControlled: true, // 🚨 1. ADD THIS: Allows the sheet to move up
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(28),
                            ),
                          ),
                          builder: (context) {
                            TextEditingController vehicleController = TextEditingController();

                            // 🚨 2. ADD THIS PADDING WRAPPER: Pushes the sheet above the keyboard
                            return Padding(
                              padding: EdgeInsets.only(
                                bottom: MediaQuery.of(context).viewInsets.bottom,
                              ),
                              child: SingleChildScrollView( // 🚨 3. ADD THIS: Makes the content safe to compress
                                child: Padding(
                                  padding: const EdgeInsets.all(24),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text(
                                        "Enter Vehicle ID",
                                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 20),
                                      TextField(
                                        controller: vehicleController,
                                        autofocus: true, // Optional: Automatically opens keyboard
                                        decoration: InputDecoration(
                                          hintText: "EV123",
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(18),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 24),
                                      SizedBox(
                                        width: double.infinity,
                                        height: 56,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => UnlockingScreen(
                                                  vehicleId: vehicleController.text,
                                                ),
                                              ),
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.green,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(18),
                                            ),
                                          ),
                                          child: const Text(
                                            "Unlock Vehicle",
                                            style: TextStyle(color: Colors.white, fontSize: 18),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },

                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),

                      icon: const Icon(Icons.keyboard, color: Colors.white),

                      label: const Text(
                        "Enter Vehicle ID Manually",

                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
