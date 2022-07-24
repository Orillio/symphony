import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_video_info/flutter_video_info.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class PlayerScreen extends StatefulWidget {
  final VideoData? model;

  const PlayerScreen({this.model, Key? key}) : super(key: key);

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  late VideoPlayerController _videoController;

  @override
  void initState() {
    super.initState();
    if(widget.model == null) return;
    var file = File(widget.model!.path!);
    if (file.existsSync()) {
      _videoController = VideoPlayerController.file(file,
          videoPlayerOptions: VideoPlayerOptions(allowBackgroundPlayback: true))
        ..initialize().then((_) async {
          _videoController.play();
          setState(() {});
        });
    }
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _videoController.value.isPlaying
                ? _videoController.pause()
                : _videoController.play();
          });
        },
      ),
      body: Stack(
        children: [
          Container(
            color: Get.theme.appBarTheme.backgroundColor,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            height: 60,
            child: Row(
              children: [
                const Text(
                  "Test",
                  style: TextStyle(color: Colors.white),
                ),
                Slider(value: 0, onChanged: (newValue) {}),
              ],
            ),
          ),
          if (false) // todo
            Center(
              child: AspectRatio(
                aspectRatio: _videoController.value.aspectRatio,
                child: _videoController.value.isInitialized
                    ? VideoPlayer(_videoController)
                    : const SizedBox.shrink(),
              ),
            ),
          // ListView.builder(
          //   itemCount: 100,
          //   shrinkWrap: true,
          //   itemBuilder: (_, __) {
          //     return const Text(
          //       "10031321321321",
          //       style: TextStyle(color: Colors.white),
          //     );
          //   },
          // )
        ],
      ),
    );
  }
}
