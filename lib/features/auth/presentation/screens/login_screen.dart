import 'package:flutter/material.dart';

import 'otp_screen.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController phoneController = TextEditingController();

  final AuthService authService = AuthService();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: 420,

            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    const SizedBox(height: 40),

                    // LOGO
                    Center(
                      child: Column(
                        children: [
                          Image.asset(
                            AppConstants.logoImg,
                            height: 120,
                            fit: BoxFit.contain,
                          ),

                          const SizedBox(height: 10),

                          RichText(
                            text: const TextSpan(
                              style: TextStyle(
                                fontSize: 18,
                                color: AppColors.textPrimary,
                              ),

                              children: [
                                TextSpan(text: 'Smart Rides. '),

                                TextSpan(
                                  text: 'Zero Emissions.',

                                  style: TextStyle(
                                    color: AppColors.primary,

                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 60),

                    // TITLE
                    const Text(
                      'Welcome Back 👋',

                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,

                        color: AppColors.textPrimary,
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      'Login to continue your green journey',

                      style: TextStyle(
                        fontSize: 15,

                        color: AppColors.textSecondary,
                      ),
                    ),

                    const SizedBox(height: 32),

                    // PHONE FIELD
                    Container(
                      height: 58,

                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.border),

                        borderRadius: BorderRadius.circular(16),
                      ),

                      child: Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),

                            child: Text(
                              '🇮🇳 +91',

                              style: TextStyle(
                                fontSize: 16,

                                fontWeight: FontWeight.w600,

                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),

                          Container(
                            width: 1,
                            height: 30,
                            color: AppColors.border,
                          ),

                          const SizedBox(width: 16),

                          Expanded(
                            child: TextField(
                              controller: phoneController,

                              keyboardType: TextInputType.phone,

                              decoration: const InputDecoration(
                                border: InputBorder.none,

                                hintText: 'Enter mobile number',

                                hintStyle: TextStyle(
                                  color: AppColors.textMuted,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    // SEND OTP BUTTON
                    SizedBox(
                      width: double.infinity,
                      height: 58,

                      child: ElevatedButton(
                        onPressed: isLoading
                            ? null
                            : () async {
                                setState(() {
                                  isLoading = true;
                                });

                                bool exists = await authService
                                    .checkMobileNumber(phoneController.text);

                                if (exists) {
                                  bool otpSent = await authService.sendOtp(
                                    phoneController.text,
                                  );

                                  if (otpSent) {
                                    Navigator.push(
                                      context,

                                      MaterialPageRoute(
                                        builder: (context) =>
                                            OtpScreen(authService: authService),
                                      ),
                                    );
                                  }
                                }

                                setState(() {
                                  isLoading = false;
                                });
                              },

                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),

                        child: isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Row(
                                mainAxisAlignment: MainAxisAlignment.center,

                                children: [
                                  Text(
                                    'Send OTP',

                                    style: TextStyle(
                                      fontSize: 18,

                                      color: Colors.white,

                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  SizedBox(width: 10),

                                  Icon(
                                    Icons.arrow_forward,

                                    color: Colors.white,
                                  ),
                                ],
                              ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // SECURITY LINE
                    Row(
                      children: [
                        const Expanded(
                          child: Divider(color: AppColors.divider),
                        ),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),

                          child: Row(
                            children: const [
                              Icon(
                                Icons.lock_outline,

                                size: 14,

                                color: AppColors.textMuted,
                              ),

                              SizedBox(width: 6),

                              Text(
                                'Your data is 100% secure',

                                style: TextStyle(
                                  fontSize: 12,

                                  color: AppColors.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const Expanded(
                          child: Divider(color: AppColors.divider),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    // FEATURES BOX
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 18,
                        horizontal: 14,
                      ),

                      decoration: BoxDecoration(
                        color: AppColors.surface,

                        borderRadius: BorderRadius.circular(20),
                      ),

                      child: Row(
                        children: [
                          Expanded(
                            child: buildFeature(
                              Icons.verified_user_outlined,

                              'Secure Login',
                            ),
                          ),

                          Expanded(
                            child: buildFeature(
                              Icons.bolt_outlined,

                              'Instant OTP',
                            ),
                          ),

                          Expanded(
                            child: buildFeature(Icons.eco_outlined, 'Go Green'),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),

                    // FOOTER
                    Center(
                      child: RichText(
                        textAlign: TextAlign.center,

                        text: const TextSpan(
                          style: TextStyle(
                            fontSize: 12,

                            color: AppColors.textSecondary,

                            height: 1.5,
                          ),

                          children: [
                            TextSpan(
                              text: 'By continuing, you agree to EVegah’s\n',
                            ),

                            TextSpan(
                              text: 'Terms of Use',

                              style: TextStyle(
                                color: AppColors.primary,

                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            TextSpan(text: ' and '),

                            TextSpan(
                              text: 'Privacy Policy',

                              style: TextStyle(
                                color: AppColors.primary,

                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
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
      ),
    );
  }

  Widget buildFeature(IconData icon, String title) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primary, size: 28),

        const SizedBox(height: 10),

        Text(
          title,
          textAlign: TextAlign.center,

          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,

            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
