import 'package:flutter/material.dart';

import '../../data/services/offers_service.dart';

class OffersScreen extends StatelessWidget {
  OffersScreen({super.key});

  final OffersService offersService = OffersService();

  @override
  Widget build(BuildContext context) {
    final coupons = offersService.getCoupons();

    final banners = offersService.getPromoBanners();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),

      appBar: AppBar(
        backgroundColor: Colors.transparent,

        elevation: 0,

        title: const Text(
          "Offers & Referrals",

          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            // REFERRAL CARD
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
                    "Your Referral Code",

                    style: TextStyle(color: Colors.white70),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    offersService.getReferralCode(),

                    style: const TextStyle(
                      color: Colors.white,

                      fontSize: 34,

                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 15),

                  Text(
                    "Total Earnings: ₹${offersService.getReferralEarnings()}",

                    style: const TextStyle(color: Colors.white),
                  ),

                  const SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Referral code copied 🚀"),
                        ),
                      );
                    },

                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,

                      foregroundColor: Colors.black,
                    ),

                    child: const Text("Invite Friends"),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // PROMO BANNERS
            SizedBox(
              height: 150,

              child: ListView.builder(
                scrollDirection: Axis.horizontal,

                itemCount: banners.length,

                itemBuilder: (context, index) {
                  final banner = banners[index];

                  return Container(
                    width: 300,

                    margin: const EdgeInsets.only(right: 18),

                    padding: const EdgeInsets.all(22),

                    decoration: BoxDecoration(
                      color: Colors.white,

                      borderRadius: BorderRadius.circular(28),
                    ),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      mainAxisAlignment: MainAxisAlignment.center,

                      children: [
                        Text(
                          banner["title"],

                          style: const TextStyle(
                            fontSize: 22,

                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 12),

                        Text(banner["subtitle"]),
                      ],
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              "Available Coupons",

              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            // COUPON LIST
            ...coupons.map((coupon) {
              return Container(
                margin: const EdgeInsets.only(bottom: 18),

                padding: const EdgeInsets.all(20),

                decoration: BoxDecoration(
                  color: Colors.white,

                  borderRadius: BorderRadius.circular(24),
                ),

                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 28,

                      backgroundColor: Colors.green.shade100,

                      child: const Icon(Icons.local_offer, color: Colors.green),
                    ),

                    const SizedBox(width: 18),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          Text(
                            coupon["title"],

                            style: const TextStyle(
                              fontSize: 18,

                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 8),

                          Text(coupon["description"]),

                          const SizedBox(height: 10),

                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,

                              vertical: 8,
                            ),

                            decoration: BoxDecoration(
                              color: Colors.black,

                              borderRadius: BorderRadius.circular(18),
                            ),

                            child: Text(
                              coupon["code"],

                              style: const TextStyle(
                                color: Colors.white,

                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
