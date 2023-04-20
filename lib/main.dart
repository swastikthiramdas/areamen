import 'package:areamen/provider/user_provider.dart';
import 'package:areamen/screens/home_screen.dart';
import 'package:areamen/screens/main_screen.dart';
import 'package:areamen/screens/phone_screen.dart';
import 'package:areamen/screens/splash_screen.dart';
import 'package:areamen/screens/worker_details.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),

      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Area Men',
        theme: ThemeData(
          fontFamily: GoogleFonts
              .poppins()
              .fontFamily,
        ),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                return SplashScreen();
              } else if (snapshot.hasError) {
                return const Center(
                  child: Text('Something went wrong'),
                );
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.blueAccent,
                  ),
                );
              }
            }
            return PhoneScreen();
          },
        ),
      ),
    );
  }
}