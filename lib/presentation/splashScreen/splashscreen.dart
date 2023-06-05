import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timetablr/core/constants.dart';
import 'package:timetablr/domain/class/department_repo.dart';
import 'package:timetablr/domain/login/model/user_model.dart';
import 'package:timetablr/domain/timetable/timetable.dart';
import 'package:timetablr/presentation/common/loading.dart';
import 'package:timetablr/presentation/homepage/homesc.dart';
import 'package:timetablr/presentation/loginpage/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  _splashTimeCheck() async {
    final sharedpref = await SharedPreferences.getInstance();
    final user = sharedpref.getString(userSharedPreferencesKey);
    await Future.delayed(const Duration(milliseconds: 500));
    if (user == null) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
    } else {
      UserModel.fromJson(user);
      await DepartmentRepo.instance.getDepartments();
      await TimetableRepo.instance.retrieveTimetable();
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
    }
  }

  @override
  void initState() {
    _splashTimeCheck();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'TIMETABLR',
          style: TextStyle(
              fontSize: 50, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }
}
