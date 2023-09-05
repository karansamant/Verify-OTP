import 'package:flutter/cupertino.dart';

import '../api/resend_service.dart';
import '../api/verify_service.dart';
import '../model/otp_model.dart';

class VerifyOtpNotifier extends ChangeNotifier {
  VerifyOtpRequestStatus verifyStatus = VerifyOtpRequestStatus.initial;
  ResendOtpRequestStatus resendStatus = ResendOtpRequestStatus.initial;
  final otpController = TextEditingController();

  Future<void> verifyOtp({required OtpDataModel otpData}) async {
    verifyStatus = VerifyOtpRequestStatus.loading;
    notifyListeners();

    try {
      await VerifyOtpApiService.verifyOtp(
          otpData: otpData, otp: otpController.text);
      verifyStatus = VerifyOtpRequestStatus.success;
    } catch (e) {
      print("Verify OTP API Error: $e");
      verifyStatus = VerifyOtpRequestStatus.error;
    }

    notifyListeners();
  }

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
