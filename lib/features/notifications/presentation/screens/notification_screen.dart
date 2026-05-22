import 'package:flutter/material.dart';

import '../../data/services/notification_service.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final NotificationService notificationService = NotificationService();

  final List<Map<String, dynamic>> notifications = [
    {
      "title": "Ride Started 🚀",

      "body": "Your EV ride has started successfully.",

      "time": "2 mins ago",

      "icon": Icons.electric_bike,
    },

    {
      "title": "Wallet Recharge 💳",

      "body": "₹500 added successfully.",

      "time": "10 mins ago",

      "icon": Icons.account_balance_wallet,
    },

    {
      "title": "Ride Completed ✅",

      "body": "₹52 deducted from wallet.",

      "time": "30 mins ago",

      "icon": Icons.check_circle,
    },

    {
      "title": "Nearby EV Found 📍",

      "body": "2 EV bikes available nearby.",

      "time": "1 hour ago",

      "icon": Icons.location_on,
    },

    {
      "title": "Low Battery Alert ⚠️",

      "body": "Vehicle battery below 20%.",

      "time": "2 hours ago",

      "icon": Icons.battery_alert,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),

      appBar: AppBar(
        elevation: 0,

        backgroundColor: Colors.transparent,

        title: const Text(
          "Notifications",

          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),

        actions: [
          IconButton(
            onPressed: () async {
              await notificationService.showNotification(
                title: "eVegah Test 🚀",

                body: "Notifications are working successfully!",
              );
            },

            icon: const Icon(Icons.notifications_active, color: Colors.black),
          ),
        ],
      ),

      body: ListView.builder(
        padding: const EdgeInsets.all(20),

        itemCount: notifications.length,

        itemBuilder: (context, index) {
          final notification = notifications[index];

          return Container(
            margin: const EdgeInsets.only(bottom: 18),

            padding: const EdgeInsets.all(18),

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
                Container(
                  padding: const EdgeInsets.all(14),

                  decoration: BoxDecoration(
                    color: Colors.green.shade100,

                    shape: BoxShape.circle,
                  ),

                  child: Icon(notification["icon"], color: Colors.green),
                ),

                const SizedBox(width: 18),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Text(
                        notification["title"],

                        style: const TextStyle(
                          fontWeight: FontWeight.bold,

                          fontSize: 16,
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text(
                        notification["body"],

                        style: const TextStyle(color: Colors.grey),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        notification["time"],

                        style: const TextStyle(
                          color: Colors.black45,

                          fontSize: 12,
                        ),
                      ),
                    ],
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
