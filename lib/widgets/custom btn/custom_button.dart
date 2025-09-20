import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({super.key, this.btnTitleWidget, required this.onTap, this.btnTitle});
  final Widget? btnTitleWidget;
  final String? btnTitle;
  final void Function() onTap;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        var mqSize = Size(constraints.maxWidth, constraints.maxHeight);
        return InkWell(
          onTap: onTap,
          child: Container(
            width: mqSize.width * 0.9,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: (btnTitleWidget!=null)?btnTitleWidget:Text(
              btnTitle!,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }
}
