// first_screen.dart
import 'package:flutter/material.dart';
import 'package:otp_app/screens/verify_screen.dart';

import '../api/validate_service.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  final mobileNumberController = TextEditingController();

  void navigateToSecondScreen() async {
    final otpData = await sendOtpRequest(mobileNumberController.text);
    if (otpData != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SecondScreen(otpData: otpData),
        ),
      );
    } else {
      // Handle API error
    }
  }

  @override
  Widget build(BuildContext context) {
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
                controller: mobileNumberController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Enter Mobile Number',
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: navigateToSecondScreen,
                child: const Text('Send OTP'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
