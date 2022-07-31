import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:symphony/api/api_downloads/downloads_api.dart';
import 'package:symphony/api/player/player_audio_handler.dart';
import 'package:symphony/components/shared/blur_container.dart';
import 'package:symphony/navigation_scaffold.dart';
import 'package:symphony/themes/themes.dart';
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

  // for tracking current position of song
  Duration _currentPosition = const Duration();

  // if user is dragging slider right now
  bool _isSeeking = false;

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
    return _currentPosition;
  }

  // callbacks passed to _handler.
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
    if (_videoController != null && _videoController!.value.isInitialized) {
      return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (_videoController!.value.isPlaying) {
              _handler.pause();
            } else {
              _handler.play();
            }
          },
        ),
        body: Stack(
          children: [
            Center(
              child: AspectRatio(
                aspectRatio: _videoController!.value.aspectRatio,
                child: VideoPlayer(_videoController!),
              ),
            ),
            OrientationBuilder(
              builder: (context, orientation) {
                return BlurContainer(
                  color: Get.theme.appBarTheme.backgroundColor,
                  padding: orientation == Orientation.portrait
                      ? const EdgeInsets.only(left: 20, right: 20, top: 45)
                      : const EdgeInsets.only(left: 30, right: 30, top: 0),
                  height: orientation == Orientation.portrait ? 100 : 50,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 30),
                        child: Transform.rotate(
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
                      ),
                      Expanded(
                        child: ValueListenableBuilder<VideoPlayerValue>(
                          valueListenable: _videoController!,
                          builder: (context, value, child) {
                            if (!_isSeeking) {
                              _currentPosition = value.position;
                            }
                            return StatefulBuilder(
                                builder: (context, setState) {
                              return ProgressBar(
                                onDragStart: (details) => _isSeeking = true,
                                onDragEnd: () => _isSeeking = false,
                                onDragUpdate: (details) {
                                  setState(() {
                                    _currentPosition = details.timeStamp;
                                  });
                                },
                                timeLabelTextStyle: const TextStyle(
                                    color: ConstColors.gray, fontSize: 12),
                                total: value.duration,
                                progress: _currentPosition,
                                timeLabelLocation:
                                    orientation == Orientation.portrait
                                        ? TimeLabelLocation.below
                                        : TimeLabelLocation.sides,
                                barHeight: 3,
                                thumbRadius: 5,
                                thumbColor: Colors.white,
                                thumbGlowRadius: 10,
                                thumbGlowColor: Colors.white,
                                progressBarColor: Colors.white,
                                baseBarColor: ConstColors.gray,
                                onSeek: (value) {
                                  _handler.seek(value);
                                },
                              );
                            });
                          },
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 30),
                        child: Text(
                          "Test",
                          style: TextStyle(
                            color: ConstColors.gray,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: BlurContainer(
                height: 100,
                alignment: Alignment.bottomCenter,
                // child: OrientationBuilder(builder: (context, orientation) {
                //   return Grid
                // }),
              ),
            ),
          ],
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
