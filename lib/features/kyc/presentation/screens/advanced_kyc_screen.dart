import 'package:flutter/material.dart';

import '../../data/services/kyc_service.dart';

class AdvancedKycScreen extends StatefulWidget {
  const AdvancedKycScreen({super.key});

  @override
  State<AdvancedKycScreen> createState() => _AdvancedKycScreenState();
}

class _AdvancedKycScreenState extends State<AdvancedKycScreen> {
  final KycService kycService = KycService();

  bool isVerifying = false;

  @override
  Widget build(BuildContext context) {
    final documents = kycService.getUploadedDocuments();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),

      appBar: AppBar(
        backgroundColor: Colors.transparent,

        elevation: 0,

        title: const Text(
          "Advanced KYC",

          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            // STATUS CARD
            Container(
              width: double.infinity,

              padding: const EdgeInsets.all(25),

              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF4CAF50), Color(0xFF9C27B0)],
                ),

                borderRadius: BorderRadius.circular(30),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  const Text(
                    "KYC Verification Status",

                    style: TextStyle(color: Colors.white70),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    kycService.getKycStatus(),

                    style: const TextStyle(
                      color: Colors.white,

                      fontSize: 34,

                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              "Uploaded Documents",

              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            // DOCUMENTS
            ...documents.map((document) {
              bool uploaded = document["status"] == "Uploaded";

              return Container(
                margin: const EdgeInsets.only(bottom: 18),

                padding: const EdgeInsets.all(20),

                decoration: BoxDecoration(
                  color: Colors.white,

                  borderRadius: BorderRadius.circular(24),
                ),

                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 28,

                      backgroundColor: uploaded
                          ? Colors.green.shade100
                          : Colors.orange.shade100,

                      child: Icon(
                        uploaded ? Icons.check : Icons.upload_file,

                        color: uploaded ? Colors.green : Colors.orange,
                      ),
                    ),

                    const SizedBox(width: 18),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          Text(
                            document["title"],

                            style: const TextStyle(
                              fontSize: 18,

                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 6),

                          Text(document["status"]),
                        ],
                      ),
                    ),

                    ElevatedButton(
                      onPressed: () async {
                        bool success = await kycService.uploadDocument(
                          documentType: document["title"],
                        );

                        if (success && mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "${document["title"]} uploaded successfully 🚀",
                              ),
                            ),
                          );
                        }
                      },

                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                      ),

                      child: const Text(
                        "Upload",

                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              );
            }),

            const SizedBox(height: 30),

            // VERIFY BUTTON
            SizedBox(
              width: double.infinity,

              height: 60,

              child: ElevatedButton(
                onPressed: isVerifying
                    ? null
                    : () async {
                        setState(() {
                          isVerifying = true;
                        });

                        bool success = await kycService.verifyKyc();

                        setState(() {
                          isVerifying = false;
                        });

                        if (success && mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("KYC Submitted Successfully ✅"),
                            ),
                          );
                        }
                      },

                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22),
                  ),
                ),

                child: isVerifying
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "Submit KYC",

                        style: TextStyle(
                          color: Colors.white,

                          fontSize: 18,

                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
