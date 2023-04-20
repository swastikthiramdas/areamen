import 'dart:async';

import 'package:areamen/provider/user_provider.dart';
import 'package:areamen/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {


  @override
  void initState() {
    super.initState();
    addData();
  }

  void addData() async {

    var prefs = await SharedPreferences.getInstance();
    bool? worker = await prefs.getBool('isWorker');
    /**/
      UserProvider _userProvider = Provider.of(context , listen: false);
      await _userProvider.refreshUser();


    Naviget();
    print(worker);
  }
  void Naviget(){
   Timer(Duration(milliseconds: 4), () {
     Navigator.of(context).pushReplacement(MaterialPageRoute(builder: ((context) => HomeScreen())));
   });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('hello world'),
      ),
    );
  }
}
