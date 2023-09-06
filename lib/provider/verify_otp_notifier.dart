import 'package:flutter/cupertino.dart';

import '../api/resend_service.dart';
import '../model/otp_model.dart';

enum VerifyOtpRequestStatus { initial, loading, success, error }

class VerifyOtpNotifier extends ChangeNotifier {
  VerifyOtpRequestStatus verifyStatus = VerifyOtpRequestStatus.initial;
  ResendOtpRequestStatus resendStatus = ResendOtpRequestStatus.initial;
  final otpController = TextEditingController();

  Future<void> resendOtp({required OtpDataModel otpData}) async {
    resendStatus = ResendOtpRequestStatus.loading;
    notifyListeners();

    try {
      await ResendOtpApiService.resendOtp(otpData: otpData);
      resendStatus = ResendOtpRequestStatus.success;
    } catch (e) {
      print("Resend OTP API Error: $e");
      resendStatus = ResendOtpRequestStatus.error;
    }

    notifyListeners();
  }
}
