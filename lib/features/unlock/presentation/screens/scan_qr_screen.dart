import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:http/http.dart' as http; // 🚨 Added HTTP package

import 'unlocking_screen.dart';

class ScanQrScreen extends StatefulWidget {
  const ScanQrScreen({super.key});

  @override
  State<ScanQrScreen> createState() => _ScanQrScreenState();
}

class _ScanQrScreenState extends State<ScanQrScreen> with SingleTickerProviderStateMixin {
  final MobileScannerController controller = MobileScannerController();
  late AnimationController animationController;
  late Animation<double> animation;
  bool flashOn = false;
  bool scanned = false;
  bool isProcessingApi = false; // 🚨 Tracks if the API is loading

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

  // 🚨 THE NEW API INTEGRATION
  Future<void> _verifyAndUnlock(String code, {required bool isManual}) async {
    // 1. MAGIC TEST BYPASS: Skip API and go straight to unlock screen
    if (code.toUpperCase() == "TEST123") {
      Navigator.pop(context); // Close dialog or bottom sheet
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const UnlockingScreen(vehicleId: "TEST123")),
      );
      return;
    }

    setState(() {
      isProcessingApi = true;
    });

    try {
      // 2. CALL THE REAL API
      final response = await http.post(
        Uri.parse('https://admin.evegah.com/api/qrDecrypted?access_token=YOUR_REAL_TOKEN_HERE'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "qrString": isManual ? null : code,
          "userId": 123, // 🚨 Replace with real User ID
          "lockNumber": isManual ? code : null
        }),
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        
        // 3. EXTRACT THE REAL LOCK NUMBER FROM SERVER
        if (decoded['data'] != null && decoded['data'].isNotEmpty) {
          final realLockNumber = decoded['data'][0]['lockNumber'];
          
          if (!mounted) return;
          Navigator.pop(context); // Close dialog/sheet
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => UnlockingScreen(vehicleId: realLockNumber)),
          );
        } else {
          throw Exception("Invalid QR Code");
        }
      } else {
        throw Exception("Server Error");
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid Vehicle QR or ID. Please try again.")),
      );
      setState(() {
        scanned = false; // Allow them to scan again
      });
    } finally {
      if (mounted) {
        setState(() {
          isProcessingApi = false;
        });
      }
    }
  }

  void onDetectBarcode(BarcodeCapture capture) {
    if (scanned || isProcessingApi) return;

    final List<Barcode> barcodes = capture.barcodes;
    for (final barcode in barcodes) {
      final String code = barcode.rawValue ?? "";

      if (code.isNotEmpty) {
        setState(() {
          scanned = true;
        });

        // Show confirmation dialog before hitting API
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: const Text("Vehicle Found 🚀"),
              content: const Text("Would you like to unlock this vehicle?"),
              actions: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      scanned = false;
                    });
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () => _verifyAndUnlock(code, isManual: false),
                  child: isProcessingApi 
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Text("Unlock"),
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
          MobileScanner(controller: controller, onDetect: onDetectBarcode),
          Container(color: Colors.black.withOpacity(0.45)),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(color: Colors.black.withOpacity(0.4), shape: BoxShape.circle),
                          child: const Icon(Icons.arrow_back, color: Colors.white),
                        ),
                      ),
                      const Text("Scan EV QR", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                      GestureDetector(
                        onTap: () async {
                          await controller.toggleTorch();
                          setState(() => flashOn = !flashOn);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(color: Colors.black.withOpacity(0.4), shape: BoxShape.circle),
                          child: Icon(flashOn ? Icons.flash_on : Icons.flash_off, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Center(
                  child: SizedBox(
                    width: 280, height: 280,
                    child: Stack(
                      children: [
                        Container(decoration: BoxDecoration(border: Border.all(color: Colors.green, width: 4), borderRadius: BorderRadius.circular(24))),
                        AnimatedBuilder(
                          animation: animation,
                          builder: (context, child) {
                            return Positioned(
                              top: animation.value, left: 0, right: 0,
                              child: Container(
                                height: 4,
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  boxShadow: [BoxShadow(color: Colors.green.withOpacity(0.7), blurRadius: 12)],
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
                const Text("Point camera toward EV QR sticker", style: TextStyle(color: Colors.white70, fontSize: 16)),
                const SizedBox(height: 40),
                
                // --- MANUAL ENTRY BUTTON ---
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: SizedBox(
                    width: double.infinity, height: 58,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          backgroundColor: Colors.white,
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
                          builder: (context) {
                            TextEditingController vehicleController = TextEditingController();
                            return Padding(
                              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                              child: SingleChildScrollView(
                                child: Padding(
                                  padding: const EdgeInsets.all(24),
                                  child: StatefulBuilder( // StatefulBuilder to handle loading state inside bottom sheet
                                    builder: (BuildContext context, StateSetter setModalState) {
                                      return Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Text("Enter Vehicle ID", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                                          const SizedBox(height: 20),
                                          TextField(
                                            controller: vehicleController,
                                            decoration: InputDecoration(
                                              hintText: "EVM1025029 or TEST123",
                                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(18)),
                                            ),
                                          ),
                                          const SizedBox(height: 24),
                                          SizedBox(
                                            width: double.infinity, height: 56,
                                            child: ElevatedButton(
                                              onPressed: isProcessingApi ? null : () async {
                                                setModalState(() => isProcessingApi = true);
                                                // 🚨 Trigger API with manual true
                                                await _verifyAndUnlock(vehicleController.text, isManual: true);
                                                setModalState(() => isProcessingApi = false);
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.green,
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                                              ),
                                              child: isProcessingApi 
                                                  ? const CircularProgressIndicator(color: Colors.white)
                                                  : const Text("Unlock Vehicle", style: TextStyle(color: Colors.white, fontSize: 18)),
                                            ),
                                          ),
                                        ],
                                      );
                                    }
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18))),
                      icon: const Icon(Icons.keyboard, color: Colors.white),
                      label: const Text("Enter Vehicle ID Manually", style: TextStyle(color: Colors.white, fontSize: 16)),
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