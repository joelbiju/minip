import 'package:flutter/material.dart';

class TextFieldWithHeading extends StatelessWidget {
  const TextFieldWithHeading(
      {super.key,
      required this.heading,
      required this.hintText,
      required this.controller,
      required this.hourHint,
      required this.courseCodeHint,
      required this.codeController,
      required this.hourController});
  final String heading;
  final String courseCodeHint;
  final String hintText;
  final String hourHint;
  final TextEditingController codeController;
  final TextEditingController controller;
  final TextEditingController hourController;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 18,
        ),
        Text(
          heading,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.normal,
            fontFamily: 'popins',
            fontStyle: FontStyle.normal,
          ),
        ),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: TextField(
                maxLength: 6,
                style: const TextStyle(color: Colors.white),
                textCapitalization: TextCapitalization.characters,
                controller: codeController,
                decoration: InputDecoration(
                  counterText: '',
                  hintText: courseCodeHint,
                  hintStyle: TextStyle(
                      color: Colors.white.withOpacity(0.3),
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              flex: 2,
              child: TextField(
                maxLength: 2,
                keyboardType: TextInputType.number,
                style: TextStyle(color: Colors.white),
                controller: hourController,
                decoration: InputDecoration(
                  counterText: '',
                  hintText: hourHint,
                  hintStyle: TextStyle(
                      color: Colors.white.withOpacity(0.3),
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
              ),
            ),
          ],
        ),
        TextField(
          style: TextStyle(color: Colors.white),
          controller: controller,
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
                color: Colors.white.withOpacity(0.3),
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
          ),
        ),
      ],
    );
  }
}
