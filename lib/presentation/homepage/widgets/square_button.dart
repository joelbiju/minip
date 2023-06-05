import 'package:flutter/material.dart';

class SquareButton extends StatelessWidget {
  const SquareButton({
    Key? key,
    required this.iconData,
    required this.press,
    this.width = 78,
    this.height = 60,
    this.borderRadius = 08,
    required this.name,
  }) : super(key: key);

  final IconData iconData;
  final VoidCallback press;
  final double width;
  final double height;
  final double borderRadius;
  final String name;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: press,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              iconData,
              color: Colors.white,
              size: 25,
            ),
            Text(
              name.toUpperCase(),
              style: TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.bold,
                fontFamily: 'popins',
                fontStyle: FontStyle.normal,
              ),
            )
          ],
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF405768),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
      ),
    );
  }
}
