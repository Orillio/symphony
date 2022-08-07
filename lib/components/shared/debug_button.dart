import 'package:flutter/material.dart';

class DebugButton extends StatelessWidget {
  final Function() callback;
  const DebugButton({Key? key, required this.callback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 200,
      left: 150,
      child: TextButton(
        onPressed: callback,
        child: const Text("Click me"),
      ),
    );
  }
}
