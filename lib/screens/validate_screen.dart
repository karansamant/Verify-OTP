import 'package:flutter/material.dart';
import 'package:otp_app/screens/verify_screen.dart';
import 'package:provider/provider.dart';

import '../provider/send_otp_notifier.dart';

class FirstScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final sendOtpNotifier = Provider.of<SendOtpNotifier>(context);

    void navigateToSecondScreen() async {
      final otpData = await sendOtpNotifier.sendOtpRequest();
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

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
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
                    // Implement back navigation here
                  },
                ),
                Image.asset(
                  'image/blinkXLogoLight.png',
                  width: 125,
                  height: 125,
                ),
              ],
            ),
            const SizedBox(height: 80),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      'Hi,',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Text(
                      sendOtpNotifier.mobileNumber,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  const Center(
                    child: Text(
                      'Please confirm your contact number to open your Demat account with BlinkX',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: GestureDetector(
                onTap: navigateToSecondScreen,
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
                      'Send OTP',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
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
    );
  }
}
