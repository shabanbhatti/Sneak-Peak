import 'package:flutter/material.dart';
import 'package:sneak_peak/widgets/custom%20text%20fields/custom_textfields.dart';

class TextFieldAddressWidget extends StatelessWidget {
  const TextFieldAddressWidget({
    super.key,
    required this.controller,
    required this.inputTitle,
    this.keyboardType,
    required this.title,
  });

  final String title;
  final String inputTitle;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 7),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 2),
            child: Row(
              children: [
                Text(
                  inputTitle,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const Text(
                  '*',
                  style: TextStyle(
                    color: Colors.orange,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 60,
            child: CustomTextfields(
              controller: controller,
              title: title,
              focusNode: FocusNode(),
              isObscure: false,
              validator: (p0) => '',
              keyboardType: keyboardType,
            ),
          ),
        ],
      ),
    );
  }
}
