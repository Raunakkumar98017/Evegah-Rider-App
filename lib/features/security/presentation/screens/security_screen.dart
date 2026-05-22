import 'package:flutter/material.dart';

import '../../data/services/security_service.dart';

class SecurityScreen extends StatefulWidget {
  const SecurityScreen({super.key});

  @override
  State<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  final SecurityService securityService = SecurityService();

  final TextEditingController oldPasswordController = TextEditingController();

  final TextEditingController newPasswordController = TextEditingController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final devices = securityService.getLoginDevices();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),

      appBar: AppBar(
        backgroundColor: Colors.transparent,

        elevation: 0,

        title: const Text(
          "Security Settings",

          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            // PASSWORD CARD
            Container(
              padding: const EdgeInsets.all(20),

              decoration: BoxDecoration(
                color: Colors.white,

                borderRadius: BorderRadius.circular(24),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  const Text(
                    "Change Password",

                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 20),

                  TextField(
                    controller: oldPasswordController,

                    obscureText: true,

                    decoration: InputDecoration(
                      hintText: "Old Password",

                      filled: true,

                      fillColor: const Color(0xFFF5F7FA),

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),

                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  TextField(
                    controller: newPasswordController,

                    obscureText: true,

                    decoration: InputDecoration(
                      hintText: "New Password",

                      filled: true,

                      fillColor: const Color(0xFFF5F7FA),

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),

                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,

                    height: 55,

                    child: ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          isLoading = true;
                        });

                        bool success = await securityService.changePassword(
                          oldPassword: oldPasswordController.text,

                          newPassword: newPasswordController.text,
                        );

                        setState(() {
                          isLoading = false;
                        });

                        if (success) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Password changed successfully 🔒"),
                            ),
                          );
                        }
                      },

                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),

                      child: isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              "Update Password",

                              style: TextStyle(
                                color: Colors.white,

                                fontSize: 16,

                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // LOGIN DEVICES
            const Text(
              "Login Devices",

              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 15),

            ...devices.map((device) {
              return Container(
                margin: const EdgeInsets.only(bottom: 15),

                padding: const EdgeInsets.all(18),

                decoration: BoxDecoration(
                  color: Colors.white,

                  borderRadius: BorderRadius.circular(22),
                ),

                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.green.shade100,

                      child: const Icon(Icons.devices, color: Colors.green),
                    ),

                    const SizedBox(width: 15),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          Text(
                            device["device"],

                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),

                          const SizedBox(height: 5),

                          Text(device["location"]),
                        ],
                      ),
                    ),

                    if (device["active"])
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,

                          vertical: 6,
                        ),

                        decoration: BoxDecoration(
                          color: Colors.green.shade100,

                          borderRadius: BorderRadius.circular(20),
                        ),

                        child: const Text(
                          "Active",

                          style: TextStyle(color: Colors.green),
                        ),
                      ),
                  ],
                ),
              );
            }),

            const SizedBox(height: 30),

            // LOGOUT BUTTON
            SizedBox(
              width: double.infinity,

              height: 55,

              child: ElevatedButton(
                onPressed: () async {
                  await securityService.logout();

                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Logged out successfully")),
                    );
                  }
                },

                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),

                child: const Text(
                  "Logout",

                  style: TextStyle(
                    color: Colors.white,

                    fontSize: 16,

                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 15),

            // DELETE ACCOUNT
            SizedBox(
              width: double.infinity,

              height: 55,

              child: ElevatedButton(
                onPressed: () async {
                  bool success = await securityService.deleteAccount();

                  if (success && mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Account deleted successfully"),
                      ),
                    );
                  }
                },

                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),

                child: const Text(
                  "Delete Account",

                  style: TextStyle(
                    color: Colors.white,

                    fontSize: 16,

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
