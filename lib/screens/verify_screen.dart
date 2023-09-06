import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:otp_app/screens/success_screen.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

import '../api/resend_service.dart';
import '../api/verify_service.dart';
import '../model/otp_model.dart';
import '../provider/verify_otp_notifier.dart';

class SecondScreen extends StatefulWidget {
  final OtpDataModel otpData;

  const SecondScreen({super.key, required this.otpData});

  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  late VerifyOtpNotifier verifyOtpNotifier;
  bool isResendButtonTappable = false;
  int countdown = 30;
  late Timer timer;
  String enteredOTP = '';
  bool otpMismatch = false;

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
        countdown = 30;
        isResendButtonTappable = false;
      });
      startCountdown();
    } else {
      // Handle error
    }
  }

  Future<void> verifyOtpAndMoveToThirdScreen() async {
    if (verifyOtpNotifier.verifyStatus == VerifyOtpRequestStatus.loading) {
      // You can show a loading indicator here if needed
    } else {
      final otp = enteredOTP; // Use the entered OTP
      final success = await VerifyOtpApiService.verifyOtp(
        otpData: widget.otpData,
        otp: otp,
      );

      if (success) {
        // Navigate to the SuccessScreen when OTP verification is successful
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SuccessScreen()),
        );
      } else {
        otpMismatch = true;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      size: 28,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Image.asset(
                    'image/blinkXLogoLight.png',
                    width: 125,
                    height: 125,
                  ),
                ],
              ),
              const SizedBox(height: 60),

              const Center(
                child: Text(
                  'Verify Mobile',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: Text(
                  'Enter the OTP sent on ${widget.otpData.mobileNumber}',
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 40),

              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    PinCodeTextField(
                      appContext: context,
                      length: 6, // Number of OTP digits
                      keyboardType: TextInputType.number,
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(20),
                        fieldHeight: 55,
                        fieldWidth: 55,
                        inactiveColor: Colors.black,
                        activeColor: Colors.blue,
                      ),
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter
                            .digitsOnly, // Allow only digits
                      ],
                      onChanged: (pin) {
                        // Update the entered OTP
                        enteredOTP = pin;
                      },
                      onCompleted: (pin) {
                        // Handle OTP input completion
                        verifyOtpAndMoveToThirdScreen();
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Error message text (wrapped in a Visibility widget)
              Center(
                child: Visibility(
                  visible:
                      otpMismatch, // Show the text only if OTPmismatch is true
                  child: Builder(
                    builder: (BuildContext context) {
                      if (otpMismatch) {
                        WidgetsBinding.instance!.addPostFrameCallback((_) {
                          // Trigger an immediate rebuild of the widget tree
                          setState(() {});
                        });
                      }
                      return const Text(
                        'OTP entered does not match with generated OTP.',
                        style: TextStyle(
                          color: Colors.red, // Set text color to red for errors
                          fontSize: 16,
                        ),
                      );
                    },
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          if (isResendButtonTappable) {
                            resendOtp();
                          }
                        },
                        child: Text(
                          isResendButtonTappable
                              ? 'Resend OTP'
                              : 'Resend OTP in ${countdown}s',
                          style: TextStyle(
                            fontSize: 16,
                            color: isResendButtonTappable
                                ? Colors.blue
                                : Colors.black,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: verifyOtpAndMoveToThirdScreen,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 15,
                          horizontal: 20,
                        ),
                        child: const Center(
                          child: Text(
                            'Verify OTP',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
