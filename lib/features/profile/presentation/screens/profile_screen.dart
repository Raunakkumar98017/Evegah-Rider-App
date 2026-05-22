import 'dart:io';

import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';

import '../../data/services/profile_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileService profileService = ProfileService();

  final ImagePicker picker = ImagePicker();

  late TextEditingController nameController;

  late TextEditingController emailController;

  late TextEditingController phoneController;

  String selectedGender = "Male";

  bool isSaving = false;

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(text: profileService.fullName);

    emailController = TextEditingController(text: profileService.email);

    phoneController = TextEditingController(text: profileService.mobile);

    selectedGender = profileService.gender;
  }

  Future<void> pickImage() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        profileService.updateProfileImage(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    int completion = profileService.getProfileCompletion();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),

      appBar: AppBar(
        backgroundColor: Colors.transparent,

        elevation: 0,

        title: const Text(
          "Rider Profile",

          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            // PROFILE COMPLETION
            Container(
              width: double.infinity,

              padding: const EdgeInsets.all(20),

              decoration: BoxDecoration(
                color: Colors.white,

                borderRadius: BorderRadius.circular(24),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [
                      const Text(
                        "Profile Completion",

                        style: TextStyle(
                          fontSize: 18,

                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Text(
                        "$completion%",

                        style: const TextStyle(
                          color: Colors.green,

                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  LinearProgressIndicator(
                    value: completion / 100,

                    backgroundColor: Colors.grey.shade300,

                    color: Colors.green,

                    minHeight: 10,

                    borderRadius: BorderRadius.circular(12),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // PROFILE IMAGE
            Stack(
              children: [
                CircleAvatar(
                  radius: 60,

                  backgroundColor: Colors.green.shade100,

                  backgroundImage: profileService.profileImage.isNotEmpty
                      ? FileImage(File(profileService.profileImage))
                      : null,

                  child: profileService.profileImage.isEmpty
                      ? const Icon(Icons.person, size: 60, color: Colors.green)
                      : null,
                ),

                Positioned(
                  bottom: 0,

                  right: 0,

                  child: GestureDetector(
                    onTap: pickImage,

                    child: Container(
                      padding: const EdgeInsets.all(10),

                      decoration: const BoxDecoration(
                        color: Colors.green,

                        shape: BoxShape.circle,
                      ),

                      child: const Icon(Icons.camera_alt, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // FORM
            _buildTextField(
              controller: nameController,

              hint: "Full Name",

              icon: Icons.person,
            ),

            const SizedBox(height: 18),

            _buildTextField(
              controller: emailController,

              hint: "Email",

              icon: Icons.email,
            ),

            const SizedBox(height: 18),

            _buildTextField(
              controller: phoneController,

              hint: "Mobile Number",

              icon: Icons.phone,
            ),

            const SizedBox(height: 22),

            // GENDER
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),

              decoration: BoxDecoration(
                color: Colors.white,

                borderRadius: BorderRadius.circular(20),
              ),

              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedGender,

                  isExpanded: true,

                  items: ["Male", "Female", "Other"].map((gender) {
                    return DropdownMenuItem(value: gender, child: Text(gender));
                  }).toList(),

                  onChanged: (value) {
                    setState(() {
                      selectedGender = value!;
                    });
                  },
                ),
              ),
            ),

            const SizedBox(height: 35),

            // SAVE BUTTON
            SizedBox(
              width: double.infinity,

              height: 60,

              child: ElevatedButton(
                onPressed: () async {
                  setState(() {
                    isSaving = true;
                  });

                  bool success = await profileService.updateProfile(
                    name: nameController.text,

                    userEmail: emailController.text,

                    phone: phoneController.text,

                    userGender: selectedGender,
                  );

                  setState(() {
                    isSaving = false;
                  });

                  if (success && mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Profile updated successfully 🚀"),
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

                child: isSaving
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "Save Profile",

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

  Widget _buildTextField({
    required TextEditingController controller,

    required String hint,

    required IconData icon,
  }) {
    return TextField(
      controller: controller,

      decoration: InputDecoration(
        hintText: hint,

        prefixIcon: Icon(icon),

        filled: true,

        fillColor: Colors.white,

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),

          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
