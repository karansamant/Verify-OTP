import 'dart:async';

import 'package:flutter/material.dart';
import 'package:otp_app/screens/success_screen.dart';
import 'package:provider/provider.dart';

import '../api/resend_service.dart';
import '../api/verify_service.dart';
import '../model/otp_model.dart';
import '../provider/verify_otp_notifier.dart';

class SecondScreen extends StatefulWidget {
  final OtpDataModel otpData;

  SecondScreen({required this.otpData});

  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  late VerifyOtpNotifier verifyOtpNotifier;
  bool isResendButtonTappable = false;
  int countdown = 60;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    verifyOtpNotifier = Provider.of<VerifyOtpNotifier>(context, listen: false);
    startCountdown();
  }

  void startCountdown() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (countdown == 0) {
        setState(() {
          isResendButtonTappable = true;
          timer.cancel();
        });
      } else {
        setState(() {
          countdown--;
        });
      }
    });
  }

  Future<void> resendOtp() async {
    await verifyOtpNotifier.resendOtp(otpData: widget.otpData);
    if (verifyOtpNotifier.resendStatus == ResendOtpRequestStatus.success) {
      setState(() {
        countdown = 60;
        isResendButtonTappable = false;
      });
      startCountdown();
    } else {
      // Handle error
    }
  }

  Future<void> verifyOtpAndMoveToThirdScreen() async {
    await verifyOtpNotifier.verifyOtp(otpData: widget.otpData);
    if (verifyOtpNotifier.verifyStatus == VerifyOtpRequestStatus.success) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SuccessScreen()),
      );
    } else {
      // Handle error
    }
  }

  @override
  void dispose() {
    timer.cancel(); // Cancel the timer to prevent memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OTP App - Screen 2'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: verifyOtpNotifier.otpController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Enter OTP',
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: verifyOtpAndMoveToThirdScreen,
                child: Text('Verify OTP and Proceed'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: isResendButtonTappable ? resendOtp : null,
                child: Text(
                  isResendButtonTappable
                      ? 'Resend OTP'
                      : 'Resend OTP ($countdown s)',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
