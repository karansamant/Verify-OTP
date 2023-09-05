import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/otp_model.dart';

Future<OtpData?> sendOtpRequest(String mobileNumber) async {
  const apiUrl = "https://wsdeh.blinkx.in/Middleware/User/ValidateMobile";
  const apiKey = "N0z4s32hyZXSZt1m";

  final response = await http.post(
    Uri.parse(apiUrl),
    headers: {
      "Content-Type": "application/json",
    },
    body: jsonEncode({
      "data": {"apiKey": apiKey, "mobileNumber": mobileNumber},
      "appID": "",
      "msgID": "",
    }),
  );

  if (response.statusCode == 200) {
    final jsonResponse = json.decode(response.body);
    if (jsonResponse != null &&
        jsonResponse is Map<String, dynamic> &&
        jsonResponse['data'] != null) {
      return OtpData(
        mobileNumber: mobileNumber, // Include the user-entered mobile number
        requestToken: jsonResponse['data']['requestToken'] as String,
      );
    } else {
      print("API response does not contain the expected data structure.");
      return null;
    }
  } else {
    // Handle API error here
    print("API Error: ${response.statusCode}");
    return null;
  }
}
