import 'dart:async';
import 'success_screen.dart';
import 'package:flutter/material.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController otpController = TextEditingController();

  int seconds = 30;

  Timer? timer;

  String errorMessage = "";

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (seconds > 0) {
        setState(() {
          seconds--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  void verifyOtp() {
    if (otpController.text == "1234") {
      setState(() {
        errorMessage = "";
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SuccessScreen()),
      );
    } else {
      setState(() {
        errorMessage = "Invalid OTP";
      });
    }
  }

  @override
  void dispose() {
    timer?.cancel();

    otpController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(backgroundColor: Colors.white, elevation: 0),

      body: Center(
        child: SizedBox(
          width: 400,

          child: Padding(
            padding: const EdgeInsets.all(24),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                const SizedBox(height: 40),

                const Text(
                  "OTP Verification",
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 10),

                const Text(
                  "Enter OTP sent to your phone",
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),

                const SizedBox(height: 10),

                const Text(
                  "Dummy OTP: 1234",
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 40),

                // OTP FIELD
                TextField(
                  controller: otpController,

                  keyboardType: TextInputType.number,

                  decoration: InputDecoration(
                    hintText: "Enter OTP",

                    filled: true,

                    fillColor: Colors.grey.shade100,

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),

                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 18,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                Text(errorMessage, style: const TextStyle(color: Colors.red)),

                const SizedBox(height: 20),

                // RESEND TIMER
                Center(
                  child: seconds == 0
                      ? TextButton(
                          onPressed: () {
                            setState(() {
                              seconds = 30;
                            });

                            startTimer();
                          },

                          child: const Text("Resend OTP"),
                        )
                      : Text(
                          "Resend OTP in 00:$seconds",
                          style: const TextStyle(color: Colors.grey),
                        ),
                ),

                const SizedBox(height: 40),

                // VERIFY BUTTON
                SizedBox(
                  width: double.infinity,
                  height: 58,

                  child: ElevatedButton(
                    onPressed: verifyOtp,

                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),

                    child: const Text(
                      "Verify OTP",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
