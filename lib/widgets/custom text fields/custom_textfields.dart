import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sneak_peak/utils/constants_colors.dart';

class CustomTextfields extends StatefulWidget {
  CustomTextfields({
    super.key,
    required this.controller,
    required this.title,
    this.prefix,
    required this.focusNode,
    required this.isObscure,
    required this.validator,
    this.maxLine = 1,
    this.minLine = 1,
    this.keyboardType = TextInputType.name,
    this.onChanged,
  });

  final TextEditingController controller;
  final String title;
  IconData? prefix;
  final FocusNode focusNode;
  bool isObscure;
  int? maxLine;
  int? minLine;
  final String? Function(String?)? validator;
  TextInputType? keyboardType;
  void Function(String v)? onChanged;
  @override
  State<CustomTextfields> createState() => _CustomTextfieldsState();
}

class _CustomTextfieldsState extends State<CustomTextfields> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        var mqSize = Size(constraints.maxWidth, constraints.maxHeight);
        return SizedBox(
          width: mqSize.width * 0.9,
          child: TextFormField(
            keyboardType: widget.keyboardType,
            minLines: widget.minLine,
            maxLines: widget.maxLine,
            validator: widget.validator,
            style: TextStyle(color: appGreyColor),
            controller: widget.controller,
            onChanged: widget.onChanged,
            obscureText: widget.isObscure,
            decoration: InputDecoration(
              suffixIcon:
                  (widget.title == 'Password' ||
                          widget.title == 'Confirm password' ||
                          widget.title == 'Enter your password' ||
                          widget.title == 'New password' ||
                          widget.title == 'Old password' ||
                          widget.title == 'Create Password')
                      ? (widget.isObscure)
                          ? IconButton(
                            onPressed: () {
                              setState(() {
                                widget.isObscure = false;
                              });
                            },
                            icon: Icon(CupertinoIcons.eye, color: appGreyColor),
                          )
                          : IconButton(
                            onPressed: () {
                              setState(() {
                                widget.isObscure = true;
                              });
                            },
                            icon: Icon(
                              CupertinoIcons.eye_slash,
                              color: appGreyColor,
                            ),
                          )
                      : null,
              hintText: widget.title,
              prefixIcon:
                  (widget.prefix == null)
                      ? null
                      : Icon(widget.prefix, color: appGreyColor),
              filled: true,
              hintStyle: TextStyle(color: Colors.grey.withAlpha(250)),
              fillColor: Colors.grey.withAlpha(50),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: appGreyColor, width: 1),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: appGreyColor, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.orange, width: 2),
              ),
            ),
          ),
        );
      },
    );
  }
}
