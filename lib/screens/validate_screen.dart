import 'package:flutter/material.dart';
import 'package:otp_app/screens/verify_screen.dart';
import 'package:provider/provider.dart';

import '../provider/send_otp_notifier.dart';

class FirstScreen extends StatelessWidget {
  const FirstScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    final sendOtpNotifier = Provider.of<SendOtpNotifier>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('OTP App - Screen 1'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: sendOtpNotifier.mobileNumberController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Enter Mobile Number',
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  final otpData = await sendOtpNotifier.sendOtpRequest();
                  if (otpData != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SecondScreen(otpData: otpData),
                      ),
                    );
                  } else {
                    // Handle error
                  }
                },
                child: Text(
                  sendOtpNotifier.status == SendOtpRequestStatus.loading
                      ? 'Sending OTP...'
                      : 'Send OTP',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
