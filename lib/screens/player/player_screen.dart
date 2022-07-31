import 'dart:io';
import 'dart:math';
import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
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
  MediaFile? _currentMediaFile;
  List<MediaFile>? _queue;
  VideoPlayerController? _videoController;
  late PlayerAudioHandler _handler;

  MediaFile? get currentMediaFile => _currentMediaFile;

  /// Preparing for new video/audio session, setting new video/audio
  /// file to be played.
  Future<void> prepare(MediaFile mediaFile, List<MediaFile> queue,
      {bool overrideCurrentMedia = false}) async {
    if (mediaFile == _currentMediaFile || overrideCurrentMedia) return;

    await PlayerAudioHandler().init(mediaFile, queue);
    await _setCurrentMediaFile(mediaFile);

    var session = await AudioSession.instance;

    await session.configure(const AudioSessionConfiguration.music());

    if (await session.setActive(true)) {
      Logger().i("Audio session is set");
      await _setCurrentMediaFile(mediaFile);
      _queue = queue;
    } else {
      Logger().i("Audio session denied..");
    }
  }

  Future _setCurrentMediaFile(MediaFile mediaFile) async {
    _currentMediaFile = mediaFile;
    var file = File(_currentMediaFile!.path);
    if (file.existsSync()) {
      _videoController?.dispose();
      _videoController = VideoPlayerController.file(file,
          videoPlayerOptions: VideoPlayerOptions(
            allowBackgroundPlayback: true,
          ));
      await _videoController!.initialize();
      await _handler.play();
      setState(() {});
    }
  }

  Duration getCurrentPosition() {
    var value = _videoController!.value;
    return value.position;
  }

  Future _onPlay(PlaybackState value) async {
    if (_videoController == null) return;
    await _videoController!.play();
    setState(() {});
  }

  Future _onPause(PlaybackState value) async {
    if (_videoController == null) return;
    await _videoController!.pause();
    setState(() {});
  }

  Future _onSeek(PlaybackState value) async {
    if (_videoController == null) return;
    await _videoController!.seekTo(value.updatePosition);
    setState(() {});
  }

  @override
  void initState() {
    _handler = PlayerAudioHandler();

    _handler.playEvent.listen(_onPlay);
    _handler.pauseEvent.listen(_onPause);
    _handler.seekEvent.listen(_onSeek);

    super.initState();
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            if (_videoController!.value.isPlaying) {
              _handler.pause();
            } else {
              _handler.play();
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
                  child: Consumer<VideoPlayerChangeNotifier>(
                    builder: (context, model, child) {
                      return GestureDetector(
                        onTap: model.closeBottomSheet,
                        child: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                        ),
                      );
                    },
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
