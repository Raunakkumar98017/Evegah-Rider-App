import 'package:flutter/material.dart';
import '../../data/services/profile_service.dart';
import 'basic_profile_screen.dart';
import '../../../kyc/presentation/screens/kyc_screen.dart';
import '../../../insights/presentation/screens/insight_screen.dart';
import '../../../offers/presentation/screens/offer_screen.dart';
import '../../../security/presentation/screens/security_screen.dart';
import '../../../preferences/presentation/screens/preferences_screen.dart';
import '../../../support/presentation/screens/faq_screen.dart';
import '../../../support/presentation/screens/help_screen.dart';
import '../../../battery/presentation/screens/battery_dashboard_screen.dart';
import '../../../wallet/presentation/screens/wallet_screen.dart';
import '../../../rides/presentation/screen/ride_history_screen.dart';
import '../../../auth/presentation/screens/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {
  final ProfileService _profileService = ProfileService();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _refreshProfile() {
    setState(() {});
  }

  void _handleLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Logout", style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text("Are you sure you want to log out of your EVagah Rider account?"),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text("Logout", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 16),
                _buildHeader(),
                const SizedBox(height: 24),
                _buildHeroCard(),
                const SizedBox(height: 24),
                _buildSections(),
                const SizedBox(height: 40),
                const Center(
                  child: Text("EVegah Mobility App v2.0.0", style: TextStyle(color: Colors.grey, fontSize: 12)),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "My Profile",
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: Color(0xFF1E1452)),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4)),
              ],
            ),
            child: const Icon(Icons.person_outline, color: Color(0xFF4B1DB8), size: 22),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroCard() {
    String initials = "ER";
    if (_profileService.userName.isNotEmpty) {
      List<String> names = _profileService.userName.trim().split(" ");
      initials = names.map((n) => n.isNotEmpty ? n[0] : "").take(2).join("").toUpperCase();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 230,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF2A1B70), Color(0xFF4B1DB8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF4B1DB8).withValues(alpha: 0.4),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1452),
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFFD8F238), width: 2),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      initials,
                      style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _profileService.userName.isNotEmpty ? _profileService.userName : "Daksh Parmar",
                          style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.electric_scooter, color: Color(0xFFD8F238), size: 14),
                            const SizedBox(width: 4),
                            const Text(
                              "EVagah Rider",
                              style: TextStyle(color: Color(0xFFD8F238), fontSize: 12, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "Assigned: EVG-SCOOTER-102",
                          style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 12),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildHeroStat("124", "Total Rides"),
                    _buildStatDivider(),
                    _buildHeroStat("385 km", "Distance"),
                    _buildStatDivider(),
                    _buildHeroStat("22 kg", "CO₂ Saved"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatDivider() {
    return Container(
      width: 1,
      height: 30,
      color: Colors.white.withValues(alpha: 0.2),
    );
  }

  Widget _buildHeroStat(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 11),
        ),
      ],
    );
  }

  Widget _buildSections() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildSectionTitle("ACCOUNT"),
          _buildSectionGroup([
            _buildTile(title: "Basic Profile Info", subtitle: "Manage personal details", icon: Icons.person_outline, onTap: () async {
              await Navigator.push(context, MaterialPageRoute(builder: (_) => const BasicProfileScreen()));
              _refreshProfile();
            }),
            _buildDivider(),
            _buildTile(title: "KYC Verification", subtitle: "Manage rider verification", icon: Icons.verified_user_rounded, onTap: () async {
              await Navigator.push(context, MaterialPageRoute(builder: (_) => const KycScreen()));
              _refreshProfile();
            }),
          ]),
          const SizedBox(height: 24),
          
          _buildSectionTitle("MY EVAGAH"),
          _buildSectionGroup([
            _buildTile(title: "My Connected Vehicle", subtitle: "Bluetooth pairing status", icon: Icons.bluetooth_connected, iconBgColor: const Color(0xFFD8F238).withValues(alpha: 0.2), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BatteryDashboardScreen()))),
            _buildDivider(),
            _buildTile(title: "My Battery", subtitle: "Live diagnostics & health", icon: Icons.battery_charging_full_rounded, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BatteryDashboardScreen()))),
            _buildDivider(),
            _buildTile(title: "Wallet", subtitle: "Manage balance & payments", icon: Icons.account_balance_wallet_rounded, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const WalletScreen()))),
            _buildDivider(),
            _buildTile(title: "Ride History", subtitle: "View previous rides", icon: Icons.history_rounded, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RideHistoryScreen()))),
          ]),
          const SizedBox(height: 24),
          
          _buildSectionTitle("ACTIVITY"),
          _buildSectionGroup([
            _buildTile(title: "Smart Insights", subtitle: "Riding statistics", icon: Icons.insights_rounded, onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const InsightScreen()));
            }),
            _buildDivider(),
            _buildTile(title: "Offers & Referrals", subtitle: "Invite friends & earn", icon: Icons.local_offer_outlined, onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const OfferScreen()));
            }),
          ]),
          const SizedBox(height: 24),
          
          _buildSectionTitle("SETTINGS"),
          _buildSectionGroup([
            _buildTile(title: "Preferences", subtitle: "App settings & notifications", icon: Icons.settings_outlined, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PreferencesScreen()))),
            _buildDivider(),
            _buildTile(title: "Security Settings", subtitle: "Passwords & biometrics", icon: Icons.security_rounded, onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const SecurityScreen()));
            }),
          ]),
          const SizedBox(height: 24),
          
          _buildSectionTitle("SUPPORT"),
          _buildSectionGroup([
            _buildTile(title: "Help & Support", subtitle: "Contact EVagah team", icon: Icons.support_agent, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HelpScreen()))),
            _buildDivider(),
            _buildTile(title: "FAQ", subtitle: "Frequently asked questions", icon: Icons.help_outline_rounded, onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const FaqScreen()));
            }),
          ]),
          const SizedBox(height: 24),
          
          _buildSectionTitle("LOGOUT"),
          _buildSectionGroup([
            _buildTile(
              title: "Logout", 
              subtitle: "Sign out securely", 
              icon: Icons.logout_rounded, 
              iconBgColor: Colors.red.shade50, 
              iconColor: Colors.red.shade600, 
              titleColor: Colors.red.shade700, 
              onTap: _handleLogout,
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 12),
      child: Text(
        title,
        style: const TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.bold, letterSpacing: 1.2),
      ),
    );
  }

  Widget _buildSectionGroup(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 15, offset: const Offset(0, 4)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Column(
          children: children,
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.only(left: 64, right: 20),
      child: Divider(height: 1, color: Colors.grey.shade100),
    );
  }

  Widget _buildTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
    Color? iconBgColor,
    Color? iconColor,
    Color? titleColor,
  }) {
    Color finalIconBgColor = iconBgColor ?? Colors.grey.shade100;
    Color finalIconColor = iconColor ?? const Color(0xFF1E1452);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        splashColor: finalIconBgColor.withValues(alpha: 0.5),
        highlightColor: finalIconBgColor.withValues(alpha: 0.3),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: finalIconBgColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: finalIconColor, size: 22),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: titleColor ?? const Color(0xFF1E1452),
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.grey.shade300, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}