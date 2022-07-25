import 'dart:io';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_video_info/flutter_video_info.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:symphony/navigation_scaffold.dart';
import 'package:video_player/video_player.dart';

GlobalKey<_PlayerScreenState> playerKey = GlobalKey();

class PlayerScreen extends StatefulWidget {
  PlayerScreen() : super(key: playerKey);

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {

  VideoData? _model;
  VideoPlayerController? _videoController;

  VideoData? get model => _model;
  set model(VideoData? model) {
    if(model == null || model == _model) return;
    _model = model;
    var file = File(_model!.path!);
    if (file.existsSync()) {
      _videoController?.dispose();
      _videoController = VideoPlayerController.file(file,
          videoPlayerOptions: VideoPlayerOptions(allowBackgroundPlayback: true))
        ..initialize().then((_) async {
          _videoController?.play();
          setState(() {});
        });
    }
  }



  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    var videoPlayerModel = context.read<VideoPlayerChangeNotifier>();
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _videoController!.value.isPlaying
                ? _videoController?.pause()
                : _videoController?.play();
          });
        },
      ),
      body: Stack(
        children: [
          Container(
            color: Get.theme.appBarTheme.backgroundColor,
            padding: const EdgeInsets.only(left: 20, right: 20, top: 45),
            height: 100,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Transform.rotate(
                  angle: 3 * pi / 2,
                  child: GestureDetector(
                    onTap: videoPlayerModel.closeBottomSheet,
                    child: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                    ),
                  ),
                ),
                SliderTheme(
                  data: SliderThemeData(),
                  child: Slider(
                    value: 0.3,
                    onChanged: (double value) {},
                  ),
                ),
                const Text(
                  "Test",
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          if (_videoController != null && _videoController!.value.isInitialized)
            Center(
              child: AspectRatio(
                aspectRatio: _videoController!.value.aspectRatio,
                child: VideoPlayer(_videoController!),
              ),
            ),
        ],
      ),
    );
  }
}
