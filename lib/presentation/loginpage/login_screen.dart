import 'package:flutter/material.dart';
import 'package:timetablr/core/constants.dart';
import 'package:timetablr/domain/login/auth_service.dart';
import 'package:timetablr/presentation/common/loading.dart';
import 'package:timetablr/presentation/homepage/homesc.dart';
import 'package:timetablr/presentation/loginpage/signup_screen.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLoading = false;
  bool obscureText = true;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Welcome back!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.0,
                      fontFamily: 'popins',
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 32.0),
                  TextFormField(
                    controller: emailController,
                    style: TextStyle(color: Colors.white),
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'email',
                      labelStyle: TextStyle(color: Colors.white),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                  ),
                  kheight20,
                  TextFormField(
                    controller: passwordController,
                    obscureText: obscureText,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(color: Colors.white),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Show Password',
                          style: TextStyle(color: Colors.white)),
                      Switch(
                        value: !obscureText,
                        onChanged: (value) {
                          setState(() {
                            obscureText = !value;
                          });
                        },
                      ),
                    ],
                  ),
                  kheight10,
                  ElevatedButton(
                    onPressed: () async {
                      FocusScope.of(context).unfocus();
                      setState(() {
                        isLoading = true;
                      });
                      final response = await AuthService().loginUser(
                        emailController.text.trim(),
                        passwordController.text.trim(),
                      );
                      setState(() {
                        isLoading = false;
                      });
                      response.fold(
                          (errorMessage) => ScaffoldMessenger.of(context)
                              .showSnackBar(
                                  SnackBar(content: Text(errorMessage))),
                          (r) => Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => HomeScreen(),
                              ),
                              (route) => false));
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Color(0xFF1DC192)),
                    ),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Text('Login', style: TextStyle(fontSize: 18.0)),
                    ),
                  ),
                  kheight10,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Don\'t have an account?',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontFamily: 'popins',
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      kwidth10,
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context)
                              .pushReplacement(MaterialPageRoute(
                            builder: (context) => SignupPage(),
                          ));
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Color(0xFF1DC192)),
                        ),
                        child: Text('Signup', style: TextStyle(fontSize: 16.0)),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: LoadingWidget(),
              ),
            ),
        ],
      ),
    );
  }
}
