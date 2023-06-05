import 'package:flutter/material.dart';

void showSuccessDialog(BuildContext context){
  showDialog(context: context, 
  builder: (BuildContext context){
    return AlertDialog(
      title: const Text("Success!"),
      content: const Text("Changes saved successfully!"),
      actions: [
        ElevatedButton(onPressed: (){}, 
        child: const Text("OK", style: TextStyle(color: Colors.white)
        )
        )],
    );
  });
}