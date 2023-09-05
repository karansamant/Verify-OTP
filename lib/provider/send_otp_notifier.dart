import 'package:flutter/cupertino.dart';
import 'package:otp_app/model/otp_model.dart';

import '../api/validate_service.dart';

enum SendOtpRequestStatus { initial, loading, success, error }

class SendOtpNotifier extends ChangeNotifier {
  SendOtpRequestStatus status = SendOtpRequestStatus.initial;
  final mobileNumberController = TextEditingController();

  Future<OtpDataModel?> sendOtpRequest() async {
    status = SendOtpRequestStatus.loading;
    notifyListeners();

    try {
      final response =
          await VerifyService.sendOtpRequest(mobileNumberController.text);

      if (response != null) {
        final requestToken = response['requestToken'] as String?;
        if (requestToken != null) {
          status = SendOtpRequestStatus.success;
          notifyListeners();
          return OtpDataModel(
            mobileNumber: mobileNumberController.text,
            requestToken: requestToken,
          );
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
