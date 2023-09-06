import 'dart:convert';

import 'package:http/http.dart' as http;

class ValidateService {
  static const apiUrl =
      "https://wsdeh.blinkx.in/Middleware/User/ValidateMobile";
  static const apiKey = "N0z4s32hyZXSZt1m";

  static Future<Map<String, dynamic>?> sendOtpRequest(
      String mobileNumber) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "data": {
            "apiKey": apiKey,
            "mobileNumber": mobileNumber,
          },
          "appID": "",
          "msgID": "",
        }),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        if (jsonResponse != null &&
            jsonResponse is Map<String, dynamic> &&
            jsonResponse['data'] != null) {
          return jsonResponse['data'] as Map<String, dynamic>;
        } else {
          print("API response does not contain the expected data structure.");
        }
      } else {
        print("API Error: ${response.statusCode}");
      }
    } catch (e) {
      print("API Error: $e");
    }

    return null;
  }
}
