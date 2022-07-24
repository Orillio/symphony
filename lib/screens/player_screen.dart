import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_video_info/flutter_video_info.dart';
import 'package:video_player/video_player.dart';

class PlayerScreen extends StatefulWidget {

  final VideoData model;

  const PlayerScreen({required this.model, Key? key}) : super(key: key);

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {

  late VideoPlayerController _videoController;

  @override
  void initState() {
    super.initState();
    var file = File(widget.model.path!);
    if(file.existsSync()) {
      _videoController = VideoPlayerController.file(
        file,
        videoPlayerOptions: VideoPlayerOptions(
          allowBackgroundPlayback: true
        )
      )..initialize().then((_) async {
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
      appBar: AppBar(
        centerTitle: false,
        title: Text("Player1"),
      ),
      body: Center(
        child: AspectRatio(
          aspectRatio: _videoController.value.aspectRatio,
          child: _videoController.value.isInitialized
            ? VideoPlayer(
              _videoController
            )
            : const SizedBox.shrink(),
        ),
      ),
    );
  }

}
