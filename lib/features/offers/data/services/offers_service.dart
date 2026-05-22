class OffersService {
  // REFERRAL CODE
  String getReferralCode() {
    return "EVG2026";
  }

  // TOTAL REFERRAL EARNINGS
  double getReferralEarnings() {
    return 850;
  }

  // ACTIVE COUPONS
  List<Map<String, dynamic>> getCoupons() {
    return [
      {
        "title": "20% OFF Ride",

        "code": "RIDE20",

        "description": "Get 20% off on your next EV ride.",
      },

      {
        "title": "₹100 Wallet Cashback",

        "code": "CASH100",

        "description": "Recharge wallet & earn cashback.",
      },

      {
        "title": "Weekend EV Offer",

        "code": "WEEKEND50",

        "description": "Flat ₹50 off on weekend rides.",
      },
    ];
  }

  // PROMO BANNERS
  List<Map<String, dynamic>> getPromoBanners() {
    return [
      {
        "title": "Invite Friends & Earn ₹100",

        "subtitle": "Share your referral code now 🚀",
      },

      {
        "title": "Green Ride Rewards 🌱",

        "subtitle": "Save CO₂ & unlock special offers.",
      },
    ];
  }
}
