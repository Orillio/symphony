import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DarkSegmentedControl extends StatefulWidget {
  final Map<int, Widget> children;
  final Function(dynamic) onValueChanged;

  const DarkSegmentedControl({
    required this.children,
    required this.onValueChanged,
    Key? key,
  }) : super(key: key);

  @override
  State<DarkSegmentedControl> createState() => _DarkSegmentedControlState();
}

class _DarkSegmentedControlState extends State<DarkSegmentedControl> {
  int? currentIndex;

  @override
  Widget build(BuildContext context) {
    return CustomSlidingSegmentedControl<int>(
      isStretch: true,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color(0xFF2e2f32),
      ),
      thumbDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color(0xFF47474c),
      ),
      duration: Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      onValueChanged: (index) {
        setState(() {
          currentIndex = index;
        });
      },
      children: widget.children,

    );
  }
}
