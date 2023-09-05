import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/otp_model.dart';

enum ResendOtpRequestStatus { initial, loading, success, error }

class ResendOtpApiService {
  static const apiUrl = "https://wsdeh.blinkx.in/Middleware/User/ResendOTP";
  static const apiKey = "N0z4s32hyZXSZt1m";

  static Future<void> resendOtp({required OtpDataModel otpData}) async {
    ResendOtpRequestStatus resendStatus = ResendOtpRequestStatus.initial;

    try {
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
        resendStatus = ResendOtpRequestStatus.success;
      } else {
        print("Resend OTP API Error: ${response.statusCode}");
        resendStatus = ResendOtpRequestStatus.error;
      }
    } catch (e) {
      print("Resend OTP API Error: $e");
      resendStatus = ResendOtpRequestStatus.error;
    }
  }
}
