import 'package:flutter/material.dart';
import 'package:sneak_peak/utils/constants_colors.dart';

class CustomDropDownMenu extends StatelessWidget {
  const CustomDropDownMenu({
    super.key,
    this.items,
    required this.title,
    required this.onChanged,
    this.value,
  });

  final List<DropdownMenuItem<String>>? items;
  final String title;
  final void Function(String? value)? onChanged;
  final String? value;
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      validator: (value) {
        if (value == null) {
          return 'Field should not be empty';
        }
        return null;
      },
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.directions_walk, color: appGreyColor),
        filled: true,
        fillColor: Colors.grey.withAlpha(50),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: appGreyColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: appGreyColor),
        ),
      ),
      hint: Text(title),

      items: items,

      onChanged: onChanged,
    );
  }
}
/*

 */