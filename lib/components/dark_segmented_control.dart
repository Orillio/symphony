import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:symphony/screens/navigation_pages/search_screen.dart';


class DarkSegmentedControl extends StatefulWidget {
  final Map<int, Widget> children;
  final double width;

  const DarkSegmentedControl({
    required this.children,
    required this.width,
    Key? key,
  }) : super(key: key);

  @override
  State<DarkSegmentedControl> createState() => _DarkSegmentedControlState();
}

class _DarkSegmentedControlState extends State<DarkSegmentedControl> {
  int? currentIndex;

  @override
  Widget build(BuildContext context) {
    var model = context.watch<SearchScreenModel>();

    return CustomSlidingSegmentedControl<int>(
      initialValue: model.tabIndex,
      fixedWidth: widget.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color(0xFF2e2f32),
      ),
      thumbDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Get.theme.primaryColorDark,
      ),
      duration: const Duration(milliseconds: 300),
      onValueChanged: (index) {
        model.tabIndex = index;
      },
      children: widget.children,
    );
  }
}
