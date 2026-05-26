import 'package:flutter/material.dart';
// 🚨 IMPORT THE CHEF! (The Profile Service)
import '../../data/services/profile_service.dart';
import 'basic_profile_screen.dart';
import '../../../kyc/presentation/screens/kyc_screen.dart';
import '../../../insights/presentation/screens/insight_screen.dart';
import '../../../offers/presentation/screens/offer_screen.dart';
import '../../../security/presentation/screens/security_screen.dart';
import '../../../preferences/presentation/screens/preferences_screen.dart';
import '../../../support/presentation/screens/faq_screen.dart';
import '../../../support/presentation/screens/help_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Access the Singleton database
  final ProfileService _profileService = ProfileService();

  // This function forces the screen to rebuild and fetch fresh data
  // whenever we return to this tab!
  void _refreshProfile() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // --- DYNAMIC KYC STYLING ---
    // If the status changes to "Approved", the badge automatically turns Green!
    bool isPending = _profileService.kycStatus != "Approved";
    Color badgeColor = isPending ? Colors.orange.shade700 : Colors.green.shade700;
    Color badgeBg = isPending ? Colors.orange.shade50 : Colors.green.shade50;
    Color badgeBorder = isPending ? Colors.orange.shade200 : Colors.green.shade200;
    IconData badgeIcon = isPending ? Icons.warning_amber_rounded : Icons.verified_rounded;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          "My Profile",
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 24, color: Colors.black),
        ),
        centerTitle: false, 
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // --- 1. USER HEADER (Now Dynamic!) ---
            Row(
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundColor: Color(0xFF1E1452),
                  child: Icon(Icons.person, size: 40, color: Colors.white),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 🚨 LIVE DATA: Reading from ProfileService
                      Text(
                        _profileService.userName,
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      const SizedBox(height: 4),
                      Text(_profileService.phoneNumber, style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
                      const SizedBox(height: 8),
                      
                      // DYNAMIC KYC BADGE
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: badgeBg,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: badgeBorder),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(badgeIcon, size: 14, color: badgeColor),
                            const SizedBox(width: 4),
                            Text(
                              "KYC ${_profileService.kycStatus}", 
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: badgeColor)
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),

            // --- 2. ACCOUNT & VERIFICATION ---
            _buildMenuSection("Account", [
              ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                    leading: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(12)),
                      child: const Icon(Icons.person_outline, color: Color(0xFF1E1452), size: 22),
                    ),
                    title: const Text("Basic Profile Info", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 16)),
                    subtitle: const Text("Edit personal details", style: TextStyle(color: Colors.grey, fontSize: 13)),
                    trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    onTap: () async {
                      // 1. Go to the edit screen and WAIT for the user to come back
                      await Navigator.push(
                        context, 
                        MaterialPageRoute(builder: (context) => const BasicProfileScreen())
                      );
                      // 2. 🚨 THE YELLOW LINE KILLER: Call refresh when they return!
                      _refreshProfile(); 
                    },
                  ),
                   ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                        leading: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(color: Colors.orange.shade50, borderRadius: BorderRadius.circular(12)),
                          child: Icon(Icons.verified_user_outlined, color: Colors.orange.shade600, size: 22),
                        ),
                        title: const Text("KYC / Verification", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 16)),
                        subtitle: const Text("Upload License & Aadhaar", style: TextStyle(color: Colors.grey, fontSize: 13)),
                        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        onTap: () async {
                          // Wait for user to finish KYC
                          await Navigator.push(context, MaterialPageRoute(builder: (context) => const KycScreen()));
                          
                          // Refresh the Profile Hub so the KYC badge updates!
                          _refreshProfile(); 
                        },
                     ),
            ]),

            // --- 3. RIDES & INSIGHTS ---
            _buildMenuSection("Activity", [
             ListTile(
                 contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                 leading: Container(
                   padding: const EdgeInsets.all(10),
                   decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(12)),
                   child: const Icon(Icons.eco_outlined, color: Color(0xFF1E1452), size: 22),
                 ),
                 title: const Text("Smart Insights", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 16)),
                 subtitle: const Text("Carbon saved & ride stats", style: TextStyle(color: Colors.grey, fontSize: 13)),
                 trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                 onTap: () {
                   Navigator.push(context, MaterialPageRoute(builder: (context) => const InsightScreen()));
                 },
               ),
                  ListTile(
                   contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                    leading: Container(
                     padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(12)),
                     child: const Icon(Icons.local_offer_outlined, color: Color(0xFF1E1452), size: 22),
                   ),
                   title: const Text("Offers & Referrals", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 16)),
                   subtitle: const Text("Earn free ride credits", style: TextStyle(color: Colors.grey, fontSize: 13)),
                   trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                   onTap: () {
                     Navigator.push(context, MaterialPageRoute(builder: (context) => const OfferScreen()));
                   },
                  ),                  
            ]),

            // --- 4. SETTINGS ---
            _buildMenuSection("Settings", [
              ListTile(
               contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
               leading: Container(
                 padding: const EdgeInsets.all(10),
                 decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(12)),
                 child: const Icon(Icons.settings_outlined, color: Color(0xFF1E1452), size: 22),
               ),
               title: const Text("Preferences", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 16)),
               subtitle: const Text("App notifications & language", style: TextStyle(color: Colors.grey, fontSize: 13)),
               trailing: const Icon(Icons.chevron_right, color: Colors.grey),
               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
               onTap: () {
                 Navigator.push(context, MaterialPageRoute(builder: (context) => const PreferencesScreen()));
                },
              ),
              ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(12)),
                child: const Icon(Icons.security_rounded, color: Color(0xFF1E1452), size: 22),
              ),
              title: const Text("Security Settings", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 16)),
              subtitle: const Text("Passwords & devices", style: TextStyle(color: Colors.grey, fontSize: 13)),
             trailing: const Icon(Icons.chevron_right, color: Colors.grey),
             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const SecurityScreen()));
             },
            ),              
            ]),
            
            // --- 5. SUPPORT ---
            _buildMenuSection("Support", [
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(12)),
                  child: const Icon(Icons.help_outline_rounded, color: Color(0xFF1E1452), size: 22),
                ),
                title: const Text("FAQs", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 16)),
                subtitle: const Text("Frequently asked questions", style: TextStyle(color: Colors.grey, fontSize: 13)),
                trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const FaqScreen()));
                },
              ),
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(12)),
                  child: const Icon(Icons.support_agent_rounded, color: Color(0xFF1E1452), size: 22),
                ),
                title: const Text("Get Help", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 16)),
                subtitle: const Text("Contact customer support", style: TextStyle(color: Colors.grey, fontSize: 13)),
                trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const HelpScreen()));
                },
              ),
            ]),
            const SizedBox(height: 40),
            const Center(child: Text("EVegah Mobility App v2.0.0", style: TextStyle(color: Colors.grey, fontSize: 12))),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // --- HELPER WIDGETS ---
  Widget _buildMenuSection(String title, List<Widget> items) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8, bottom: 12),
            child: Text(
              title.toUpperCase(),
              style: const TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.bold, letterSpacing: 1.2),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: items,
            ),
          ),
        ],
      ),
    );
  }

 /* Widget _buildMenuItem(BuildContext context, IconData icon, String title, String subtitle, {bool isHighlight = false}) {
    Color iconColor = isHighlight ? Colors.orange.shade600 : const Color(0xFF1E1452);

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isHighlight ? Colors.orange.shade50 : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: iconColor, size: 22),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 16)),
      subtitle: Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 13)),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Routing to $title...")));
      },
    );
  }*/
}