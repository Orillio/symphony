import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ActionButton extends StatefulWidget {
  Color? color;
  double? width = 100;
  final Widget text;

  ActionButton({this.width, this.color, required this.text, Key? key}) : super(key: key);

  @override
  State<ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<ActionButton> {
  @override
  Widget build(BuildContext context) {
    widget.color ??= Get.theme.primaryColor;
    return AnimatedContainer(
      width: widget.width,
      height: 45,
      duration: const Duration(milliseconds: 250),
      child: GestureDetector(
        onTapDown: (details) {
          setState(() {
            widget.color = const Color(0xFF0550A1);
          });
        },
        onTapUp: (details) {
          setState(() {
            widget.color = Get.theme.primaryColor;
          });
          FocusScope.of(context).unfocus();
        },
        child: Center(
          child: AnimatedDefaultTextStyle(
            maxLines: 1,
            style: TextStyle(
                color: widget.color,
                fontSize: 16
            ),
            duration: const Duration(milliseconds: 150),
            child: widget.text,
          ),
        ),
      ),
    );
  }
}
