import 'package:areamen/screens/main_screen.dart';
import 'package:areamen/screens/ProfileViewScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../provider/user_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _page = 0;
  final Screens = [MainScreen(), ProfileViewScreen()];

  NavigatePage(int index) {
    setState(() {
      _page = index;
    });
  }

  @override
  void initState() {
    super.initState();
    addData();
  }

  addData() async {
    var prefs = await SharedPreferences.getInstance();
    // bool? custommer = await prefs.getBool('isWorker');

    // print("addData Run");

    UserProvider _userProvider = Provider.of(context, listen: false);
    await _userProvider.refreshUser();

    // print(custommer);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Screens[_page],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _page,
        onTap: NavigatePage,
        selectedItemColor: Colors.black87,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
        ],
      ),
    );
  }
}
