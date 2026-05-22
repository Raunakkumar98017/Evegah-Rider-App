import 'dart:convert';

import 'package:http/http.dart' as http;

class WalletService {

  // =========================
  // BASE CONFIG
  // =========================

  static const String baseUrl =
      "https://admin.evegah.com";

  // ⚠️ REPLACE WITH REAL TOKEN
  static const String accessToken =
      "PASTE_REAL_ACCESS_TOKEN";

  // ⚠️ REPLACE WITH REAL USER ID
  static const String userId =
      "1";

  // =========================
  // LOCAL CACHE
  // =========================

  double _walletBalance = 0;

  double _depositBalance = 0;

  double _extraCharges = 0;

  List<Map<String, dynamic>>
      _transactions = [];

  // =========================
  // GETTERS
  // =========================

  double get walletBalance =>
      _walletBalance;

  double get depositBalance =>
      _depositBalance;

  double get extraCharges =>
      _extraCharges;

  List<Map<String, dynamic>>
      get transactions =>
          _transactions;

  // =========================
  // FETCH USER WALLET
  // =========================

  Future<bool> fetchWalletData() async {

    try {

      final response =
          await http.get(

        Uri.parse(
          "$baseUrl/getUser?id=$userId&statusEnumId=1&access_token=$accessToken",
        ),
      );

      if (response.statusCode == 200) {

        final data =
            jsonDecode(response.body);

        final user =
            data["data"][0];

        _walletBalance =
            double.tryParse(
                  user["walletAmount"]
                      .toString(),
                ) ??
                0;

        _depositBalance =
            double.tryParse(
                  user["depositAmount"]
                      .toString(),
                ) ??
                0;

        _extraCharges =
            double.tryParse(
                  user["extraCharges"]
                      .toString(),
                ) ??
                0;

        return true;
      }

      return false;

    } catch (e) {

      print(
        "Wallet Fetch Error: $e",
      );

      return false;
    }
  }

  // =========================
  // FETCH TRANSACTIONS
  // =========================

  Future<bool> fetchTransactions() async {

    try {

      final response =
          await http.get(

        Uri.parse(
          "$baseUrl/getLatestTransactionList?id=$userId&access_token=$accessToken",
        ),
      );

      if (response.statusCode == 200) {

        final data =
            jsonDecode(response.body);

        List<dynamic> list =
            data["data"];

        _transactions =
            list.map((item) {

          return {

            "title":
                item["transactionType"] ??
                    "Transaction",

            "amount":
                item["amount"] ?? 0,

            "paymentId":
                item["payment_id"] ??
                    "",

            "orderNumber":
                item["order_no"] ??
                    "",

            "type":
                item["transactionType"] ??
                    "credit",

            "time":
                item["createdAt"] ??
                    "",

            "rideId":
                item["ride_booking_id"] ??
                    "",
          };

        }).toList();

        return true;
      }

      return false;

    } catch (e) {

      print(
        "Transaction Fetch Error: $e",
      );

      return false;
    }
  }

  // =========================
  // CREATE RECHARGE ORDER
  // =========================

  Future<Map<String, dynamic>?>
      createRechargeOrder(
    double amount,
  ) async {

    try {

      final response =
          await http.post(

        Uri.parse(
          "$baseUrl/api/v1/order?access_token=$accessToken",
        ),

        headers: {

          "Content-Type":
              "application/json",
        },

        body: jsonEncode({

          "amount":
              amount,
        }),
      );

      if (response.statusCode == 200) {

        final data =
            jsonDecode(response.body);

        return {

          "orderId":
              data["order_id"],

          "key":
              data["key_id"],

          "mode":
              data["mode"],

          "raw":
              data,
        };
      }

      return null;

    } catch (e) {

      print(
        "Create Order Error: $e",
      );

      return null;
    }
  }

  // =========================
  // VERIFY PAYMENT
  // =========================

  Future<bool> verifyPayment({

    required String orderId,

    required String paymentId,

    required String signature,
  }) async {

    try {

      final response =
          await http.post(

        Uri.parse(
          "$baseUrl/api/v1/verifyPayment?access_token=$accessToken",
        ),

        headers: {

          "Content-Type":
              "application/json",
        },

        body: jsonEncode({

          "razorpay_order_id":
              orderId,

          "razorpay_payment_id":
              paymentId,

          "razorpay_signature":
              signature,
        }),
      );

      if (response.statusCode == 200) {

        final data =
            jsonDecode(response.body);

        return data[
                "signatureIsValid"] ==
            true;
      }

      return false;

    } catch (e) {

      print(
        "Verify Payment Error: $e",
      );

      return false;
    }
  }

  // =========================
  // GET ALL PAYMENTS
  // =========================

  Future<List<dynamic>>
      getAllPayments() async {

    try {

      final response =
          await http.get(

        Uri.parse(
          "$baseUrl/api/v1/getAllPayments?access_token=$accessToken",
        ),
      );

      if (response.statusCode == 200) {

        final data =
            jsonDecode(response.body);

        return data["data"] ?? [];
      }

      return [];

    } catch (e) {

      print(
        "Get Payments Error: $e",
      );

      return [];
    }
  }

  // =========================
  // WITHDRAW REQUEST
  // =========================

  Future<bool> requestWithdraw(
    double amount,
  ) async {

    try {

      final response =
          await http.post(

        Uri.parse(
          "$baseUrl/getWithdrawRequestFromUser?access_token=$accessToken",
        ),

        headers: {

          "Content-Type":
              "application/json",
        },

        body: jsonEncode({

          "id":
              userId,

          "amount":
              amount,
        }),
      );

      return response.statusCode ==
          200;

    } catch (e) {

      print(
        "Withdraw Error: $e",
      );

      return false;
    }
  }

  // =========================
  // DEDUCT RIDE FARE
  // =========================

  bool deductMoney(
    double amount,
  ) {

    if (_walletBalance < amount) {

      return false;
    }

    _walletBalance -= amount;

    _transactions.insert(0, {

      "title":
          "Ride Payment",

      "amount":
          amount,

      "type":
          "debit",

      "time":
          DateTime.now()
              .toString(),
    });

    return true;
  }
}