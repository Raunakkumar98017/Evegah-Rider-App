class AppConstants {
  // Network Configurations
  static const String apiBaseUrl = 'https://api.evegah.com/api/v1'; // Change as per environment
  static const String websocketUrl = 'wss://api.evegah.com/ws';

  // Secure Storage & Shared Preference Keys
  static const String keyAccessToken = 'access_token';
  static const String keyRefreshToken = 'refresh_token';
  static const String keyIsLoggedIn = 'is_logged_in';
  static const String keyUserProfile = 'user_profile';

  // Assets Paths
  static const String logoImg = 'assets/Evegah_login_page_logo.png';
  static const String loginBgImg = 'assets/login_page_b.jpeg';
}
