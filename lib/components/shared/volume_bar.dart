import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VolumeBar extends StatefulWidget {
  const VolumeBar({
    Key? key,
    required this.currentVolume,
    required this.onDragUpdate,
    required this.onVolumeIconPress,
  }) : super(key: key);

  final double currentVolume;
  final Function(double volume) onDragUpdate;
  final Function() onVolumeIconPress;

  @override
  State<VolumeBar> createState() => _VolumeBarState();
}

class _VolumeBarState extends State<VolumeBar> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(CupertinoIcons.volume_mute),
        Expanded(
          child: SliderTheme(
            data: const SliderThemeData(
              trackHeight: 2,
              thumbShape: RoundSliderThumbShape(
                enabledThumbRadius: 7,
              ),
            ),
            child: Slider(
              thumbColor: Colors.white,
              activeColor: Colors.white,
              inactiveColor: Colors.grey[800],
              min: 0,
              max: 1,
              value: widget.currentVolume,
              onChanged: widget.onDragUpdate,
            ),
          ),
        ),
      ],
    );
  }
}
