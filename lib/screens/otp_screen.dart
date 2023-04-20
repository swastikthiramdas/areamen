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
      body: Center(
        child: SingleChildScrollView(
          child: SizedBox(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 300,
                  child: Image.asset("images/otp_page.png"),
                ),
                const Text('Enter OTP to verify'),
                SizedBox(height: size.height / 13.6),
                Center(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    width: size.width - (size.width / 19.45),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: TextField(
                      maxLength: 6,
                      textAlign: TextAlign.center,
                      controller: _otpController,
                      decoration: const InputDecoration(
                        labelStyle: TextStyle(fontSize: 18),
                        hintText: 'Enter OTP',
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedErrorBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
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
                    height: 50,
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
          ),
        ),
      ),
    );
  }
}
