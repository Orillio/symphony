import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:symphony/api/api_downloads/downloads_api.dart';
import 'package:symphony/api/player/player_audio_handler.dart';
import 'package:symphony/navigation_scaffold.dart';
import 'package:video_player/video_player.dart';

GlobalKey<PlayerScreenState> playerKey = GlobalKey();

class PlayerScreen extends StatefulWidget {
  PlayerScreen() : super(key: playerKey);

  @override
  State<PlayerScreen> createState() => PlayerScreenState();
}

class PlayerScreenState extends State<PlayerScreen> {
  MediaFile? _model;
  VideoPlayerController? videoController;

  MediaFile? get model => _model;

  set model(MediaFile? model) {
    if (model == null || model == _model) return;
    _model = model;
    var file = File(_model!.path);
    if (file.existsSync()) {
      videoController?.dispose();
      videoController = VideoPlayerController.file(file,
          videoPlayerOptions: VideoPlayerOptions(
            allowBackgroundPlayback: true,
            mixWithOthers: true,
          ))
        ..initialize().then((_) async {
          videoController?.play();
          await PlayerAudioHandler.instance.play();
          setState(() {});
        });
    }
  }

  @override
  void dispose() {
    videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var videoPlayerModel = context.read<VideoPlayerChangeNotifier>();
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            if (videoController!.value.isPlaying) {
              videoController?.pause();
              PlayerAudioHandler.instance.pause();
              

            } else {
              videoController?.play();
              PlayerAudioHandler.instance.play();

            }
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
                  data: const SliderThemeData(),
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
          if (videoController != null && videoController!.value.isInitialized)
            Center(
              child: AspectRatio(
                aspectRatio: videoController!.value.aspectRatio,
                child: VideoPlayer(videoController!),
              ),
            ),
        ],
      ),
    );
  }
}
