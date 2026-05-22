import 'package:flutter/material.dart';

import '../../data/services/wallet_service.dart';

import '../../data/services/payment_service.dart';

class AddMoneyScreen extends StatefulWidget {
  const AddMoneyScreen({super.key});

  @override
  State<AddMoneyScreen> createState() => _AddMoneyScreenState();
}

class _AddMoneyScreenState extends State<AddMoneyScreen> {
  final WalletService walletService = WalletService();

  final TextEditingController amountController = TextEditingController();

  final List<int> quickAmounts = [100, 200, 500, 1000];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),

      appBar: AppBar(
        backgroundColor: Colors.transparent,

        elevation: 0,

        title: const Text("Add Money", style: TextStyle(color: Colors.black)),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            // CARD
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
                    "Current Balance",

                    style: TextStyle(color: Colors.white70),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    "₹ ${walletService.balance.toStringAsFixed(0)}",

                    style: const TextStyle(
                      color: Colors.white,

                      fontSize: 36,

                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // ENTER AMOUNT
            TextField(
              controller: amountController,

              keyboardType: TextInputType.number,

              decoration: InputDecoration(
                hintText: "Enter amount",

                filled: true,

                fillColor: Colors.white,

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),

                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 25),

            // QUICK AMOUNTS
            Wrap(
              spacing: 15,

              children: quickAmounts.map((amount) {
                return GestureDetector(
                  onTap: () {
                    amountController.text = amount.toString();
                  },

                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 22,

                      vertical: 14,
                    ),

                    decoration: BoxDecoration(
                      color: Colors.white,

                      borderRadius: BorderRadius.circular(18),
                    ),

                    child: Text(
                      "₹$amount",

                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              }).toList(),
            ),

            const Spacer(),

            // BUTTON
            SizedBox(
              width: double.infinity,

              height: 60,

              child: ElevatedButton(
                onPressed: () {
                  double amount = double.tryParse(amountController.text) ?? 0;

                  if (amount <= 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Enter valid amount")),
                    );

                    return;
                  }

                  walletService.addMoney(amount);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("₹$amount added successfully 🎉")),
                  );

                  Navigator.pop(context);
                },

                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22),
                  ),
                ),

                child: const Text(
                  "Add Money",

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
    );
  }
}
