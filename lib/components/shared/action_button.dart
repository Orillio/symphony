import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ActionButton extends StatefulWidget {
  final Color? color;
  final double? width;
  final Widget text;

  const ActionButton(
      {this.width = 100, this.color, required this.text, Key? key})
      : super(key: key);

  @override
  State<ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<ActionButton> {
  Color? _color;
  double? _width;

  @override
  void initState() {
    super.initState();
    _color = widget.color;
    _width = widget.width;
  }

  @override
  Widget build(BuildContext context) {
    _color ??= Get.theme.primaryColor;
    return AnimatedContainer(
      width: _width,
      height: 45,
      duration: const Duration(milliseconds: 250),
      child: GestureDetector(
        onTapDown: (details) {
          setState(() {
            _color = const Color(0xFF0550A1);
          });
        },
        onTapUp: (details) {
          setState(() {
            _color = Get.theme.primaryColor;
          });
          FocusScope.of(context).unfocus();
        },
        child: Center(
          child: AnimatedDefaultTextStyle(
            maxLines: 1,
            style: TextStyle(color: _color, fontSize: 16),
            duration: const Duration(milliseconds: 150),
            child: widget.text,
          ),
        ),
      ),
    );
  }
}
