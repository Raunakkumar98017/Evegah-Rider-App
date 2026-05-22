class ProfileService {
  // USER DATA
  String fullName = "Daksh Parmar";

  String email = "daksh@evegah.com";

  String mobile = "+91 9876543210";

  String gender = "Male";

  String profileImage = "";

  // PROFILE COMPLETION
  int getProfileCompletion() {
    int completed = 0;

    if (fullName.isNotEmpty) {
      completed += 20;
    }

    if (email.isNotEmpty) {
      completed += 20;
    }

    if (mobile.isNotEmpty) {
      completed += 20;
    }

    if (gender.isNotEmpty) {
      completed += 20;
    }

    if (profileImage.isNotEmpty) {
      completed += 20;
    }

    return completed;
  }

  // UPDATE PROFILE
  Future<bool> updateProfile({
    required String name,

    required String userEmail,

    required String phone,

    required String userGender,
  }) async {
    await Future.delayed(const Duration(seconds: 2));

    fullName = name;

    email = userEmail;

    mobile = phone;

    gender = userGender;

    return true;
  }

  // UPDATE IMAGE
  void updateProfileImage(String imagePath) {
    profileImage = imagePath;
  }
}
