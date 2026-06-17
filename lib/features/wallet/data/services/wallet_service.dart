import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class WalletService {
  // --- SINGLETON SETUP ---
  static final WalletService _instance = WalletService._internal();
  factory WalletService() {
    return _instance;
  }
  WalletService._internal();

  final String baseUrl = "https://admin.evegah.com/api";

 // --- 1. FETCH LIVE WALLET BALANCE ---
  Future<double> fetchWalletBalance() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('access_token');
      if (token == null || token.isEmpty) return 0.0;

      final url = Uri.parse('$baseUrl/getUser?access_token=$token');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        
        // 🚨 BULLETPROOF PARSER: Check if it's a List or Map first
        if (decoded is List) {
          if (decoded.isNotEmpty) {
            return double.tryParse(decoded[0]['walletAmount']?.toString() ?? '0') ?? 0.0;
          }
        } else if (decoded is Map) {
          final payload = decoded['data'] ?? decoded;
          if (payload is List && payload.isNotEmpty) {
            return double.tryParse(payload[0]['walletAmount']?.toString() ?? '0') ?? 0.0;
          } else if (payload is Map) {
            return double.tryParse(payload['walletAmount']?.toString() ?? '0') ?? 0.0;
          }
        }
      }
      return 0.0;
    } catch (e) {
      debugPrint("❌ Error fetching wallet balance: $e");
      return 0.0;
    }
  }

  // --- 2. FETCH REAL TRANSACTION HISTORY ---
  Future<List<Map<String, dynamic>>> fetchRecentTransactions() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('access_token');
      if (token == null || token.isEmpty) return [];

      final url = Uri.parse('$baseUrl/getLastTenTransactionList?access_token=$token');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        
        // 🚨 BULLETPROOF PARSER
        List<dynamic> data = [];
        if (decoded is List) {
          data = decoded;
        } else if (decoded is Map) {
          data = decoded['data'] ?? [];
        }

        return data.map((tx) {
          String typeEnum = tx['transactionTypeEnumId']?.toString() ?? '0';
          bool isCredit = typeEnum == '1' || (tx['transactionType']?.toString().toLowerCase().contains('recharge') ?? false);
          
          String title = isCredit ? 'Wallet Recharge' : 'Ride Payment';
          String amountRaw = tx['amount']?.toString() ?? '0';
          String sign = isCredit ? '+' : '-';
          
          String date = tx['createdDate']?.toString() ?? 'Recent';
          if (date.length > 10) date = date.substring(0, 10); 

          return {
            "title": title,
            "date": date,
            "amount": "$sign$amountRaw",
            "isCredit": isCredit
          };
        }).toList();
      }
      return [];
    } catch (e) {
      debugPrint("❌ Error fetching transactions: $e");
      return [];
    }
  }

  // --- 3. CREATE RAZORPAY ORDER ---
  Future<Map<String, String>?> createOrder(int amountInRupees) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('access_token');

      final url = Uri.parse('$baseUrl/v1/order?access_token=$token');
      debugPrint("🌐 Calling API: $url");

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "amount": amountInRupees * 100, // Razorpay expects paise!
        }),
      );

      debugPrint("📡 Server Status Code: ${response.statusCode}");
      debugPrint("📦 Server Response: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decodedData = jsonDecode(response.body);
        
        String orderId = decodedData['id'] ?? decodedData['data']?['id'] ?? decodedData['orderId'] ?? "";
        String keyId = decodedData['key_id'] ?? decodedData['data']?['key_id'] ?? "";

        if (orderId.isEmpty || keyId.isEmpty) {
           debugPrint("❌ Missing orderId or keyId in server response.");
           return null;
        }

        return {
          "orderId": orderId,
          "keyId": keyId
        };
      } else {
        debugPrint("❌ Failed to create order: ${response.body}");
        return null;
      }
    } catch (e) {
      debugPrint("❌ Wallet API Error: $e");
      return null;
    }
  }
}