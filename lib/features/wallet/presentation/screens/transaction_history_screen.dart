import 'package:flutter/material.dart';

import '../../data/services/wallet_service.dart';

class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({super.key});

  @override
  State<TransactionHistoryScreen> createState() =>
      _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  final WalletService walletService = WalletService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),

      appBar: AppBar(
        backgroundColor: Colors.transparent,

        elevation: 0,

        title: const Text(
          "Transaction History",

          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),

      body: walletService.transactions.isEmpty
          ? const Center(child: Text("No Transactions Yet"))
          : ListView.builder(
              padding: const EdgeInsets.all(20),

              itemCount: walletService.transactions.length,

              itemBuilder: (context, index) {
                final transaction = walletService.transactions[index];

                bool isCredit = transaction["type"] == "credit";

                return Container(
                  margin: const EdgeInsets.only(bottom: 18),

                  padding: const EdgeInsets.all(20),

                  decoration: BoxDecoration(
                    color: Colors.white,

                    borderRadius: BorderRadius.circular(24),

                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),

                        blurRadius: 12,
                      ),
                    ],
                  ),

                  child: Row(
                    children: [
                      // ICON
                      Container(
                        padding: const EdgeInsets.all(14),

                        decoration: BoxDecoration(
                          color: isCredit
                              ? Colors.green.shade100
                              : Colors.red.shade100,

                          shape: BoxShape.circle,
                        ),

                        child: Icon(
                          isCredit ? Icons.arrow_downward : Icons.arrow_upward,

                          color: isCredit ? Colors.green : Colors.red,
                        ),
                      ),

                      const SizedBox(width: 18),

                      // DETAILS
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            Text(
                              transaction["title"],

                              style: const TextStyle(
                                fontWeight: FontWeight.bold,

                                fontSize: 16,
                              ),
                            ),

                            const SizedBox(height: 6),

                            Text(
                              transaction["time"],

                              style: const TextStyle(
                                color: Colors.grey,

                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // AMOUNT
                      Text(
                        "${isCredit ? "+" : "-"} ₹${transaction["amount"]}",

                        style: TextStyle(
                          color: isCredit ? Colors.green : Colors.red,

                          fontWeight: FontWeight.bold,

                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
