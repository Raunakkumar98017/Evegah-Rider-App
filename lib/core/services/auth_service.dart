import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;

class AuthService {
  static const String baseUrl = "https://admin.evegah.com/api/";

  // GENERATED OTP
  String generatedOtp = "";

  // ACCESS TOKEN
  String accessToken = "";

  // CHECK MOBILE NUMBER
  Future<bool> checkMobileNumber(String mobileNumber) async {
    final url = Uri.parse("${baseUrl}CheckCustomerMobileNumber");

    final response = await http.post(
      url,

      headers: {"Content-Type": "application/json"},

      body: jsonEncode({"mobileNumber": mobileNumber}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      accessToken =
          data["access_token"] ?? data["accessToken"] ?? data["token"] ?? "";

      return true;
    }

    return false;
  }

  // GENERATE OTP
  String generateOtp() {
    final random = Random();

    generatedOtp = (1000 + random.nextInt(9000)).toString();

    return generatedOtp;
  }

  // SEND OTP USING 2FACTOR
  Future<bool> sendOtp(String mobileNumber) async {
    generateOtp();

    final url = Uri.parse(
      "https://2factor.in/API/V1/7d84d134-26fe-11ed-9c12-0200cd936042/SMS/$mobileNumber/$generatedOtp/eVegah+SMS",
    );

    final response = await http.get(url);

    return response.statusCode == 200;
  }

  // VERIFY OTP
  bool verifyOtp(String otp) {
    return otp == generatedOtp;
  }
}
