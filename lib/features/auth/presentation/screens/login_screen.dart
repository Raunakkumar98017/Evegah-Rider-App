import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_constants.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),

                // 1. Centered Logo & Tagline
                Center(
                  child: Column(
                    children: [
                      Image.asset(
                        AppConstants.logoImg,
                        height: 130,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 5),
                      RichText(
                        text: const TextSpan(
                          style: TextStyle(fontSize: 20, color: AppColors.textPrimary),
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

                // 2. Welcome Text
                const Text(
                  'Welcome Back! 👋',
                  style: TextStyle(
                    fontSize: 26,
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

                // 3. Phone Number Input Field
                Container(
                  height: 56,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.border),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          '🇮🇳  +91 ',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
                        ),
                      ),
                      Container(
                        height: 30,
                        width: 1,
                        color: AppColors.border,
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: TextField(
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Enter mobile number',
                            hintStyle: TextStyle(color: AppColors.textMuted, fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),

                // 4. Continue with OTP Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle moving to OTP verification or API call
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Stack(
                      alignment: Alignment.center,
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Continue with OTP',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Icon(Icons.arrow_forward, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 24),

                // 5. Secure Divider
                Row(
                  children: [
                    const Expanded(child: Divider(color: AppColors.divider)),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.0),
                      child: Row(
                        children: [
                          Icon(Icons.lock_outline, size: 14, color: AppColors.textMuted),
                          SizedBox(width: 6),
                          Text(
                            'Your data is 100% secure',
                            style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                          ),
                        ],
                      ),
                    ),
                    const Expanded(child: Divider(color: AppColors.divider)),
                  ],
                ),
                
                const SizedBox(height: 24),

                // --- 6. Features Box  ---
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: IntrinsicHeight( 
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Feature 1
                        Expanded(
                          child: buildFeatureContent(
                            Icons.verified_user_outlined, 
                            'Secure\nLogin', 
                            'Your data is\nprotected'
                          ),
                        ),
                        const SizedBox(width: 8),

                        // Divider 1
                        Container(height: 40, width: 1, color: AppColors.border),

                        const SizedBox(width: 8),

                        // Feature 2
                        Expanded(
                          child: buildFeatureContent(
                            Icons.bolt_outlined, 
                            'Instant\nOTP', 
                            'Login in seconds'
                          ),
                        ),
                        const SizedBox(width: 8),

                        // Divider 2
                        Container(height: 40, width: 1, color: AppColors.border),

                        const SizedBox(width: 8),

                        // Feature 3
                        Expanded(
                          child: buildFeatureContent(
                            Icons.eco_outlined, 
                            'Go\nGreen', 
                            'For a better\ntomorrow'
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 40),

                // 7. Footer Terms & Privacy
                Center(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: const TextSpan(
                      style: TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.5),
                      children: [
                        TextSpan(text: 'By continuing, you agree to EVegah\'s\n'),
                        TextSpan(
                          text: 'Terms of Use',
                          style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                        ),
                        TextSpan(text: ' and '),
                        TextSpan(
                          text: 'Privacy Policy',
                          style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildFeatureContent(IconData icon, String title, String subtitle) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.primary, size: 20),
        const SizedBox(width: 6),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold, 
                  color: AppColors.textPrimary,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 10,
                  color: AppColors.textSecondary,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
