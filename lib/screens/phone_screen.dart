import 'package:areamen/screens/otp_screen.dart';
import 'package:areamen/utils/auth_methods.dart';
import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PhoneScreen extends StatefulWidget {
  PhoneScreen({Key? key}) : super(key: key);
  static String verificationcode = '';

  @override
  State<PhoneScreen> createState() => _PhoneScreenState();
}

class _PhoneScreenState extends State<PhoneScreen> {
  String _countrycode = '';
  TextEditingController _PhoneControler = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 300,
                  child: Image.asset('images/login_page.png'),
                ),
                Text('AreaMen will need to verify your phone number.'),
                SizedBox(
                  height: size.height / 13.6,
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      _countrycode == null
                          ? TextButton(
                              onPressed: () {
                                showCountryPicker(
                                    context: context,
                                    onSelect: (Country val) {
                                      setState(() {
                                        _countrycode = val.phoneCode;
                                      });
                                    });
                              },
                              child: Text('+' + _countrycode),
                            )
                          : TextButton(
                              onPressed: () {
                                showCountryPicker(
                                    context: context,
                                    onSelect: (Country val) {
                                      setState(() {
                                        _countrycode = val.phoneCode;
                                      });
                                    });
                              },
                              child: Text('+'+ _countrycode)),
                      SizedBox(
                        width: size.width - size.width / 2.5,
                        child: TextField(
                          controller: _PhoneControler,
                          decoration: InputDecoration(
                            hintText: 'Enter Phone Number',
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedErrorBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: size.height / 13.6,
                ),
                GestureDetector(
                  onTap: () async {
                    if (_countrycode.isNotEmpty &&
                        _PhoneControler.text.trim().isNotEmpty &&
                        _PhoneControler.text.length == 10) {
                      await AuthMethods().signInWithPhone(
                          '+${_countrycode + _PhoneControler.text}', () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                              builder: (context) => OTPScreen(
                                    phoneNumber: _PhoneControler.text,
                                  )),
                        );
                      });
                    } else {
                      //
                    }
                  },
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.circular(10)),
                    margin: const EdgeInsets.all(20),
                    child: const Center(
                      child: Text('CONTINUE'),
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
