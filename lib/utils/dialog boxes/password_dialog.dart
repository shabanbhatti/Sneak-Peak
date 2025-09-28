import 'package:flutter/material.dart';
import 'package:sneak_peak/widgets/custom%20text%20fields/custom_textfields.dart';

Future<void> showPasswordDialog(
  BuildContext context,
  TextEditingController passwordController,
  void Function() onTap,
) {
  return showDialog<String>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Enter Password'),
        content: CustomTextfieldForDialogBox(
          controller: passwordController,
          title: 'Enter your password',
          focusNode: FocusNode(),
          isObscure: true,
          validator: (p0) => '',
        ),
        // content: TextField(
        //   controller: passwordController,
        //   obscureText: true,
        //   decoration: InputDecoration(
        //     labelText: 'Password',
        //     border: OutlineInputBorder(),
        //   ),
        // ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(null);
            },
            child: Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            onPressed: onTap,
            child: const Text('Submit', style: TextStyle(color: Colors.white)),
          ),
        ],
      );
    },
  );
}
