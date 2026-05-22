class SecurityService {
  // CHANGE PASSWORD
  Future<bool> changePassword({
    required String oldPassword,

    required String newPassword,
  }) async {
    await Future.delayed(const Duration(seconds: 2));

    return true;
  }

  // LOGOUT
  Future<bool> logout() async {
    await Future.delayed(const Duration(seconds: 1));

    return true;
  }

  // DELETE ACCOUNT
  Future<bool> deleteAccount() async {
    await Future.delayed(const Duration(seconds: 2));

    return true;
  }

  // GET LOGIN DEVICES
  List<Map<String, dynamic>> getLoginDevices() {
    return [
      {"device": "Pixel 7 Pro", "location": "Ahmedabad", "active": true},

      {"device": "Chrome Windows", "location": "Vadodara", "active": false},
    ];
  }
}
