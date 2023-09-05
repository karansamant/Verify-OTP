class OtpData {
  final String mobileNumber;
  final String requestToken;

  OtpData({required this.mobileNumber, required this.requestToken});

  factory OtpData.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>?;

    if (data != null) {
      final requestToken = data['requestToken'] as String?;

      if (requestToken != null) {
        return OtpData(
          mobileNumber: '', // Placeholder for user-entered mobile number
          requestToken: requestToken,
        );
      }
    }

    throw FormatException("Invalid JSON structure or missing data");
  }
}
