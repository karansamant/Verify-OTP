// verify_service.dart
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:otp_app/model/otp_model.dart';

class VerifyService {
  static Future<void> verifyOtp({
    required OtpData otpData,
    required String otp,
    required Function onSuccess,
    required Function onError,
  }) async {
    const apiUrl = "https://wsdeh.blinkx.in/Middleware/User/VerifyOTP";
    const apiKey = "N0z4s32hyZXSZt1m";
    const hashKey = 'm4tJ9zuX3hau7k6LBJ4Nn6PFZO69uiiN';

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
      print("API Response: ${response.body}");
      onSuccess();
    } else {
      print("API Error: ${response.statusCode}");
      onError();
    }
  }
}
