import 'package:flutter/material.dart';
import 'package:otp_app/provider/send_otp_notifier.dart';
import 'package:otp_app/provider/verify_otp_notifier.dart';
import 'package:otp_app/screens/validate_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SendOtpNotifier()),
        ChangeNotifierProvider(create: (context) => VerifyOtpNotifier()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'OTP App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: FirstScreen(),
      ),
    );
  }
}
