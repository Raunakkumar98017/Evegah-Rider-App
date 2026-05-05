import 'package:flutter/material.dart';

void main() {
  runApp(const EvegahApp());
}

class EvegahApp extends StatelessWidget {
  const EvegahApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Evegah Rider',
      theme: ThemeData(
        primaryColor: const Color(0xFF095D2D), // Evegah Dark Green
        fontFamily: 'Roboto', // Replace with your font
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const LoginScreen(),
    );
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0), // Slightly reduced to give the row more room
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),

                // 1. Centered Logo & Tagline
                Center(
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/Evegah_login_page_logo.png', // Ensure this asset name matches your pubspec.yaml
                        height: 130,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 5),
                      RichText(
                        text: const TextSpan(
                          style: TextStyle(fontSize: 20, color: Colors.black87),
                          children: [
                            TextSpan(text: 'Smart Rides. '),
                            TextSpan(
                              text: 'Zero Emissions.',
                              style: TextStyle(
                                color: Color(0xFF095D2D),
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
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Login to continue your green journey',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black54,
                  ),
                ),
                
                const SizedBox(height: 32),

                // 3. Phone Number Input Field
                Container(
                  height: 56,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          '🇮🇳  +91 ',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      ),
                      Container(
                        height: 30,
                        width: 1,
                        color: Colors.grey.shade300,
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: TextField(
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Enter mobile number',
                            hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
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
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF095D2D),
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
                    Expanded(child: Divider(color: Colors.grey.shade200)),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.0),
                      child: Row(
                        children: [
                          Icon(Icons.lock_outline, size: 14, color: Colors.grey),
                          SizedBox(width: 6),
                          Text(
                            'Your data is 100% secure',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    Expanded(child: Divider(color: Colors.grey.shade200)),
                  ],
                ),
                
                const SizedBox(height: 24),

                // --- 6. Features Box  ---
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10), // Tighter padding
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4F9F5), // Very light green tint
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
                        const SizedBox(width: 8), // Smaller gap

                        // Divider 1
                        Container(height: 40, width: 1, color: Colors.grey.shade300),

                        const SizedBox(width: 8), // Smaller gap

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
                        Container(height: 40, width: 1, color: Colors.grey.shade300),

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
                      style: TextStyle(fontSize: 12, color: Colors.black54, height: 1.5),
                      children: [
                        TextSpan(text: 'By continuing, you agree to EVegah\'s\n'),
                        TextSpan(
                          text: 'Terms of Use',
                          style: TextStyle(color: Color(0xFF095D2D), fontWeight: FontWeight.bold),
                        ),
                        TextSpan(text: ' and '),
                        TextSpan(
                          text: 'Privacy Policy',
                          style: TextStyle(color: Color(0xFF095D2D), fontWeight: FontWeight.bold),
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

  // Adjusted Helper Widget to prevent text breaking
  Widget buildFeatureContent(IconData icon, String title, String subtitle) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: const Color(0xFF095D2D), size: 20), // Reduced icon size
        const SizedBox(width: 6), // Tighter space between icon and text
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12, // Reduced to ensure fit
                  fontWeight: FontWeight.bold, 
                  color: Colors.black87,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 10, // Adjusted font to prevent word splitting
                  color: Colors.black54,
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