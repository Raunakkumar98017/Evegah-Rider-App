import 'package:flutter/material.dart';

import 'package:razorpay_flutter/razorpay_flutter.dart';

import 'wallet_service.dart';

class PaymentService {
  final Razorpay _razorpay = Razorpay();

  final WalletService walletService = WalletService();

  // CALLBACKS
  Function()? onPaymentSuccess;

  Function()? onPaymentFailed;

  // STORE ORDER DATA
  String currentOrderId = "";

  double currentAmount = 0;

  PaymentService() {
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);

    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);

    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  // =========================
  // OPEN REAL CHECKOUT
  // =========================

  Future<void> openCheckout({
    required double amount,

    required String name,

    required String description,
  }) async {
    currentAmount = amount;

    // 🚀 CREATE ORDER FROM BACKEND
    final orderData = await walletService.createRechargeOrder(amount);

    if (orderData == null) {
      debugPrint("Order creation failed");

      if (onPaymentFailed != null) {
        onPaymentFailed!();
      }

      return;
    }

    currentOrderId = orderData["orderId"];

    var options = {
      // 🚀 REAL KEY FROM BACKEND
      'key': orderData["key"],

      // 🚀 ORDER ID
      'order_id': currentOrderId,

      // 🚀 AMOUNT IN PAISE
      'amount': (amount * 100).toInt(),

      'name': name,

      'description': description,

      'prefill': {'contact': '9999999999', 'email': 'user@evegah.com'},

      'theme': {'color': '#4CAF50'},
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint("Razorpay Open Error: $e");

      if (onPaymentFailed != null) {
        onPaymentFailed!();
      }
    }
  }

  // =========================
  // PAYMENT SUCCESS
  // =========================

  Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {
    debugPrint("Payment Success: ${response.paymentId}");

    // 🚀 VERIFY PAYMENT WITH BACKEND
    bool verified = await walletService.verifyPayment(
      orderId: response.orderId ?? "",

      paymentId: response.paymentId ?? "",

      signature: response.signature ?? "",
    );

    if (verified) {
      // 🚀 REFRESH WALLET
      await walletService.fetchWalletData();

      await walletService.fetchTransactions();

      if (onPaymentSuccess != null) {
        onPaymentSuccess!();
      }
    } else {
      debugPrint("Payment Verification Failed");

      if (onPaymentFailed != null) {
        onPaymentFailed!();
      }
    }
  }

  // =========================
  // PAYMENT FAILED
  // =========================

  void _handlePaymentError(PaymentFailureResponse response) {
    debugPrint("Payment Failed: ${response.message}");

    if (onPaymentFailed != null) {
      onPaymentFailed!();
    }
  }

  // =========================
  // EXTERNAL WALLET
  // =========================

  void _handleExternalWallet(ExternalWalletResponse response) {
    debugPrint("External Wallet: ${response.walletName}");
  }

  // =========================
  // DISPOSE
  // =========================

  void dispose() {
    _razorpay.clear();
  }
}
