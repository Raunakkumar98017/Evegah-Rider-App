import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

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
      'title': '50% OFF up to â‚¦500',
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
      'subtitle': 'Maximum discount of â‚¦200',
      'expiry': 'Valid till 25 May 2025',
      'code': 'SCOOT20',
      'type': 'scooter',
      'best_offer': false,
      'color': Colors.deepPurple,
      'icon': Icons.electric_scooter,
    },
    {
      'title': '15% OFF on E-Bikes',
      'subtitle': 'Maximum discount of â‚¦150',
      'expiry': 'Valid till 30 May 2025',
      'code': 'BIKE15',
      'type': 'bike',
      'best_offer': false,
      'color': Colors.lightGreen,
      'icon': Icons.pedal_bike,
    },
    {
      'title': 'Add money, get more!',
      'subtitle': 'Add â‚¦2,000 or more and get â‚¦150 bonus',
      'expiry': 'Valid till 31 May 2025',
      'code': 'WALLET150',
      'type': 'wallet',
      'best_offer': false,
      'color': Colors.indigo,
      'icon': Icons.account_balance_wallet,
    },
    {
      'title': '10% OFF on Cars',
      'subtitle': 'Maximum discount of â‚¦300',
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
      backgroundColor: const Color(0xFFF8F8FA), // Design spec background
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F8FA),
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Image.asset(
          'assets/Evegah_login_page_logo.png',
          height: 45,
          fit: BoxFit.contain,
        ),
        centerTitle: true, // FIX #5: Center logo
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
          padding: const EdgeInsets.symmetric(horizontal: 16.0), // Design: screen padding = 16
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Text(
                _selectedTabIndex == 0 ? 'Promotions & Offers' : 'My Offers',
                style: GoogleFonts.poppins(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black), // Design: Title = 32 Bold
              ),
              const SizedBox(height: 4),
              Text(
                _selectedTabIndex == 0 ? 'Save more on every ride' : "Offers you've collected or unlocked",
                style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600]), // Design: Body = 14 Regular
              ),
              const SizedBox(height: 20),
              
              // Custom Tab Bar
              Container(
                height: 48,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(24), // Design: Cards = 24
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
                                Flexible(
                                  child: Text(
                                    'Available Offers',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                      color: _selectedTabIndex == 0 ? const Color(0xFF4B1DB8) : Colors.grey[600],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: _selectedTabIndex == 0 ? const Color(0xFF4B1DB8) : Colors.grey[300],
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text('6', style: GoogleFonts.poppins(color: _selectedTabIndex == 0 ? Colors.white : Colors.grey[600], fontSize: 10, fontWeight: FontWeight.bold)),
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
                                Flexible(
                                  child: Text(
                                    'My Offers',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                      color: _selectedTabIndex == 1 ? const Color(0xFF4B1DB8) : Colors.grey[600],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: _selectedTabIndex == 1 ? const Color(0xFF4B1DB8) : Colors.grey[300],
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text('2', style: GoogleFonts.poppins(color: _selectedTabIndex == 1 ? Colors.white : Colors.grey[600], fontSize: 10, fontWeight: FontWeight.bold)),
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
                // FIX #3: Banner - use actual gift box image instead of generic icon
                Container(
                  padding: const EdgeInsets.all(20), // Design: card padding = 20
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFF8F0FF), Color(0xFFF3E5F5)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24), // Design: Cards = 24
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 6,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Ride more, save more!',
                              style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.black), // Design: Section Title = 18 SemiBold
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Unlock exciting offers and\nexclusive benefits.',
                              style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[800], height: 1.4),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF4B1DB8), // Design: Primary Purple
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), // Design: Buttons = 16
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                elevation: 0,
                                minimumSize: Size.zero,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('View All Deals', style: GoogleFonts.poppins(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                                  const SizedBox(width: 8),
                                  const Icon(Icons.arrow_forward, color: Colors.white, size: 14),
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
                          child: Image.asset(
                            'assets/images/purple_gift_box.png',
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) => Icon(Icons.card_giftcard, size: 80, color: Colors.deepPurple[300]),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // FIX #4: Categories - SingleChildScrollView for horizontal scrolling (no clipping)
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
                            color: isSelected ? const Color(0xFF4B1DB8) : Colors.white,
                            border: Border.all(
                              color: isSelected ? const Color(0xFF4B1DB8) : Colors.grey[300]!,
                            ),
                            borderRadius: BorderRadius.circular(14), // Design: Tabs = 14
                          ),
                          child: Row(
                            children: [
                              Icon(icon, size: 18, color: isSelected ? Colors.white : Colors.grey[600]),
                              const SizedBox(width: 8),
                              Text(
                                category,
                                style: GoogleFonts.poppins(
                                  color: isSelected ? Colors.white : Colors.grey[800],
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
                    padding: const EdgeInsets.all(20), // Design: card padding = 20
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey[200]!),
                      borderRadius: BorderRadius.circular(24), // Design: Cards = 24
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
                                    color: const Color(0xFFF3E8FF),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text('BEST OFFER', style: GoogleFonts.poppins(color: const Color(0xFF4B1DB8), fontSize: 10, fontWeight: FontWeight.bold)),
                                ),
                                const SizedBox(height: 6),
                              ],
                              Text(offer['title'], style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 14)),
                              const SizedBox(height: 4),
                              Text(offer['subtitle'], style: GoogleFonts.poppins(color: Colors.grey[600], fontSize: 12)),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Icon(Icons.access_time, size: 14, color: Colors.grey[500]),
                                  const SizedBox(width: 4),
                                  Flexible(child: Text(offer['expiry'], style: GoogleFonts.poppins(color: Colors.grey[500], fontSize: 12))),
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
                                color: const Color(0xFFFFFDF0),
                                border: Border.all(color: Colors.amber[200]!),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                offer['code'],
                                style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black87),
                              ),
                            ),
                            const SizedBox(height: 8),
                            GestureDetector(
                              onTap: () => _copyCode(offer['code']),
                              child: Text(
                                'Copy Code',
                                style: GoogleFonts.poppins(color: const Color(0xFF4B1DB8), fontSize: 12, fontWeight: FontWeight.w600),
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
                  padding: const EdgeInsets.all(20), // Design: card padding = 20
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey[200]!),
                    borderRadius: BorderRadius.circular(24), // Design: Cards = 24
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3E8FF),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.verified_user_outlined, color: Color(0xFF4B1DB8)),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('How to use offers?', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 14)),
                            const SizedBox(height: 4),
                            Text('Copy the code and apply it while\nbooking your ride.', style: GoogleFonts.poppins(color: Colors.grey[600], fontSize: 12, height: 1.4)),
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
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('Learn More', style: GoogleFonts.poppins(color: const Color(0xFF4B1DB8), fontWeight: FontWeight.bold, fontSize: 12)),
                            const SizedBox(width: 4),
                            const Icon(Icons.arrow_forward, size: 16, color: Color(0xFF4B1DB8)),
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
                Text('Active Offers', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black)),
                const SizedBox(height: 4),
                Text('These offers are ready to use', style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600])),
                const SizedBox(height: 12),
                
                // FIX #6: Active Offer Card - increased padding
                Container(
                  padding: const EdgeInsets.all(20), // Design: card padding = 20
                  decoration: BoxDecoration(
                    color: const Color(0xFFFAFFEF),
                    border: Border.all(color: Colors.lightGreen.withOpacity(0.3)),
                    borderRadius: BorderRadius.circular(24), // Design: Cards = 24
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
                              child: Text('ACTIVE', style: GoogleFonts.poppins(color: Colors.green, fontSize: 10, fontWeight: FontWeight.bold)),
                            ),
                            const SizedBox(height: 6),
                            Text('50% OFF up to â‚¦500', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 14)),
                            const SizedBox(height: 4),
                            Text('Valid on all rides', style: GoogleFonts.poppins(color: Colors.grey[700], fontSize: 12)),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Icon(Icons.access_time, size: 14, color: Colors.grey[500]),
                                const SizedBox(width: 4),
                                Expanded(child: Text('Valid till 31 May 2025 â€¢ Min. ride: â‚¦200', style: GoogleFonts.poppins(color: Colors.grey[500], fontSize: 12))),
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
                                child: Text('EVE50', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black87)),
                              ),
                              const SizedBox(width: 8),
                              const Icon(Icons.chevron_right, color: Colors.black54),
                            ],
                          ),
                          const SizedBox(height: 12),
                          GestureDetector(
                            onTap: () {},
                            child: Row(
                              children: [
                                Text('Apply Now', style: GoogleFonts.poppins(color: const Color(0xFF4B1DB8), fontSize: 12, fontWeight: FontWeight.bold)),
                                const SizedBox(width: 4),
                                const Icon(Icons.arrow_forward, size: 14, color: Color(0xFF4B1DB8)),
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
                Text('Expired Offers', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black)),
                const SizedBox(height: 4),
                Text('These offers have expired', style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600])),
                const SizedBox(height: 12),
                
                // Expired Offer Card
                Container(
                  padding: const EdgeInsets.all(20), // Design: card padding = 20
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9F9F9),
                    border: Border.all(color: Colors.grey[200]!),
                    borderRadius: BorderRadius.circular(24), // Design: Cards = 24
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
                              child: Text('EXPIRED', style: GoogleFonts.poppins(color: Colors.grey[700], fontSize: 10, fontWeight: FontWeight.bold)),
                            ),
                            const SizedBox(height: 6),
                            Text('20% OFF on E-Scooters', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 14)),
                            const SizedBox(height: 4),
                            Text('Maximum discount of â‚¦200', style: GoogleFonts.poppins(color: Colors.grey[700], fontSize: 12)),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Icon(Icons.access_time, size: 14, color: Colors.grey[500]),
                                const SizedBox(width: 4),
                                Expanded(child: Text('Expired on 25 May 2025', style: GoogleFonts.poppins(color: Colors.grey[500], fontSize: 12))),
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
                            child: Text('SCOOT20', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black87)),
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
                Text('Coupon History', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black)),
                const SizedBox(height: 4),
                Text("All offers you've used", style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600])),
                const SizedBox(height: 12),

                Container(
                  padding: const EdgeInsets.all(20), // Design: card padding = 20
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey[200]!),
                    borderRadius: BorderRadius.circular(24), // Design: Cards = 24
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
                                Text('15% OFF on E-Bikes', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 14)),
                                const SizedBox(height: 4),
                                Text('Maximum discount of â‚¦150', style: GoogleFonts.poppins(color: Colors.grey[700], fontSize: 12)),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    Icon(Icons.access_time, size: 12, color: Colors.grey[500]),
                                    const SizedBox(width: 4),
                                    Expanded(child: Text('Used on 18 May 2025 â€¢ 09:15 AM', style: GoogleFonts.poppins(color: Colors.grey[500], fontSize: 12))),
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
                                    child: Text('BIKE15', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.lightGreen)),
                                  ),
                                  const SizedBox(width: 8),
                                  const Icon(Icons.chevron_right, color: Colors.black54),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text('Saved â‚¦120', style: GoogleFonts.poppins(color: Colors.green, fontSize: 12, fontWeight: FontWeight.bold)),
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
                                Text('10% OFF on Cars', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 14)),
                                const SizedBox(height: 4),
                                Text('Maximum discount of â‚¦300', style: GoogleFonts.poppins(color: Colors.grey[700], fontSize: 12)),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    Icon(Icons.access_time, size: 12, color: Colors.grey[500]),
                                    const SizedBox(width: 4),
                                    Expanded(child: Text('Used on 10 May 2025 â€¢ 07:40 PM', style: GoogleFonts.poppins(color: Colors.grey[500], fontSize: 12))),
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
                                    child: Text('CAR10', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.deepPurple[400])),
                                  ),
                                  const SizedBox(width: 8),
                                  const Icon(Icons.chevron_right, color: Colors.black54),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text('Saved â‚¦200', style: GoogleFonts.poppins(color: Colors.green, fontSize: 12, fontWeight: FontWeight.bold)),
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
                  padding: const EdgeInsets.all(20), // Design: card padding = 20
                  decoration: BoxDecoration(
                    color: const Color(0xFFFAF5FF),
                    borderRadius: BorderRadius.circular(24), // Design: Cards = 24
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/images/purple_gift_box.png',
                        width: 40,
                        height: 40,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) => Icon(Icons.local_offer, size: 40, color: Colors.deepPurple[400]),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Have a promo code?', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 14)),
                            const SizedBox(height: 4),
                            Text('Go to Promotions & Offers to\ndiscover more exciting deals.', style: GoogleFonts.poppins(color: Colors.grey[700], fontSize: 12)),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3E8FF),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            Text('Explore Offers', style: GoogleFonts.poppins(color: const Color(0xFF4B1DB8), fontWeight: FontWeight.bold, fontSize: 12)),
                            const SizedBox(width: 4),
                            const Icon(Icons.arrow_forward, color: Color(0xFF4B1DB8), size: 14),
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
