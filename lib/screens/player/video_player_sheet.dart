import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:symphony/screens/player/player_screen.dart';

import '../../navigation_scaffold.dart';

class VideoPlayerSheet extends StatefulWidget {
  const VideoPlayerSheet({Key? key}) : super(key: key);

  @override
  State<VideoPlayerSheet> createState() => _VideoPlayerSheetState();
}

class _VideoPlayerSheetState extends State<VideoPlayerSheet>
    with TickerProviderStateMixin {
  late double _screenHeight;
  VideoPlayerChangeNotifier? model;
  bool _canDrag = true;

  open() {
    model!.bottomSheetAnimationController.duration = model!.defaultDuration;
    model!.bottomSheetAnimationController.reverse();
  }

  _onDragStart(DragStartDetails details) {
    _canDrag = true;
  }

  _onDragEnd(DragEndDetails details) {
    if (model!.bottomSheetAnimationController.isDismissed ||
        model!.bottomSheetAnimationController.isCompleted) {
      return;
    }
    if (_canDrag) {
      if (details.velocity.pixelsPerSecond > const Offset(0, 100) ||
          model!.bottomSheetAnimationController.value > 0.2) {
        model!.bottomSheetAnimationController.duration = Duration(
          milliseconds:
              (model!.bottomSheetAnimationController.value * 0.5 * 1500)
                  .round()
                  .clamp(300, 2000),
        );
        model!.bottomSheetAnimationController.forward();
      } else {
        model!.bottomSheetAnimationController.duration = Duration(
          milliseconds:
              ((0.15 / model!.bottomSheetAnimationController.value) * 1500)
                  .round()
                  .clamp(300, 2000),
        );
        model!.bottomSheetAnimationController.reverse();
      }
    }
  }

  _onDragUpdate(DragUpdateDetails details) {
    if (_canDrag) {
      var delta = details.primaryDelta! / _screenHeight;
      model!.bottomSheetAnimationController.value += delta;
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.endOfFrame.then((value) {
      model = context.read<VideoPlayerChangeNotifier>();
      if (model == null) return;
      model!.bottomSheetAnimationController = AnimationController(vsync: this);
      model!.bottomSheetAnimationController.duration = model!.defaultDuration;
      model!.bottomSheetAnimationController.value = 1;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragStart: _onDragStart,
      onVerticalDragEnd: _onDragEnd,
      onVerticalDragUpdate: _onDragUpdate,
      child: model != null
          ? AnimatedBuilder(
              animation: model!.bottomSheetAnimationController,
              child: PlayerScreen(),
              builder: (BuildContext context, Widget? child) {
                _screenHeight = MediaQuery.of(context).size.height;
                return Transform(
                  alignment: Alignment.topCenter,
                  transform: Matrix4.identity()
                    ..translate(
                        0.0,
                        _screenHeight *
                            model!.bottomSheetAnimationController.value),
                  child: child,
                );
              },
            )
          : const SizedBox.shrink(),
    );
  }
}
