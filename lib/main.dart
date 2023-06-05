import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:timetablr/core/colors.dart';
import 'package:timetablr/presentation/homepage/homesc.dart';
import 'package:timetablr/presentation/loginpage/login_screen.dart';
import 'package:timetablr/presentation/splashScreen/splashscreen.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Color(0xFF14252C),
        scaffoldBackgroundColor: primaryColor,
      ),
      home: SplashScreen(),
    );
  }
}
