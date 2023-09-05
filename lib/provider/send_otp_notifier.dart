import 'package:flutter/foundation.dart';
import 'package:otp_app/model/otp_model.dart';

import '../api/validate_service.dart';

enum SendOtpRequestStatus { initial, loading, success, error }

class SendOtpNotifier extends ChangeNotifier {
  SendOtpRequestStatus status = SendOtpRequestStatus.initial;
  final String mobileNumber = "9568269319"; // Hardcoded mobile number
  late OtpDataModel otpData = OtpDataModel(
    mobileNumber:
        mobileNumber, // Initialize otpData with the hardcoded mobile number
    requestToken: "",
  );

  Future<OtpDataModel?> sendOtpRequest() async {
    status = SendOtpRequestStatus.loading;
    notifyListeners();

    try {
      final response = await ValidateService.sendOtpRequest(mobileNumber);

      if (response != null) {
        final requestToken = response['requestToken'] as String?;
        if (requestToken != null) {
          status = SendOtpRequestStatus.success;
          otpData = OtpDataModel(
            mobileNumber: mobileNumber,
            requestToken: requestToken,
          );
          notifyListeners();
          return otpData;
        }
      }
    } catch (e) {
      print("API Error: $e");
    }

    status = SendOtpRequestStatus.error;
    notifyListeners();
    return null;
  }
}
