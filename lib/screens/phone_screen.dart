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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('AreaMen will need to verify your phone number.'),
          SizedBox(
            height: size.height / 13.6,
          ),
          Row(
            children: [
              TextButton(
                  onPressed: () {
                    showCountryPicker(
                        context: context,
                        onSelect: (Country val) {
                          setState(() {
                            _countrycode = val.phoneCode;
                          });
                        });
                  },
                  child: Text('+' + _countrycode)),
              SizedBox(
                width: size.width - size.width / 5.22,
                child: TextField(
                  controller: _PhoneControler,
                  decoration: InputDecoration(
                    hintText: 'Enter Phone Number',
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          SizedBox(
            height: size.height / 13.6,
          ),
          GestureDetector(
            onTap: () async {

              if (_countrycode.isNotEmpty && _PhoneControler.text.trim().isNotEmpty && _PhoneControler.text.length == 10) {
                await AuthMethods().signInWithPhone(
                    '+${_countrycode + _PhoneControler.text}', (){

                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => OTPScreen(phoneNumber: _PhoneControler.text,)),
                  );


                });
              }
              else{
              //
              }
            },
            child: Container(
              height: 30,
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
    );
  }
}
