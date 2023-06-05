import 'package:flutter/material.dart';

class EvenOdd extends StatelessWidget {
  EvenOdd({
    Key? key,
    required this.colorbox,
    required this.textData,
    required this.pressed,
    this.width = 100,
    this.height = 50,
    this.borderRadius = 08,
  }) : super(key: key);

  final Text textData;
  final Color colorbox;
  final VoidCallback pressed;

  final double width;
  final double height;
  final double borderRadius;

  final textStyle = const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    fontFamily: 'popins',
    fontStyle: FontStyle.normal,
  );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: pressed,
        child: textData,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(colorbox),
          textStyle: MaterialStateProperty.all(textStyle),
        ),
      ),
    );
  }
}
