import 'package:flutter/material.dart';
import 'package:timetablr/core/constants.dart';

appbar({required String title}) {
  return AppBar(
    title: Text(
      title,
      style: TextStyle(
        color: Colors.white,
        fontSize: 28,
        fontWeight: FontWeight.bold,
        fontFamily: 'popins',
        fontStyle: FontStyle.normal,
      ),
    ),
    centerTitle: true,
    backgroundColor: Color(0xFF14252C),
    elevation: 0,
    bottom: PreferredSize(
      child: kheight20,
      preferredSize: Size(double.infinity, 20),
    ),
  );
}
