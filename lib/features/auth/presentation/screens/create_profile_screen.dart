import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'kyc_upload_screen.dart';

class CreateProfileScreen extends StatefulWidget {
  const CreateProfileScreen({super.key});

  @override
  State<CreateProfileScreen> createState() => _CreateProfileScreenState();
}

class _CreateProfileScreenState extends State<CreateProfileScreen> {
  String selectedRiderType = "Daily Commuter";

  File? profileImage;

  final ImagePicker picker = ImagePicker();

  // CONTROLLERS
  final TextEditingController nameController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController emergencyController = TextEditingController();

  final List<String> riderTypes = [
    "Daily Commuter",

    "Campus Rider",

    "Tourist Rider",

    "Delivery Rider",
  ];

  @override
  void initState() {
    super.initState();

    // DUMMY EXISTING DATA
    nameController.text = "Moksh Patel";

    emailController.text = "moksh@gmail.com";

    emergencyController.text = "9876543210";
  }

  // PROFILE IMAGE PICKER
  Future<void> pickProfileImage() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        profileImage = File(image.path);
      });
    }
  }

  // VALIDATION
  bool validateFields() {
    // EMPTY VALIDATION
    if (nameController.text.trim().isEmpty) {
      showError("Please enter name");

      return false;
    }

    // EMAIL VALIDATION
    if (!emailController.text.contains("@")) {
      showError("Enter valid email");

      return false;
    }

    // PHONE VALIDATION
    if (emergencyController.text.length < 10) {
      showError("Enter valid phone number");

      return false;
    }

    return true;
  }

  // ERROR MESSAGE
  void showError(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),

      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: 450,

            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  // HEADER
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          Text(
                            "Edit Profile",

                            style: TextStyle(
                              fontSize: 32,

                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          SizedBox(height: 6),

                          Text(
                            "Update your EV rider profile",

                            style: TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                        ],
                      ),

                      Container(
                        padding: const EdgeInsets.all(14),

                        decoration: BoxDecoration(
                          color: Colors.white,

                          borderRadius: BorderRadius.circular(18),
                        ),

                        child: const Icon(Icons.edit, color: Colors.green),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // PROGRESS CARD
                  Container(
                    padding: const EdgeInsets.all(20),

                    decoration: BoxDecoration(
                      color: Colors.white,

                      borderRadius: BorderRadius.circular(24),
                    ),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,

                          children: [
                            Text(
                              "Profile Completion",

                              style: TextStyle(
                                fontWeight: FontWeight.bold,

                                fontSize: 16,
                              ),
                            ),

                            Text(
                              "85%",

                              style: TextStyle(
                                color: Colors.green,

                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),

                          child: LinearProgressIndicator(
                            value: 0.85,

                            minHeight: 10,

                            backgroundColor: Colors.grey.shade200,

                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // PROFILE IMAGE
                  Center(
                    child: Stack(
                      children: [
                        Container(
                          height: 120,
                          width: 120,

                          decoration: BoxDecoration(
                            color: Colors.white,

                            shape: BoxShape.circle,

                            border: Border.all(color: Colors.green, width: 3),
                          ),

                          child: profileImage != null
                              ? ClipOval(
                                  child: Image.file(
                                    profileImage!,

                                    fit: BoxFit.cover,

                                    width: 120,

                                    height: 120,
                                  ),
                                )
                              : const Icon(
                                  Icons.person,

                                  size: 60,

                                  color: Colors.grey,
                                ),
                        ),

                        Positioned(
                          bottom: 0,
                          right: 0,

                          child: GestureDetector(
                            onTap: pickProfileImage,

                            child: Container(
                              padding: const EdgeInsets.all(10),

                              decoration: const BoxDecoration(
                                color: Colors.green,

                                shape: BoxShape.circle,
                              ),

                              child: const Icon(
                                Icons.camera_alt,

                                size: 20,

                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  // PERSONAL INFO
                  Container(
                    padding: const EdgeInsets.all(20),

                    decoration: BoxDecoration(
                      color: Colors.white,

                      borderRadius: BorderRadius.circular(24),
                    ),

                    child: Column(
                      children: [
                        buildTextField(
                          hint: "Full Name",

                          icon: Icons.person_outline,

                          controller: nameController,
                        ),

                        const SizedBox(height: 20),

                        buildTextField(
                          hint: "Email Address",

                          icon: Icons.email_outlined,

                          controller: emailController,

                          keyboardType: TextInputType.emailAddress,
                        ),

                        const SizedBox(height: 20),

                        buildTextField(
                          hint: "Emergency Contact",

                          icon: Icons.phone_outlined,

                          controller: emergencyController,

                          keyboardType: TextInputType.phone,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // RIDER TYPE
                  const Text(
                    "Select Rider Type",

                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 20),

                  Wrap(
                    spacing: 12,
                    runSpacing: 12,

                    children: riderTypes.map((type) {
                      bool isSelected = selectedRiderType == type;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedRiderType = type;
                          });
                        },

                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,

                            vertical: 14,
                          ),

                          decoration: BoxDecoration(
                            color: isSelected ? Colors.green : Colors.white,

                            borderRadius: BorderRadius.circular(18),

                            border: Border.all(
                              color: isSelected
                                  ? Colors.green
                                  : Colors.grey.shade300,
                            ),
                          ),

                          child: Text(
                            type,

                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black,

                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 30),

                  // SAVE BUTTON
                  SizedBox(
                    width: double.infinity,

                    height: 60,

                    child: ElevatedButton(
                      onPressed: () {
                        if (validateFields()) {
                          Navigator.push(
                            context,

                            MaterialPageRoute(
                              builder: (context) => const KycUploadScreen(),
                            ),
                          );
                        }
                      },

                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22),
                        ),
                      ),

                      child: const Text(
                        "Save & Continue",

                        style: TextStyle(
                          fontSize: 18,

                          color: Colors.white,

                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField({
    required String hint,
    required IconData icon,
    required TextEditingController controller,

    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,

      keyboardType: keyboardType,

      decoration: InputDecoration(
        hintText: hint,

        prefixIcon: Icon(icon),

        filled: true,

        fillColor: Colors.grey.shade100,

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),

          borderSide: BorderSide.none,
        ),

        contentPadding: const EdgeInsets.symmetric(vertical: 20),
      ),
    );
  }
}
