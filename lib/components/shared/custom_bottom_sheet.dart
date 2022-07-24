import 'package:flutter/material.dart';

GlobalKey<_CustomBottomSheetState> bottomSheetKey = GlobalKey<_CustomBottomSheetState>();

class CustomBottomSheet extends StatefulWidget {
  const CustomBottomSheet({Key? key}) : super(key: key);

  @override
  State<CustomBottomSheet> createState() => _CustomBottomSheetState();
}

class _CustomBottomSheetState extends State<CustomBottomSheet>
    with TickerProviderStateMixin {

  final Duration _defaultDuration = const Duration(milliseconds: 300);

  late AnimationController _controller;
  late double _screenHeight;

  bool _canDrag = true;

  open(){
    _controller.duration = _defaultDuration;
    _controller.reverse();
  }

  _onDragStart(DragStartDetails details) {
    _canDrag = true;
  }

  _onDragEnd(DragEndDetails details) {
    if (_controller.isDismissed || _controller.isCompleted) {
      return;
    }
    if (_canDrag) {
      if (details.velocity.pixelsPerSecond > const Offset(0, 100) || _controller.value > 0.2) {
        _controller.duration = Duration(
          milliseconds: (_controller.value * 0.5 * 1500)
            .round()
            .clamp(300, 2000),
        );
        _controller.forward();
      } else {
        _controller.duration = Duration(
          milliseconds: ((0.15 / _controller.value) * 1500)
            .round()
            .clamp(300, 2000),
        );
        _controller.reverse();
      }
    }
  }

  _onDragUpdate(DragUpdateDetails details) {
    if (_canDrag) {
      var delta = details.primaryDelta! / _screenHeight;
      _controller.value += delta;
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _controller.duration = _defaultDuration;
    _controller.value = 1;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragStart: _onDragStart,
      onVerticalDragEnd: _onDragEnd,
      onVerticalDragUpdate: _onDragUpdate,
      child: AnimatedBuilder(
        animation: _controller,
        child: Container(
          color: Colors.grey,
        ),
        builder: (BuildContext context, Widget? child) {
          _screenHeight = MediaQuery.of(context).size.height;
          return Transform(
            alignment: Alignment.topCenter,
            transform: Matrix4.identity()
              ..translate(0.0, _screenHeight * _controller.value),
            child: child,
          );
        },
      ),
    );
  }
}
