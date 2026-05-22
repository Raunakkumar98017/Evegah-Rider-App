class KycService {
  // KYC STATUS
  String getKycStatus() {
    return "Pending";
  }

  // USER DOCUMENTS
  List<Map<String, dynamic>> getUploadedDocuments() {
    return [
      {"title": "Driving License", "status": "Uploaded"},

      {"title": "Aadhaar Card", "status": "Pending"},

      {"title": "Selfie Verification", "status": "Not Uploaded"},
    ];
  }

  // SUBMIT DOCUMENT
  Future<bool> uploadDocument({required String documentType}) async {
    await Future.delayed(const Duration(seconds: 2));

    return true;
  }

  // VERIFY KYC
  Future<bool> verifyKyc() async {
    await Future.delayed(const Duration(seconds: 3));

    return true;
  }
}
