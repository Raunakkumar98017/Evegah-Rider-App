import 'dart:async';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../dashboard/presentation/screens/main_navigation.dart';
import '../../../kyc/data/services/digilocker_service.dart';

class KycUploadScreen extends StatefulWidget {
  const KycUploadScreen({super.key});

  @override
  State<KycUploadScreen> createState() => _KycUploadScreenState();
}

class _KycUploadScreenState extends State<KycUploadScreen> {
  int _pollCount = 0;
  bool _isLoading = false;
  Timer? _pollingTimer;
  final DigilockerService _digilockerService = DigilockerService();

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }

  Future<void> _startDigilockerFlow() async {
    setState(() {
      _isLoading = true;
      _pollCount = 0;
    });

    String? authUrl = await _digilockerService.getAuthorizationUrl();
    if (authUrl != null && authUrl.isNotEmpty) {
      final Uri url = Uri.parse(authUrl);
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
        
        // Start polling for status every 3 seconds
        _pollingTimer = Timer.periodic(const Duration(seconds: 3), (timer) async {
          _pollCount++;
          
          if (_pollCount > 40) { // Timeout after 2 minutes (40 * 3s = 120s)
            timer.cancel();
            setState(() => _isLoading = false);
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Verification timed out. Please try again.")),
              );
            }
            return;
          }

          String status = await _digilockerService.getKycStatus();
          
          if (status == 'verified') {
            timer.cancel();
            setState(() => _isLoading = false);
            if (mounted) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const VerificationScreen()),
              );
            }
          } else if (status == 'failed') {
            timer.cancel();
            setState(() => _isLoading = false);
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("DigiLocker verification failed. Please try again.")),
              );
            }
          }
          // If pending, let the timer continue
        });
      } else {
        setState(() => _isLoading = false);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Could not launch browser.")));
        }
      }
    } else {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Failed to connect to backend. Please try again.")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xff2B0B78), size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Image.asset(AppConstants.logoImg, height: 28),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Section with Scooter image
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        // Adjust scooter position to the right
                        Positioned(
                          right: -30,
                          top: -10,
                          child: Image.asset(
                            'assets/scooter_bg.png', 
                            width: 180,
                            fit: BoxFit.contain,
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Verify your identity",
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w800,
                                color: Color(0xff2B0B78),
                              ),
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.55,
                              child: const Text(
                                "Complete your KYC securely using DigiLocker",
                                style: TextStyle(fontSize: 14, color: Colors.grey, height: 1.3),
                              ),
                            ),
                            const SizedBox(height: 24),
                            // 3 Icons Row
                            Row(
                              children: [
                                _buildFeatureIcon(Icons.verified_user, "100% Secure"),
                                const SizedBox(width: 16),
                                _buildFeatureIcon(Icons.admin_panel_settings, "Govt. Verified"),
                                const SizedBox(width: 16),
                                _buildFeatureIcon(Icons.timer_outlined, "Quick & Easy"),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),

                    // Verify using DigiLocker Card
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4)),
                        ],
                        border: Border.all(color: Colors.grey.shade100),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Verify using DigiLocker",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xff2B0B78)),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Access your official documents securely from DigiLocker to complete your KYC.",
                            style: TextStyle(color: Colors.grey.shade600, fontSize: 14, height: 1.4),
                          ),
                          const SizedBox(height: 20),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade200),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.grey.shade200),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.asset(
                                      'assets/digilocker_logo.png',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "DigiLocker",
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xff2B0B78)),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        "Govt. of India",
                                        style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(Icons.arrow_forward_ios, color: Colors.grey.shade400, size: 16),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // How it works
                    const Text(
                      "How it works",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xff2B0B78)),
                    ),
                    const SizedBox(height: 20),
                    _buildStep("1", "Login to DigiLocker", "You will be redirected to DigiLocker to login securely.", Icons.person, false),
                    _buildStep("2", "Select documents", "Choose your Aadhaar card or other valid documents to share.", Icons.description, false),
                    _buildStep("3", "Auto verification", "Your documents will be verified instantly and securely.", Icons.verified_user, true),

                    const SizedBox(height: 32),

                    // Bottom Green Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.green.shade100),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.gpp_good, color: Colors.green.shade600, size: 32),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Your data is 100% secure and encrypted.",
                                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Colors.grey.shade800),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  "We never store your documents.",
                                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            
            // Bottom Button
            Container(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, -4)),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _startDigilockerFlow,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff2B0B78),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: _isLoading 
                      ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Text(
                          "Continue with DigiLocker",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureIcon(IconData icon, String text) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            color: Color(0xffF2F0F9),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: const Color(0xff2B0B78), size: 20),
        ),
        const SizedBox(height: 8),
        Text(
          text,
          style: TextStyle(fontSize: 11, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildStep(String number, String title, String subtitle, IconData icon, bool isLast) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: Color(0xffF2F0F9),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: const Color(0xff2B0B78), size: 20),
            ),
            if (!isLast)
              Container(
                height: 40,
                width: 1,
                margin: const EdgeInsets.symmetric(vertical: 4),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(
                    5,
                    (index) => Container(
                      height: 4,
                      width: 1.5,
                      color: Colors.grey.shade400,
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10), 
              Text(
                "$number. $title",
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xff2B0B78)),
              ),
              const SizedBox(height: 6),
              Text(
                subtitle,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 13, height: 1.4),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ],
    );
  }
}

// VERIFICATION SCREEN
class VerificationScreen extends StatelessWidget {
  const VerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const MainNavigation()),
        (route) => false, // 🚨 This tells Flutter to destroy every previous screen!
      );
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 120,
              width: 120,
              decoration: BoxDecoration(
                color: Colors.orange.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.verified_user,
                size: 70,
                color: Colors.orange.shade700,
              ),
            ),
            const SizedBox(height: 40),
            const Text(
              "Verification In Progress ⏳",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 14),
            const Text(
              "Your documents are being reviewed.\nRedirecting to dashboard...",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 40),
            const CircularProgressIndicator(color: Colors.green),
          ],
        ),
      ),
    );
  }
}
