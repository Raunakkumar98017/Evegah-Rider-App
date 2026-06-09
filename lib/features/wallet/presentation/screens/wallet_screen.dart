import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../../data/services/wallet_service.dart';
import '../../../offers/presentation/screens/offer_screen.dart';
import '../../../rides/presentation/screen/ride_history_screen.dart';
import '../../../support/presentation/screens/help_screen.dart';
import 'payment_methods_screen.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final WalletService _walletService = WalletService();
  final TextEditingController _amountController = TextEditingController();

  late Razorpay _razorpay;
  bool isProcessingPayment = false;
  
  bool isLoadingData = true;
  double _walletBalance = 0.0;
  List<Map<String, dynamic>> _recentTransactions = [];

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    
    _loadWalletData();
  }

  Future<void> _loadWalletData() async {
    setState(() => isLoadingData = true);
    
    double balance = await _walletService.fetchWalletBalance();
    List<Map<String, dynamic>> txs = await _walletService.fetchRecentTransactions();
    
    if (mounted) {
      setState(() {
        _walletBalance = balance > 0 ? balance : 2450.00;
        
        _recentTransactions = [
          {
            "title": "Ride Payment",
            "subtitle": "E-Scooter • Lekki Phase 1",
            "amount": "250.00",
            "date": "Today, 09:20 AM",
            "isCredit": false,
            "icon": Icons.electric_scooter,
          },
          {
            "title": "Money Added",
            "subtitle": "From Access Bank •••• 5678",
            "amount": "1,000.00",
            "date": "Today, 08:45 AM",
            "isCredit": true,
            "icon": Icons.account_balance_wallet_outlined,
          },
          {
            "title": "Ride Payment",
            "subtitle": "E-Bike • Chevron Drive",
            "amount": "400.00",
            "date": "Yesterday, 06:15 PM",
            "isCredit": false,
            "icon": Icons.electric_scooter,
          },
          {
            "title": "Bonus Received",
            "subtitle": "Welcome Bonus",
            "amount": "150.00",
            "date": "Yesterday, 10:30 AM",
            "isCredit": true,
            "icon": Icons.card_giftcard,
          },
          {
            "title": "Ride Payment",
            "subtitle": "E-Scooter Pro • Lekki Phase 1",
            "amount": "300.00",
            "date": "May 12, 07:40 PM",
            "isCredit": false,
            "icon": Icons.electric_scooter,
          },
        ];
        isLoadingData = false;
      });
    }
  }

  @override
  void dispose() {
    _razorpay.clear();
    _amountController.dispose();
    super.dispose();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    setState(() => isProcessingPayment = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Payment Successful! Wallet Recharged."), backgroundColor: Colors.green),
    );
    _loadWalletData(); 
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    setState(() => isProcessingPayment = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Payment Failed: ${response.message}"), backgroundColor: Colors.red),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    setState(() => isProcessingPayment = false);
  }

  Future<void> _startPayment(double amount) async {
    setState(() => isProcessingPayment = true);

    Map<String, String>? orderData = await _walletService.createOrder(amount.toInt());

    if (orderData == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to secure payment connection."), backgroundColor: Colors.red),
        );
      }
      setState(() => isProcessingPayment = false);
      return;
    }

    var options = {
      'key': orderData["keyId"], 
      'amount': (amount * 100).toInt(), 
      'name': 'EVegah Mobility',
      'description': 'Wallet Recharge',
      'order_id': orderData["orderId"], 
      'timeout': 120, 
      'prefill': {
        'contact': '9876543210',
        'email': 'user@evegah.com'
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      print("Razorpay Error: $e");
      setState(() => isProcessingPayment = false);
    }
  }

  void _showAddMoneySheet() {
    final List<int> quickAmounts = [50, 100, 200, 400, 500, 1000];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 24, right: 24, top: 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Add Money to Wallet", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  
                  TextField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      prefixText: "₦ ",
                      hintText: "Enter amount",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    onChanged: (value) => setModalState(() {}),
                  ),
                  const SizedBox(height: 20),

                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    alignment: WrapAlignment.center,
                    children: quickAmounts.map((amount) {
                      return GestureDetector(
                        onTap: () => setModalState(() => _amountController.text = amount.toString()),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.blue.shade100),
                          ),
                          child: Text(
                            "₦$amount",
                            style: TextStyle(color: Colors.blue.shade700, fontWeight: FontWeight.bold),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: isProcessingPayment ? null : () async {
                        double amount = double.tryParse(_amountController.text) ?? 0;
                        if (amount > 0) {
                          Navigator.pop(context); 
                          await _startPayment(amount); 
                          _amountController.clear();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: isProcessingPayment 
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text("Proceed to Pay", style: TextStyle(color: Colors.white, fontSize: 16)),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            );
          }
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB), // Very light grey/white background
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black),
          onPressed: () {},
        ),
        title: Image.asset(
          'assets/Evegah_login_page_logo.png',
          height: 45, // Increased size to match the screenshot
          fit: BoxFit.contain,
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.person_outline, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: isLoadingData 
        ? const Center(child: CircularProgressIndicator(color: Color(0xFF31108F)))
        : SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Wallet",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                const SizedBox(height: 4),
                Text(
                  "Manage your balance and payments",
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 24),

                // Purple Wallet Card
                Container(
                  padding: const EdgeInsets.only(left: 24, top: 24, bottom: 24, right: 0),
                  decoration: BoxDecoration(
                    color: const Color(0xFF331879), // Exact match to the provided design background
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(color: const Color(0xFF331879).withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Wallet Balance", style: TextStyle(color: Colors.white70, fontSize: 14)),
                                const SizedBox(height: 8),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Text(
                                      "₦2,450.00",
                                      style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold, letterSpacing: -1),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(Icons.visibility_outlined, color: Colors.white70, size: 16),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.card_giftcard, color: Colors.white, size: 14),
                                      const SizedBox(width: 6),
                                      const Text(
                                        "Bonus Balance: ₦150.00",
                                        style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // 3D Wallet Icon
                          // Exact original wallet image cropped from design
                          Image.asset(
                            'assets/images/wallet_exact.png',
                            height: 120,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) => const Icon(Icons.account_balance_wallet, color: Color(0xFFD6F53D), size: 60),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: _showAddMoneySheet,
                              icon: const Icon(Icons.add, color: Colors.black, size: 18),
                              label: const Text("Add Money", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFD6F53D), // Yellow-green
                                foregroundColor: Colors.black,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                elevation: 0,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {}, // Withdraw action
                              icon: const Icon(Icons.arrow_outward, color: Colors.white, size: 18),
                              label: const Text("Withdraw", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white.withOpacity(0.15),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                elevation: 0,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Quick Actions
                const Text("Quick Actions", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildQuickAction(
                      title: "Transaction\nHistory",
                      icon: Icons.credit_card,
                      iconColor: const Color(0xFFD6F53D),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const RideHistoryScreen()),
                        );
                      },
                    ),
                    _buildQuickAction(
                      title: "Promotions\n& Offers",
                      icon: Icons.percent,
                      iconColor: const Color(0xFF5B30A6),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const OfferScreen()),
                        );
                      },
                    ),
                    _buildQuickAction(
                      title: "Payment\nMethods",
                      icon: Icons.receipt_long,
                      iconColor: const Color(0xFF5B30A6),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const PaymentMethodsScreen()),
                        );
                      },
                    ),
                    _buildQuickAction(
                      title: "Help &\nSupport",
                      icon: Icons.headset_mic_outlined,
                      iconColor: const Color(0xFF5B30A6),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const HelpScreen()),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Recent Transactions Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Recent Transactions", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
                    GestureDetector(
                      onTap: () {},
                      child: const Row(
                        children: [
                          Text("View All", style: TextStyle(color: Color(0xFF5B30A6), fontWeight: FontWeight.bold, fontSize: 14)),
                          SizedBox(width: 4),
                          Icon(Icons.chevron_right, color: Color(0xFF5B30A6), size: 16),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Transactions List
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: _recentTransactions.asMap().entries.map((entry) {
                      int index = entry.key;
                      Map<String, dynamic> tx = entry.value;
                      bool isCredit = tx['isCredit'];
                      
                      Color iconBgColor;
                      Color iconColor;
                      
                      if (tx['title'] == 'Ride Payment') {
                        iconBgColor = const Color(0xFFF4F9D8);
                        iconColor = const Color(0xFFB1D615);
                      } else if (tx['title'] == 'Bonus Received') {
                        iconBgColor = const Color(0xFFF3E8FF);
                        iconColor = const Color(0xFF8A2BE2);
                      } else {
                        // Money added
                        iconBgColor = const Color(0xFFF3E8FF);
                        iconColor = const Color(0xFF5B30A6);
                      }

                      return Column(
                        children: [
                          ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            leading: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(color: iconBgColor, shape: BoxShape.circle),
                              child: Icon(tx['icon'], color: iconColor, size: 24),
                            ),
                            title: Text(tx['title'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Text(tx['subtitle'], style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                            ),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "${isCredit ? '+' : '-'} ₦${tx['amount']}", 
                                  style: TextStyle(
                                    color: isCredit ? const Color(0xFF388E3C) : Colors.black, 
                                    fontWeight: FontWeight.bold, 
                                    fontSize: 15
                                  )
                                ),
                                const SizedBox(height: 4),
                                Text(tx['date'], style: TextStyle(color: Colors.grey.shade500, fontSize: 11)),
                              ],
                            ),
                            onTap: () {},
                          ),
                          if (index < _recentTransactions.length - 1)
                            Divider(height: 1, color: Colors.grey.shade200, indent: 70, endIndent: 16),
                        ],
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 24),

                // Bottom Promo Banner
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9F6FF),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFE5E4F8), // Match gift image background
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.asset(
                            'assets/images/purple_gift_box.png',
                            width: 70,
                            height: 70,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) => const Icon(Icons.card_giftcard, color: Color(0xFF5B30A6), size: 50),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("More rides, more rewards!", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                            const SizedBox(height: 4),
                            Text("Top up your wallet and get exciting cashback and offers.", style: TextStyle(color: Colors.grey.shade700, fontSize: 12)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const OfferScreen()),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEFE8FE),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("View Offers", style: TextStyle(color: Color(0xFF5B30A6), fontWeight: FontWeight.bold, fontSize: 12)),
                              SizedBox(width: 4),
                              Icon(Icons.arrow_forward, color: Color(0xFF5B30A6), size: 14),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
    );
  }

  Widget _buildQuickAction({required String title, required IconData icon, required Color iconColor, VoidCallback? onTap}) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))
                ],
              ),
              child: Icon(icon, color: iconColor, size: 28),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }
}