import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;

import '../model/otp_model.dart';

class VerifyOtpApiService {
  static const apiUrl = "https://wsdeh.blinkx.in/Middleware/User/VerifyOTP";
  static const apiKey = "N0z4s32hyZXSZt1m";
  static const hashKey = 'm4tJ9zuX3hau7k6LBJ4Nn6PFZO69uiiN';

  static Future<bool> verifyOtp({
    required OtpDataModel otpData,
    required String otp,
  }) async {
    try {
      final input = "${otpData.requestToken}:$hashKey";
      final hash = md5.convert(utf8.encode(input)).toString();

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
            "otp": otp,
            "checkSum": hash,
          },
        }),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final status = jsonResponse['status'];

        if (status == 'success') {
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      print("Verify OTP API Error: $e");
      return false;
    }
  }
}
