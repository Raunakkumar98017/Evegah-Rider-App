import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
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
  bool isProcessingApi = false;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    
    animation = Tween<double>(begin: 0, end: 200).animate(animationController);
  }

  @override
  void dispose() {
    controller.dispose();
    animationController.dispose();
    super.dispose();
  }

  Future<void> _verifyAndUnlock(String code, {required bool isManual}) async {
    if (code.toUpperCase() == "TEST123") {
      if (isManual) Navigator.pop(context);
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
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('access_token');
      
      if (token == null || token.isEmpty) throw Exception("User not logged in");

      final response = await http.post(
        Uri.parse('https://admin.evegah.com/api/qrDecrypted?access_token=$token'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "qrString": isManual ? null : code,
          "userId": 0, 
          "lockNumber": isManual ? code : null
        }),
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        
        if (decoded['data'] != null && decoded['data'].isNotEmpty) {
          final realLockNumber = decoded['data'][0]['lockNumber'];
          
          if (!mounted) return;
          
          if (isManual) Navigator.pop(context); 
          
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => UnlockingScreen(vehicleId: realLockNumber.toString())),
          );
        } else {
          throw Exception("Vehicle not found");
        }
      } else {
        throw Exception("Server Error");
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid Vehicle QR or ID. Please try again."), backgroundColor: Colors.red),
      );
      setState(() {
        scanned = false; 
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

        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: const Text("Vehicle Found"),
              content: const Text("Would you like to unlock this vehicle?"),
              actions: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      scanned = false;
                    });
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
                ),
                ElevatedButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    await _verifyAndUnlock(code, isManual: false);
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF3E1E90)),
                  child: const Text("Unlock", style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          }
        );
        break;
      }
    }
  }

  void _showManualEntrySheet() {
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
              child: StatefulBuilder(
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
                            await _verifyAndUnlock(vehicleController.text, isManual: true);
                            setModalState(() => isProcessingApi = false);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF3E1E90),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                          ),
                          child: isProcessingApi
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Text("Unlock Vehicle", style: TextStyle(color: Colors.white, fontSize: 18)),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  );
                }
              ),
            ),
          ),
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Image.asset(
          'assets/Evegah_login_page_logo.png',
          height: 45, // Increased size to match the screenshot
          fit: BoxFit.contain,
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.black),
            onPressed: () {},
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Stack(
              alignment: Alignment.center,
              children: [
                const CircleAvatar(
                  radius: 18,
                  backgroundColor: Color(0xFFF3E8FF),
                  child: Icon(Icons.person, color: Color(0xFF3E1E90)),
                ),
                Positioned(
                  bottom: 6,
                  right: 0,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Scan to Unlock",
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Scan the QR code on the scooter to unlock\nand start your ride.",
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade600, height: 1.3),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9F6FF),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFEFE8FE)),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.help_outline, color: Color(0xFF5B30A6), size: 14),
                        SizedBox(width: 4),
                        Text("How it works?", style: TextStyle(color: Color(0xFF5B30A6), fontSize: 11, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Scanner View
              ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: SizedBox(
                  height: 420,
                  width: double.infinity,
                  child: Stack(
                    children: [
                      // Scooter Background for web/emulator or when camera is off
                      Positioned.fill(
                        child: Image.asset(
                          'assets/images/scanner_scooter.png',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(color: Colors.black),
                        ),
                      ),
                      MobileScanner(controller: controller, onDetect: onDetectBarcode),
                      
                      // Dark Overlay
                      Container(color: Colors.black.withOpacity(0.5)),
                      
                      // Cutout Box
                      Center(
                        child: Container(
                          width: 220,
                          height: 220,
                          decoration: BoxDecoration(
                            color: Colors.transparent, // the actual transparent hole can be tricky, we simulate with bracket overlay
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Stack(
                            children: [
                              // The scanner hole effect (simulated by having the rest dark)
                              // We use ColorFiltered for real cutout if needed, but for simplicity we draw brackets.
                              CustomPaint(
                                size: const Size(220, 220),
                                painter: ScannerBracketPainter(),
                              ),
                              // Scanning Line
                              AnimatedBuilder(
                                animation: animation,
                                builder: (context, child) {
                                  return Positioned(
                                    top: animation.value,
                                    left: 10,
                                    right: 10,
                                    child: Container(
                                      height: 3,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFCCFF00),
                                        boxShadow: [
                                          BoxShadow(color: const Color(0xFFCCFF00).withOpacity(0.8), blurRadius: 15, spreadRadius: 3),
                                          BoxShadow(color: const Color(0xFFCCFF00).withOpacity(0.4), blurRadius: 30, spreadRadius: 8),
                                        ],
                                      ),
                                    ),
                                  );
                                }
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      // Texts and Flashlight inside Scanner
                      const Positioned(
                        top: 30,
                        left: 0,
                        right: 0,
                        child: Text(
                          "Align QR code within the frame",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                      ),
                      
                      Positioned(
                        bottom: 20,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  await controller.toggleTorch();
                                  setState(() => flashOn = !flashOn);
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF5B30A6),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(flashOn ? Icons.flashlight_on : Icons.flashlight_off, color: Colors.white, size: 20),
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text("Flashlight", style: TextStyle(color: Colors.white, fontSize: 12)),
                            ],
                          ),
                        ),
                      ),
                      
                      if (isProcessingApi)
                        Container(
                          color: Colors.black54,
                          child: const Center(
                            child: CircularProgressIndicator(color: Color(0xFFCCFF00)),
                          ),
                        )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Safe & Secure Banner
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9F6FF),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.verified_user_outlined, color: Color(0xFF5B30A6), size: 24),
                      // Adding a tiny green checkmark over the shield is complex, so we just use the shield icon with a color.
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Safe & Secure", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black)),
                          const SizedBox(height: 4),
                          Text("Every ride is protected with\nsmart security and IoT tracking.", style: TextStyle(color: Colors.grey.shade600, fontSize: 11, height: 1.3)),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right, color: Color(0xFF5B30A6)),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Other Options
              const Text("Other options", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: _showManualEntrySheet,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.dialpad, color: Color(0xFF5B30A6), size: 20),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("Enter Scooter ID", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.black)),
                                  Text("Manually enter the scooter ID", style: TextStyle(fontSize: 9, color: Colors.grey.shade500)),
                                ],
                              ),
                            ),
                            const Icon(Icons.chevron_right, color: Colors.grey, size: 16),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context); // Return to Dashboard/Map
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.location_on_outlined, color: Color(0xFF5B30A6), size: 20),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("Find Nearby Scooters", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.black)),
                                  Text("View scooters on the map", style: TextStyle(fontSize: 9, color: Colors.grey.shade500)),
                                ],
                              ),
                            ),
                            const Icon(Icons.chevron_right, color: Colors.grey, size: 16),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Promo Banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9F6FF), // Light purple
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/purple_gift_box.png',
                      width: 40,
                      height: 40,
                      errorBuilder: (context, error, stackTrace) => const Icon(Icons.card_giftcard, color: Color(0xFF5B30A6), size: 40)
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("50% off on your first ride", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black)),
                          const SizedBox(height: 4),
                          Text("Apply promo code FIRST50 on payment", style: TextStyle(color: Colors.grey.shade600, fontSize: 10)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFE8FE),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("View offers", style: TextStyle(color: Color(0xFF5B30A6), fontWeight: FontWeight.bold, fontSize: 10)),
                          SizedBox(width: 4),
                          Icon(Icons.arrow_forward_ios, color: Color(0xFF5B30A6), size: 10),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

class ScannerBracketPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFCCFF00) // Bright yellow-green
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const double length = 40.0;
    const double radius = 16.0;

    // Top Left
    canvas.drawPath(
      Path()
        ..moveTo(0, length)
        ..lineTo(0, radius)
        ..arcToPoint(const Offset(radius, 0), radius: const Radius.circular(radius))
        ..lineTo(length, 0),
      paint,
    );
    // Top Right
    canvas.drawPath(
      Path()
        ..moveTo(size.width - length, 0)
        ..lineTo(size.width - radius, 0)
        ..arcToPoint(Offset(size.width, radius), radius: const Radius.circular(radius))
        ..lineTo(size.width, length),
      paint,
    );
    // Bottom Left
    canvas.drawPath(
      Path()
        ..moveTo(0, size.height - length)
        ..lineTo(0, size.height - radius)
        ..arcToPoint(Offset(radius, size.height), radius: const Radius.circular(radius), clockwise: false)
        ..lineTo(length, size.height),
      paint,
    );
    // Bottom Right
    canvas.drawPath(
      Path()
        ..moveTo(size.width - length, size.height)
        ..lineTo(size.width - radius, size.height)
        ..arcToPoint(Offset(size.width, size.height - radius), radius: const Radius.circular(radius), clockwise: false)
        ..lineTo(size.width, size.height - length),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}