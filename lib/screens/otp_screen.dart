import 'package:areamen/main.dart';
import 'package:areamen/screens/cat_select_Screen.dart';
import 'package:areamen/screens/phone_screen.dart';
import 'package:areamen/utils/auth_methods.dart';
import 'package:flutter/material.dart';

class OTPScreen extends StatelessWidget {
  final phoneNumber;

  OTPScreen({Key? key, required this.phoneNumber}) : super(key: key);
  TextEditingController _otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text('Enter OTP to verify'),
          SizedBox(height: size.height / 13.6),
          Center(
            child: SizedBox(
              width: size.width - (size.width / 19.45),
              child: TextField(
                controller: _otpController,
                decoration: InputDecoration(
                  hintText: 'Enter OTP',
                ),
                keyboardType: TextInputType.number,
              ),
            ),
          ),
          SizedBox(
            height: size.height / 13.6,
          ),
          GestureDetector(
            onTap: () {
              if (_otpController.text.trim().isNotEmpty) {
                AuthMethods().VerifyPhoneNumber(
                    PhoneScreen.verificationcode, _otpController.text, () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                        builder: (context) =>
                            SelectCatScreen(phoneNumber: phoneNumber)),
                  );
                });
              } else if (_otpController.text.trim().length < 6) {
                //  Enter 6 digit OTP
              } else {
                //  Enter OTP
              }
            },
            child: Container(
              height: 30,
              decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(10)),
              margin: const EdgeInsets.all(20),
              child: const Center(
                child: Text('VERIFY'),
              ),
            ),
          )
        ],
      ),
    );
  }
}
