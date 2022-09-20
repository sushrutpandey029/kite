import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CustomDialogue extends StatelessWidget {
   CustomDialogue({Key? key, required this.message}) : super(key: key);

  String message;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.sp)
        ),        content: Text(message),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          ElevatedButton(onPressed: (){
            Navigator.pop(context);
          }, child: const Text('OK'))
        ],
      ) ;
  }
}