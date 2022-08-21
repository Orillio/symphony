import 'package:flutter/material.dart';

class ItemPressingAnimation extends StatefulWidget {
  const ItemPressingAnimation({
    Key? key,
    required this.child,
    required this.onPress,
  }) : super(key: key);

  final Widget child;
  final Function() onPress;

  @override
  State<ItemPressingAnimation> createState() => _ItemPressingAnimation();
}

class _ItemPressingAnimation extends State<ItemPressingAnimation>
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
      lowerBound: 0,
      duration: const Duration(milliseconds: 200),
      value: 1,
    );
    controller.addStatusListener(_listener);
    _isHolding.addListener(() async {
      if (!_isHolding.value && controller.status == AnimationStatus.dismissed) {
        await controller.forward();
      }
    });
  }

  void _listener(AnimationStatus status) async {
    if (status == AnimationStatus.dismissed && !_isHolding.value) {
      await controller.forward();
    }
  }

  var colorTween = ColorTween(
    begin: Colors.grey.shade900,
    end: Colors.transparent,
  );


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        widget.onPress();
      },
      onTapDown: (details) async {
        _isHolding.value = true;
        controller.reverse();
      },
      onTapUp: (details) async {
        _isHolding.value = false;
      },
      onTapCancel: () async {
        _isHolding.value = false;
        controller.reverse();
        
      },
      child: AnimatedBuilder(
          animation: controller,
          builder: (context, _) {
            return Container(
              color: colorTween.evaluate(controller),
              child: widget.child,
            );
          }),
    );
  }
}
