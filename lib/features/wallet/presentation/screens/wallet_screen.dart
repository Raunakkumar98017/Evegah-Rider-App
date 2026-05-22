import 'package:flutter/material.dart';

import '../../data/services/wallet_service.dart';

import 'add_money_screen.dart';

import 'transaction_history_screen.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final WalletService walletService = WalletService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),

      appBar: AppBar(
        elevation: 0,

        backgroundColor: Colors.transparent,

        title: const Text(
          "Wallet & Payments",

          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            // WALLET CARD
            Container(
              width: double.infinity,

              padding: const EdgeInsets.all(25),

              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF4CAF50), Color(0xFF9C27B0)],
                ),

                borderRadius: BorderRadius.circular(30),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  const Text(
                    "Available Balance",

                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    "₹ ${walletService.balance.toStringAsFixed(0)}",

                    style: const TextStyle(
                      color: Colors.white,

                      fontSize: 40,

                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ADD MONEY BUTTON
                  ElevatedButton(
                    onPressed: () async {
                      await Navigator.push(
                        context,

                        MaterialPageRoute(
                          builder: (context) => const AddMoneyScreen(),
                        ),
                      );

                      setState(() {});
                    },

                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,

                      foregroundColor: Colors.black,
                    ),

                    child: const Text("Add Money"),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // TRANSACTION HISTORY BUTTON
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,

                  MaterialPageRoute(
                    builder: (context) => const TransactionHistoryScreen(),
                  ),
                );
              },

              child: Container(
                width: double.infinity,

                padding: const EdgeInsets.all(20),

                decoration: BoxDecoration(
                  color: Colors.white,

                  borderRadius: BorderRadius.circular(25),
                ),

                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(14),

                      decoration: BoxDecoration(
                        color: Colors.purple.shade100,

                        shape: BoxShape.circle,
                      ),

                      child: const Icon(Icons.history, color: Colors.purple),
                    ),

                    const SizedBox(width: 18),

                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          Text(
                            "Transaction History",

                            style: TextStyle(
                              fontWeight: FontWeight.bold,

                              fontSize: 17,
                            ),
                          ),

                          SizedBox(height: 4),

                          Text("View all wallet payments & recharges"),
                        ],
                      ),
                    ),

                    const Icon(Icons.arrow_forward_ios, size: 18),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            // REWARDS CARD
            Container(
              padding: const EdgeInsets.all(20),

              decoration: BoxDecoration(
                color: Colors.white,

                borderRadius: BorderRadius.circular(25),
              ),

              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),

                    decoration: const BoxDecoration(
                      color: Color(0xFFE8F5E9),

                      shape: BoxShape.circle,
                    ),

                    child: const Icon(Icons.eco, color: Colors.green, size: 30),
                  ),

                  const SizedBox(width: 20),

                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Text(
                          "Green Rewards",

                          style: TextStyle(
                            fontWeight: FontWeight.bold,

                            fontSize: 18,
                          ),
                        ),

                        SizedBox(height: 6),

                        Text("You saved 18kg CO₂ this month 🌱"),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // TITLE
            const Text(
              "Recent Transactions",

              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            // TRANSACTIONS
            ListView.builder(
              shrinkWrap: true,

              physics: const NeverScrollableScrollPhysics(),

              itemCount: walletService.transactions.length,

              itemBuilder: (context, index) {
                final transaction = walletService.transactions[index];

                bool isCredit = transaction["type"] == "credit";

                return Container(
                  margin: const EdgeInsets.only(bottom: 15),

                  padding: const EdgeInsets.all(18),

                  decoration: BoxDecoration(
                    color: Colors.white,

                    borderRadius: BorderRadius.circular(20),
                  ),

                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),

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

                      const SizedBox(width: 16),

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

                            const SizedBox(height: 5),

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

                      Text(
                        "${isCredit ? "+" : "-"} ₹${transaction["amount"]}",

                        style: TextStyle(
                          color: isCredit ? Colors.green : Colors.red,

                          fontWeight: FontWeight.bold,

                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
