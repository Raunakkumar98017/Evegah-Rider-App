import 'dart:convert';
import 'package:http/http.dart' as http;

class DigilockerService {
  // TODO: Replace with real DigiLocker backend integration
  static const bool testMode = true;

  // Use your production backend URL here. For emulator testing, use 10.0.2.2.
  static const String _baseUrl = 'http://localhost:5050';

  /// Fetch the Digilocker Authorization URL from the backend
  Future<String?> getAuthorizationUrl() async {
    if (testMode) {
      return "https://www.digilocker.gov.in/";
    }

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/api/digilocker/auth-url'),
        headers: {
          'Content-Type': 'application/json',
          // Pass authentication tokens if your backend requires it
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true && data.containsKey('authUrl')) {
          return data['authUrl'];
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Poll the backend to check the KYC status
  Future<String> getKycStatus() async {
    if (testMode) {
      await Future.delayed(const Duration(seconds: 3));
      return "verified";
    }

    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/api/digilocker/status'),
        headers: {
          'Content-Type': 'application/json',
          // Pass authentication tokens to identify the user
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['status'] ?? 'pending';
      }
      return 'pending';
    } catch (e) {
      return 'pending'; // Treat network errors as pending to keep polling, or handle accordingly
    }
  }
}
