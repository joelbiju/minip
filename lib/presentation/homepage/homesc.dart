import 'package:flutter/material.dart';
import 'package:timetablr/core/colors.dart';
import 'package:timetablr/core/constants.dart';
import 'package:timetablr/domain/algorithm.dart';
import 'package:timetablr/domain/class/department_repo.dart';

import 'package:timetablr/domain/login/auth_service.dart';
import 'package:timetablr/domain/login/model/user_model.dart';
import 'package:timetablr/presentation/class/dept_list.dart';
import 'package:timetablr/presentation/faculty/facprofile.dart';
import 'package:timetablr/presentation/faculty/faculty_list.dart';
import 'package:timetablr/presentation/homepage/widgets/square_button.dart';
import 'package:timetablr/presentation/homepage/widgets/submitbtn.dart';
import 'package:timetablr/presentation/loginpage/login_screen.dart';
import 'package:timetablr/presentation/saved_timetables/saved_timetables_screen.dart';
import 'package:timetablr/presentation/timetable_generate/timetable_generate_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: primaryColor,
        body: SafeArea(
          child: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 40,
                ),
                Container(
                  width: 300,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Color(0xFF212B33),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      kwidth20,
                      Text(
                        'Hey, ',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'popins',
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      Text(
                        ' Admin!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'popins',
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      Spacer(),
                      GestureDetector(
                          onTap: () {
                            //showbottomsheet containing logout button and user details
                            showModalBottomSheet(
                                backgroundColor: Colors.transparent,
                                context: context,
                                builder: (context) => Container(
                                      height: 200,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: Color(0xFF212B33),
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          topRight: Radius.circular(20),
                                        ),
                                      ),
                                      child: Column(
                                        children: [
                                          kheight20,
                                          kheight20,
                                          Text(
                                            UserModel.instance.username,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'popins',
                                              fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                          Text(
                                            UserModel.instance.email,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400,
                                              fontFamily: 'popins',
                                              fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                          kheight20,
                                          kheight20,
                                          kheight10,
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              EvenOdd(
                                                colorbox: Color(0xFF1DC192),
                                                textData: Text('Logout'),
                                                pressed: () async {
                                                  await AuthService().signout();
                                                  Navigator.of(context)
                                                      .pushAndRemoveUntil(
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  LoginPage()),
                                                          (route) => false);
                                                },
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ));
                          },
                          child: Icon(Icons.person,
                              color: Colors.white, size: 35)),
                      kwidth20,
                    ],
                  ),
                ),
                kheight20,
                kheight20,
                Container(
                  height: 130,
                  width: 300,
                  decoration: BoxDecoration(
                    color: Color(0xFF212B33),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          'Datas',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'popins',
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        Divider(
                          color: Colors.grey,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SquareButton(
                              press: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => DeptList(),
                                ));
                              },
                              iconData: Icons.book,
                              name: 'class',
                            ),
                            SquareButton(
                              press: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => FacultyList(),
                                  ),
                                );
                              },
                              iconData: Icons.people,
                              name: 'Faculty',
                            ),
                            SquareButton(
                              press: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => SavedTimetablesScreen(),
                                ));
                              },
                              iconData: Icons.folder,
                              name: 'Saved',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Container(
                  height: 280,
                  width: 300,
                  decoration: BoxDecoration(
                    color: Color(0xFF212B33),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 35),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 30,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Create new!',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.normal,
                              fontFamily: 'popins',
                              fontStyle: FontStyle.normal,
                            ),
                          ),
                        ),
                        Divider(
                          color: Colors.grey,
                        ),
                        kheight20,
                        HomeScreenButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => DeptList(),
                              ));
                            },
                            text: 'Department'),
                        kheight20,
                        HomeScreenButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => FacProfile(),
                                ),
                              );
                            },
                            text: 'Faculty'),
                        kheight20,
                        Transform.translate(
                          offset: Offset(0, 20),
                          child: EvenOdd(
                              pressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        TimeTableGenerateScreen(),
                                  ),
                                );
                              },
                              colorbox: Color(0xFF1DC192),
                              textData: Text('Generate')),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 35,
                ),
              ],
            ),
          ),
        ));
  }
}

class HomeScreenButton extends StatelessWidget {
  const HomeScreenButton(
      {super.key, required this.onPressed, required this.text});
  final VoidCallback onPressed;
  final String text;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Color(0xFF405768)),
          alignment: Alignment.centerLeft,
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        onPressed: onPressed,
        child: Text(text.toUpperCase(),
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontFamily: 'popins',
            )),
      ),
    );
  }
}
