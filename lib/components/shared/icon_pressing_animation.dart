import 'package:flutter/material.dart';

class IconPressingAnimation extends StatefulWidget {
  const IconPressingAnimation({
    Key? key,
    required this.child,
    required this.onPress,
    this.minScale = 0.8,
  }) : super(key: key);

  final Widget child;
  final double minScale;
  final Function() onPress;

  @override
  State<IconPressingAnimation> createState() => _IconPressingAnimationState();
}

class _IconPressingAnimationState extends State<IconPressingAnimation>
    with TickerProviderStateMixin {
  late AnimationController controller;

  final ValueNotifier<bool> _isHolding = ValueNotifier(false);

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      lowerBound: widget.minScale,
      duration: const Duration(milliseconds: 100),
      value: 1,
    );
    controller.addStatusListener(_listener);
    _isHolding.addListener(() {
      if (!_isHolding.value && controller.status == AnimationStatus.dismissed) {
        controller.forward();
      }
    });
  }

  void _listener(AnimationStatus status) async {
    if (status == AnimationStatus.dismissed && !_isHolding.value) {
      await controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        widget.onPress();
      },
      onTapDown: (details) async {
        _isHolding.value = true;
        await controller.reverse();
      },
      onTapUp: (details) async {
        _isHolding.value = false;
      },
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          return Transform.scale(
            scale: controller.value,
            child: widget.child,
          );
        },
      ),
    );
  }
}
