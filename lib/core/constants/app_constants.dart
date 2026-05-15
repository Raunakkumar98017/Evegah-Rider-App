class AppConstants {
  // Network Configurations
  static const String apiBaseUrl = 'https://admin.evegah.com/api/'; // Change as per environment
  static const String websocketUrl = 'wss://api.evegah.com/ws';
  // Vehicle & Map API Endpoints
  static const String getLiveZones = 'https://admin.evegah.com/api/v1/getzoneDetailWithBikeCountList';
  static const String decryptQr = 'https://admin.evegah.com/api/qrDecrypted';
  static const String getVehicleModel = 'https://admin.evegah.com/api/v1/getVehicleModel';

  // Secure Storage & Shared Preference Keys
  static const String keyAccessToken = 'access_token';
  static const String keyRefreshToken = 'refresh_token';
  static const String keyIsLoggedIn = 'is_logged_in';
  static const String keyUserProfile = 'user_profile';

  // Assets Paths
  static const String logoImg = 'assets/Evegah_login_page_logo.png';
  static const String loginBgImg = 'assets/login_page_b.jpeg';
}
