import 'package:easy_autocomplete/easy_autocomplete.dart';
import 'package:flutter/material.dart';

class TextFirldWithSuggestion extends StatelessWidget {
  const TextFirldWithSuggestion(
      {super.key, required this.suggestions, required this.controller});
  final List<String> suggestions;
  final TextEditingController controller;
  @override
  Widget build(BuildContext context) {
    return EasyAutocomplete(
      suggestionTextStyle: TextStyle(color: Colors.white.withOpacity(0.8)),
      controller: controller,
      inputTextStyle: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
        hintText: 'Course code',
        enabledBorder: UnderlineInputBorder(
            borderSide:
                BorderSide(color: const Color.fromARGB(117, 255, 255, 255))),
      ),
      suggestions: suggestions,
      onChanged: (value) => print('onChanged value: $value'),
      onSubmitted: (value) => print('onSubmitted value: $value'),
    );
  }
}
