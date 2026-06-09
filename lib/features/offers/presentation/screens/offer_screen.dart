import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OfferScreen extends StatefulWidget {
  const OfferScreen({super.key});

  @override
  State<OfferScreen> createState() => _OfferScreenState();
}

class _OfferScreenState extends State<OfferScreen> {
  int _selectedTabIndex = 0; // 0 for Available Offers, 1 for My Offers
  String _selectedCategory = 'All';

  final List<String> categories = ['All', 'Scooter', 'Bike', 'Car', 'Wallet'];

  final List<Map<String, dynamic>> offers = [
    {
      'title': '50% OFF up to ₦500',
      'subtitle': 'Valid on all rides',
      'expiry': 'Valid till 31 May 2025',
      'code': 'EVE50',
      'type': 'all',
      'best_offer': true,
      'color': Colors.lightGreen,
      'icon': Icons.percent,
    },
    {
      'title': '20% OFF on E-Scooters',
      'subtitle': 'Maximum discount of ₦200',
      'expiry': 'Valid till 25 May 2025',
      'code': 'SCOOT20',
      'type': 'scooter',
      'best_offer': false,
      'color': Colors.deepPurple,
      'icon': Icons.electric_scooter,
    },
    {
      'title': '15% OFF on E-Bikes',
      'subtitle': 'Maximum discount of ₦150',
      'expiry': 'Valid till 30 May 2025',
      'code': 'BIKE15',
      'type': 'bike',
      'best_offer': false,
      'color': Colors.lightGreen,
      'icon': Icons.pedal_bike,
    },
    {
      'title': 'Add money, get more!',
      'subtitle': 'Add ₦2,000 or more and get ₦150 bonus',
      'expiry': 'Valid till 31 May 2025',
      'code': 'WALLET150',
      'type': 'wallet',
      'best_offer': false,
      'color': Colors.indigo,
      'icon': Icons.account_balance_wallet,
    },
    {
      'title': '10% OFF on Cars',
      'subtitle': 'Maximum discount of ₦300',
      'expiry': 'Valid till 15 Jun 2025',
      'code': 'CAR10',
      'type': 'car',
      'best_offer': false,
      'color': Colors.lightGreen,
      'icon': Icons.directions_car,
    },
  ];

  void _copyCode(String code) {
    Clipboard.setData(ClipboardData(text: code));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("$code copied to clipboard!"), backgroundColor: Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
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
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Text(
                _selectedTabIndex == 0 ? 'Promotions & Offers' : 'My Offers',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: Colors.black),
              ),
              const SizedBox(height: 4),
              Text(
                _selectedTabIndex == 0 ? 'Save more on every ride' : "Offers you've collected or unlocked",
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              const SizedBox(height: 20),
              
              // Custom Tab Bar
              Container(
                height: 48,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedTabIndex = 0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: _selectedTabIndex == 0 ? Colors.white : Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: _selectedTabIndex == 0
                                ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)]
                                : [],
                          ),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Available Offers',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: _selectedTabIndex == 0 ? Colors.deepPurple : Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: _selectedTabIndex == 0 ? Colors.deepPurple : Colors.grey[300],
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text('6', style: TextStyle(color: _selectedTabIndex == 0 ? Colors.white : Colors.grey[600], fontSize: 10, fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedTabIndex = 1),
                        child: Container(
                          decoration: BoxDecoration(
                            color: _selectedTabIndex == 1 ? Colors.white : Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: _selectedTabIndex == 1
                                ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)]
                                : [],
                          ),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'My Offers',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: _selectedTabIndex == 1 ? Colors.deepPurple : Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: _selectedTabIndex == 1 ? Colors.deepPurple : Colors.grey[300],
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text('2', style: TextStyle(color: _selectedTabIndex == 1 ? Colors.white : Colors.grey[600], fontSize: 10, fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              if (_selectedTabIndex == 0) ...[
                // Banner
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFF8F0FF), Color(0xFFF3E5F5)], // Very light purple gradient
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 6,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Ride more, save more!',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.black),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Unlock exciting offers and\nexclusive benefits.',
                              style: TextStyle(fontSize: 13, color: Colors.grey[800], height: 1.4),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepPurple[800],
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                elevation: 0,
                                minimumSize: Size.zero,
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('View All Deals', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                                  SizedBox(width: 8),
                                  Icon(Icons.arrow_forward, color: Colors.white, size: 14),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Container(
                          height: 100,
                          alignment: Alignment.centerRight,
                          child: Icon(Icons.card_giftcard, size: 80, color: Colors.deepPurple[300]), // Placeholder for 3d gift
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Categories
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: categories.map((category) {
                      bool isSelected = _selectedCategory == category;
                      IconData icon;
                      switch (category) {
                        case 'Scooter': icon = Icons.electric_scooter; break;
                        case 'Bike': icon = Icons.pedal_bike; break;
                        case 'Car': icon = Icons.directions_car; break;
                        case 'Wallet': icon = Icons.account_balance_wallet; break;
                        default: icon = Icons.grid_view_rounded; break;
                      }

                      return GestureDetector(
                        onTap: () => setState(() => _selectedCategory = category),
                        child: Container(
                          margin: const EdgeInsets.only(right: 12),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: isSelected ? Colors.deepPurple : Colors.grey[300]!,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(icon, size: 18, color: isSelected ? Colors.deepPurple : Colors.grey[600]),
                              const SizedBox(width: 8),
                              Text(
                                category,
                                style: TextStyle(
                                  color: isSelected ? Colors.deepPurple : Colors.grey[800],
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 24),

                // Offers List
                ...offers.where((offer) {
                  if (_selectedCategory == 'All') return true;
                  return offer['type'] == _selectedCategory.toLowerCase();
                }).map((offer) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey[200]!),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.02),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        )
                      ]
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Icon Circle
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: (offer['color'] as Color).withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(offer['icon'] as IconData, color: offer['color'] as Color, size: 24),
                        ),
                        const SizedBox(width: 16),
                        // Text Info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (offer['best_offer'] == true) ...[
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.deepPurple[50],
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text('BEST OFFER', style: TextStyle(color: Colors.deepPurple[400], fontSize: 10, fontWeight: FontWeight.bold)),
                                ),
                                const SizedBox(height: 6),
                              ],
                              Text(offer['title'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              const SizedBox(height: 4),
                              Text(offer['subtitle'], style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Icon(Icons.access_time, size: 14, color: Colors.grey[500]),
                                  const SizedBox(width: 4),
                                  Text(offer['expiry'], style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // Copy Code Section
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFFDF0), // Very light yellow
                                border: Border.all(color: Colors.amber[200]!),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                offer['code'],
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87),
                              ),
                            ),
                            const SizedBox(height: 8),
                            GestureDetector(
                              onTap: () => _copyCode(offer['code']),
                              child: const Text(
                                'Copy Code',
                                style: TextStyle(color: Colors.deepPurple, fontSize: 12, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  );
                }),

                // How to use offers
                Container(
                  margin: const EdgeInsets.only(top: 8, bottom: 24),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey[200]!),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.deepPurple[50],
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.verified_user_outlined, color: Colors.deepPurple), // Shield-like icon
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('How to use offers?', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                            const SizedBox(height: 4),
                            Text('Copy the code and apply it while\nbooking your ride.', style: TextStyle(color: Colors.grey[600], fontSize: 13, height: 1.4)),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('Learn More', style: TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold, fontSize: 13)),
                            SizedBox(width: 4),
                            Icon(Icons.arrow_forward, size: 16, color: Colors.deepPurple),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 40), // Padding for scroll bottom
              ] else ...[
                // MY OFFERS TAB CONTENT
                // 1. Active Offers
                const Text('Active Offers', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
                const SizedBox(height: 4),
                Text('These offers are ready to use', style: TextStyle(fontSize: 13, color: Colors.grey[600])),
                const SizedBox(height: 12),
                
                // Active Offer Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFAFFEF), // Very light green
                    border: Border.all(color: Colors.lightGreen.withOpacity(0.3)),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Icon
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.lightGreen.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.percent, color: Colors.lightGreen, size: 24),
                      ),
                      const SizedBox(width: 16),
                      // Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.lightGreen.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text('ACTIVE', style: TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.bold)),
                            ),
                            const SizedBox(height: 6),
                            const Text('50% OFF up to ₦500', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            const SizedBox(height: 4),
                            Text('Valid on all rides', style: TextStyle(color: Colors.grey[700], fontSize: 13)),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Icon(Icons.access_time, size: 14, color: Colors.grey[500]),
                                const SizedBox(width: 4),
                                Expanded(child: Text('Valid till 31 May 2025 • Min. ride: ₦200', style: TextStyle(color: Colors.grey[500], fontSize: 12))),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Right Side Action
                      Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFFDF0),
                                  border: Border.all(color: Colors.amber[200]!),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text('EVE50', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87)),
                              ),
                              const SizedBox(width: 8),
                              const Icon(Icons.chevron_right, color: Colors.black54),
                            ],
                          ),
                          const SizedBox(height: 12),
                          GestureDetector(
                            onTap: () {},
                            child: const Row(
                              children: [
                                Text('Apply Now', style: TextStyle(color: Colors.deepPurple, fontSize: 12, fontWeight: FontWeight.bold)),
                                SizedBox(width: 4),
                                Icon(Icons.arrow_forward, size: 14, color: Colors.deepPurple),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // 2. Expired Offers
                const Text('Expired Offers', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
                const SizedBox(height: 4),
                Text('These offers have expired', style: TextStyle(fontSize: 13, color: Colors.grey[600])),
                const SizedBox(height: 12),
                
                // Expired Offer Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9F9F9),
                    border: Border.all(color: Colors.grey[200]!),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.electric_scooter, color: Colors.grey[600], size: 24),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text('EXPIRED', style: TextStyle(color: Colors.grey[700], fontSize: 10, fontWeight: FontWeight.bold)),
                            ),
                            const SizedBox(height: 6),
                            const Text('20% OFF on E-Scooters', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            const SizedBox(height: 4),
                            Text('Maximum discount of ₦200', style: TextStyle(color: Colors.grey[700], fontSize: 13)),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Icon(Icons.access_time, size: 14, color: Colors.grey[500]),
                                const SizedBox(width: 4),
                                Text('Expired on 25 May 2025', style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              border: Border.all(color: Colors.grey[300]!),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text('SCOOT20', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87)),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.chevron_right, color: Colors.black54),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // 3. Coupon History
                const Text('Coupon History', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
                const SizedBox(height: 4),
                Text("All offers you've used", style: TextStyle(fontSize: 13, color: Colors.grey[600])),
                const SizedBox(height: 12),

                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey[200]!),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8, offset: const Offset(0, 2))
                    ],
                  ),
                  child: Column(
                    children: [
                      // History Item 1
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(color: Colors.lightGreen.withOpacity(0.1), shape: BoxShape.circle),
                            child: const Icon(Icons.percent, color: Colors.lightGreen, size: 20),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('15% OFF on E-Bikes', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                                const SizedBox(height: 4),
                                Text('Maximum discount of ₦150', style: TextStyle(color: Colors.grey[700], fontSize: 12)),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    Icon(Icons.access_time, size: 12, color: Colors.grey[500]),
                                    const SizedBox(width: 4),
                                    Text('Used on 18 May 2025 • 09:15 AM', style: TextStyle(color: Colors.grey[500], fontSize: 11)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(color: Colors.lightGreen),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Text('BIKE15', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.lightGreen)),
                                  ),
                                  const SizedBox(width: 8),
                                  const Icon(Icons.chevron_right, color: Colors.black54),
                                ],
                              ),
                              const SizedBox(height: 8),
                              const Text('Saved ₦120', style: TextStyle(color: Colors.green, fontSize: 12, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Divider(height: 1, color: Color(0xFFEEEEEE)),
                      ),
                      // History Item 2
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(color: Colors.deepPurple.withOpacity(0.1), shape: BoxShape.circle),
                            child: const Icon(Icons.directions_car, color: Colors.deepPurple, size: 20),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('10% OFF on Cars', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                                const SizedBox(height: 4),
                                Text('Maximum discount of ₦300', style: TextStyle(color: Colors.grey[700], fontSize: 12)),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    Icon(Icons.access_time, size: 12, color: Colors.grey[500]),
                                    const SizedBox(width: 4),
                                    Text('Used on 10 May 2025 • 07:40 PM', style: TextStyle(color: Colors.grey[500], fontSize: 11)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(color: Colors.deepPurple[200]!),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text('CAR10', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.deepPurple[400])),
                                  ),
                                  const SizedBox(width: 8),
                                  const Icon(Icons.chevron_right, color: Colors.black54),
                                ],
                              ),
                              const SizedBox(height: 8),
                              const Text('Saved ₦200', style: TextStyle(color: Colors.green, fontSize: 12, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // 4. Promo banner at bottom
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFAF5FF), // Very light purple
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.local_offer, size: 40, color: Colors.deepPurple[400]), // Custom icon representation
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Have a promo code?', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                            const SizedBox(height: 4),
                            Text('Go to Promotions & Offers to\ndiscover more exciting deals.', style: TextStyle(color: Colors.grey[700], fontSize: 12)),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.deepPurple[50],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Row(
                          children: [
                            Text('Explore Offers', style: TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold, fontSize: 12)),
                            SizedBox(width: 4),
                            Icon(Icons.arrow_forward, color: Colors.deepPurple, size: 14),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
              ]
            ],
          ),
        ),
      ),
    );
  }
}