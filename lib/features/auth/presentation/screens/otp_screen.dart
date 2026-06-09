import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'success_screen.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/services/session_service.dart';

class OtpScreen extends StatefulWidget {
  final AuthService authService;
  final String phoneNumber;

  const OtpScreen({
    super.key, 
    required this.authService,
    this.phoneNumber = "",
  });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController otpController = TextEditingController();
  final SessionService sessionService = SessionService();
  
  int seconds = 30;
  Timer? timer;
  String errorMessage = "";
  bool isLoading = false;

  final List<FocusNode> _focusNodes = List.generate(4, (index) => FocusNode());
  final List<TextEditingController> _controllers = List.generate(4, (index) => TextEditingController());

  @override
  void initState() {
    super.initState();
    startTimer();
    for(int i = 0; i < 4; i++) {
      _controllers[i].addListener(() {
        otpController.text = _controllers.map((c) => c.text).join();
      });
      _focusNodes[i].addListener(() {
        setState(() {}); 
      });
    }
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

  Future<void> verifyOtp() async {
    setState(() {
      isLoading = true;
    });

    bool verified = widget.authService.verifyOtp(otpController.text);

    if (verified) {
      setState(() {
        errorMessage = "";
      });
      print("🚨 THE ID CARD I AM HANDING THE WALLET IS: '${widget.authService.accessToken}'");
      // SAVE ACCESS TOKEN
      await sessionService.saveToken(widget.authService.accessToken);

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SuccessScreen()),
        );
      }
    } else {
      setState(() {
        errorMessage = "Invalid OTP";
      });
    }

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> resendOtp() async {
    setState(() {
      seconds = 30;
    });
    
    await widget.authService.sendOtp(widget.phoneNumber.isNotEmpty ? widget.phoneNumber : "");
    startTimer();
  }

  @override
  void dispose() {
    timer?.cancel();
    otpController.dispose();
    for (var c in _controllers) {
      c.dispose();
    }
    for (var f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white, 
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    // Shield Icon
                    Image.asset(
                      'assets/otp_shield.png',
                      height: 110,
                    ),
                    const SizedBox(height: 32),
                    const Text(
                      "Enter OTP",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF111827),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "We've sent a 4-digit OTP to",
                      style: TextStyle(
                        fontSize: 15,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.phoneNumber.isNotEmpty ? widget.phoneNumber : "+91 9876543210",
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF4B1DB8),
                      ),
                    ),
                    const SizedBox(height: 40),
                    
                    // OTP Fields
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(4, (index) => _buildOtpBox(index)),
                    ),

                    const SizedBox(height: 10),
                    if (errorMessage.isNotEmpty) ...[
                      Text(errorMessage, style: const TextStyle(color: Colors.red)),
                      const SizedBox(height: 10),
                    ],

                    const SizedBox(height: 32),

                    // Resend OTP
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Didn't receive the code? ",
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                        GestureDetector(
                          onTap: seconds == 0 ? resendOtp : null,
                          child: Text(
                            seconds == 0 
                                ? "Resend OTP"
                                : "Resend OTP (00:${seconds.toString().padLeft(2, '0')})",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: seconds == 0 
                                  ? const Color(0xFF4B1DB8)
                                  : const Color(0xFF6B7280),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            // Bottom Button Section
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : verifyOtp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4B1DB8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              "Verify OTP",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.lock_outline,
                        size: 16,
                        color: Color(0xFF9CA3AF),
                      ),
                      SizedBox(width: 8),
                      Text(
                        "Your OTP is secure and will expire shortly.",
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF9CA3AF),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOtpBox(int index) {
    bool isActive = _focusNodes[index].hasFocus;
    return Container(
      width: 48,
      height: 58,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: isActive ? const Color(0xFF4B1DB8) : Colors.grey.shade300,
          width: isActive ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Focus(
          onKeyEvent: (node, event) {
            if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.backspace) {
              if (_controllers[index].text.isEmpty && index > 0) {
                FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
                return KeyEventResult.handled;
              }
            }
            return KeyEventResult.ignored;
          },
          child: TextField(
            controller: _controllers[index],
            focusNode: _focusNodes[index],
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            maxLength: 1,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            style: const TextStyle(
              fontSize: 24, 
              fontWeight: FontWeight.w600,
              color: Color(0xFF111827),
            ),
            decoration: const InputDecoration(
              counterText: "",
              contentPadding: EdgeInsets.zero,
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
            ),
            onChanged: (value) {
              if (value.isNotEmpty) {
                if (index < 3) {
                  FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
                } else {
                  _focusNodes[index].unfocus();
                }
              } else {
                if (index > 0) {
                  FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
                }
              }
            },
          ),
        ),
      ),
    );
  }
}
