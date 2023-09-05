// resend_service.dart
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:otp_app/model/otp_model.dart';

class ResendService {
  static Future<void> resendOtp({
    required OtpData otpData,
    required Function onSuccess,
    required Function onError,
  }) async {
    const apiUrl = "https://wsdeh.blinkx.in/Middleware/User/ResendOTP";
    const apiKey = "N0z4s32hyZXSZt1m";

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "data": {
          "apiKey": apiKey,
          "mobileNumber": otpData.mobileNumber,
          "requestToken": otpData.requestToken,
        },
      }),
    );

    if (response.statusCode == 200) {
      print("Resend OTP API Response: ${response.body}");
      onSuccess();
    } else {
      print("Resend OTP API Error: ${response.statusCode}");
      onError();
    }
  }
}
