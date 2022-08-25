import 'dart:io';
import 'dart:math';
import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:perfect_volume_control/perfect_volume_control.dart';
import 'package:provider/provider.dart';
import 'package:symphony/api/api_downloads/directory_manager.dart';
import 'package:symphony/api/player/player_audio_handler.dart';
import 'package:symphony/components/shared/blur_container.dart';
import 'package:symphony/components/shared/icon_pressing_animation.dart';
import 'package:symphony/components/shared/volume_bar.dart';
import 'package:symphony/navigation_scaffold.dart';
import 'package:symphony/themes/themes.dart';
import 'package:video_player/video_player.dart';

GlobalKey<PlayerScreenState> playerKey = GlobalKey();

class PlayerScreen extends StatefulWidget {
  PlayerScreen() : super(key: playerKey);

  @override
  State<PlayerScreen> createState() => PlayerScreenState();
}

class PlayerScreenState extends State<PlayerScreen>
    with TickerProviderStateMixin {
  MediaFile? _currentMediaFile;
  MediaFile? get currentMediaFile => _currentMediaFile;

  /// current queue session
  List<MediaFile>? _queue;

  /// first queue session
  List<MediaFile>? _initialQueue;

  VideoPlayerController? _videoController;
  late PlayerAudioHandler _handler;

  /// controller for sliding animation for controls
  late AnimationController animationController;

  /// current volume, notifies the volume bar if changes.
  late final ValueNotifier<double> _currentVolume;

  /// value notifier for tracking shuffle mode value
  final ValueNotifier<bool> _isShuffleEnabled = ValueNotifier(false);

  /// for tracking current position of song
  Duration _currentPosition = const Duration();

  /// if user is dragging slider right now
  bool _isSeeking = false;

  /// Preparing for new video/audio session, setting new video/audio
  /// file to be played.
  Future<void> prepare(MediaFile mediaFile, List<MediaFile> queue,
      {bool overwriteCurrentMedia = false}) async {
    if (mediaFile.title == _currentMediaFile?.title || overwriteCurrentMedia) {
      return;
    }
    _initialQueue = List.from(queue);
    _queue = List.from(queue);

    await PlayerAudioHandler().init(mediaFile, _queue!);
    await _setCurrentMediaFile(mediaFile);
    animationController.forward();
    var session = await AudioSession.instance;

    await session.configure(const AudioSessionConfiguration.music());

    if (await session.setActive(true)) {
      Logger().i("Audio session is set");
      await _setCurrentMediaFile(mediaFile);
      session.interruptionEventStream.listen((event) {
        if (event.begin) {
          _handler.pause();
        } else {
          _handler.play();
        }
      });
      session.becomingNoisyEventStream.listen((event) {
        _handler.pause();
      });
      _isShuffleEnabled.addListener(() {
        if (_isShuffleEnabled.value) {
        } else {}
      });
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
      resetCurrentPosition();
      await _handler.play();
      setState(() {});

      _videoController!.addListener(_onVideoTick);
    }
  }

  void _shuffle() {
    _queue!.shuffle();
    _handler.addInQueue(_queue!,
        currentIndex: _queue!.indexOf(currentMediaFile!));
  }

  void _unShuffle() {
    _queue = List.from(_initialQueue!);
    _handler.addInQueue(_queue!,
        currentIndex: _queue!.indexOf(currentMediaFile!));
  }

  Duration getCurrentPosition() {
    return _currentPosition;
  }

  void resetCurrentPosition() {
    _currentPosition = Duration.zero;
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

  Future _onSkip(PlaybackState value) async {
    _setCurrentMediaFile(_queue![value.queueIndex!]);
  }

  void _onVolumeChange(double value) {
    _currentVolume.value = value;
  }

  void _onVideoTick() {
    if (_videoController!.value.position >=
        _videoController!.value.duration - const Duration(milliseconds: 500)) {
      _onVideoEnd();
      if (!_videoController!.value.isLooping) {
        _videoController?.removeListener(_onVideoTick);
      }
    }
  }

  void _onVideoEnd() {
    if (!_videoController!.value.isLooping) {
      _handler.skipToNext();
    } else {
      resetCurrentPosition();
      _handler.resetPosition();
    }
  }

  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
      value: 1,
    );

    _handler = PlayerAudioHandler();
    _handler.playEvent.listen(_onPlay);
    _handler.pauseEvent.listen(_onPause);
    _handler.seekEvent.listen(_onSeek);
    _handler.skipEvent.listen(_onSkip);
    Future(
      () async {
        _currentVolume = ValueNotifier(await PerfectVolumeControl.volume);
      },
    );
    PerfectVolumeControl.stream.listen(_onVolumeChange);
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
        body: AnimatedBuilder(
          animation: animationController,
          builder: (context, _) {
            return Stack(
              children: [
                GestureDetector(
                  onTap: () {
                    if (animationController.isCompleted) {
                      animationController.reverse();
                    } else if (animationController.isDismissed) {
                      animationController.forward();
                    }
                  },
                  child: Container(
                    color: Colors.transparent,
                    height: MediaQuery.of(context).size.height,
                    child: Center(
                      child: AspectRatio(
                        aspectRatio: _videoController!.value.aspectRatio,
                        child: VideoPlayer(_videoController!),
                      ),
                    ),
                  ),
                ),
                Opacity(
                  opacity: animationController.value,
                  child: OrientationBuilder(
                    builder: (context, orientation) {
                      double height =
                          orientation == Orientation.portrait ? 100 : 50;
                      return Transform.translate(
                        offset:
                            Offset(0, (animationController.value - 1) * height),
                        child: BlurContainer(
                          color: Get.theme.appBarTheme.backgroundColor,
                          padding: orientation == Orientation.portrait
                              ? const EdgeInsets.only(
                                  left: 20, right: 20, top: 45)
                              : const EdgeInsets.only(
                                  left: 30, right: 30, top: 0),
                          height: height,
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
                                        onDragStart: (details) =>
                                            _isSeeking = true,
                                        onDragEnd: () => _isSeeking = false,
                                        onDragUpdate: (details) {
                                          setState(() {
                                            _currentPosition =
                                                details.timeStamp;
                                          });
                                        },
                                        timeLabelTextStyle: const TextStyle(
                                            color: ConstColors.gray,
                                            fontSize: 12),
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
                        ),
                      );
                    },
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Opacity(
                    opacity: animationController.value,
                    child: Builder(builder: (context) {
                      var orientation = MediaQuery.of(context).orientation;
                      double height =
                          orientation == Orientation.portrait ? 200 : 70;
                      var controls = orientation == Orientation.portrait
                          ? _portraitOrientedControls()
                          : _landscapeOrientedControls();
                      return Transform.translate(
                        offset:
                            Offset(0, (1 - animationController.value) * height),
                        child: BlurContainer(height: height, child: controls),
                      );
                    }),
                  ),
                ),
              ],
            );
          },
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _landscapeOrientedControls() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 4,
            child: _volumeBarControl(),
          ),
          Expanded(
            flex: 5,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _repeatControl(),
                _skipToPreviousControl(),
                _playButtonControl(Orientation.landscape),
                _skipToNext(),
                _shuffleControl()
              ],
            ),
          ),
          const SizedBox(
            width: 50,
          ),
          Expanded(
            flex: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _seekBackControl(),
                _seekForward(),
                _speedControl(),
                _moreControl(),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _portraitOrientedControls() {
    return Column(
      children: [
        SizedBox(
          height: 100,
          width: MediaQuery.of(context).size.width * 0.85,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _repeatControl(),
              _skipToPreviousControl(),
              _playButtonControl(Orientation.portrait),
              _skipToNext(),
              _shuffleControl(),
            ],
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.85,
          height: 25,
          child: _volumeBarControl(),
        ),
        SizedBox(
          height: 70,
          width: MediaQuery.of(context).size.width * 0.80,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _seekBackControl(),
              _seekForward(),
              _speedControl(),
              _moreControl(),
            ],
          ),
        )
      ],
    );
  }

  Widget _moreControl() {
    return IconPressingAnimation(
      onPress: () {},
      child: const Icon(CupertinoIcons.ellipsis_vertical),
    );
  }

  Widget _speedControl() {
    return IconPressingAnimation(
      onPress: () {},
      child: const Text(
        "1",
        style: TextStyle(fontSize: 20, color: Color(0xFF98989f)),
      ),
    );
  }

  Widget _seekForward() {
    return IconPressingAnimation(
      onPress: () {
        _handler.seek(getCurrentPosition() + const Duration(seconds: 15));
      },
      child: const Icon(CupertinoIcons.goforward_15),
    );
  }

  Widget _seekBackControl() {
    return IconPressingAnimation(
      onPress: () {
        _handler.seek(getCurrentPosition() - const Duration(seconds: 15));
      },
      child: const Icon(CupertinoIcons.gobackward_15),
    );
  }

  Widget _volumeBarControl() {
    return ValueListenableBuilder(
      valueListenable: _currentVolume,
      builder: (context, value, _) {
        return VolumeBar(
          currentVolume: _currentVolume.value,
          onDragUpdate: (volume) async {
            await PerfectVolumeControl.setVolume(volume);
            setState(() {});
          },
          onVolumeIconPress: () {},
        );
      },
    );
  }

  Widget _repeatControl() {
    return IconPressingAnimation(
      onPress: () {
        if (_videoController!.value.isLooping) {
          _videoController!.setLooping(false);
        } else {
          _videoController!.setLooping(true);
        }
      },
      child: ValueListenableBuilder<VideoPlayerValue>(
        valueListenable: _videoController!,
        builder: (context, value, child) {
          return Icon(
            CupertinoIcons.repeat,
            size: 20,
            color: value.isLooping
                ? Theme.of(context).primaryColor
                : Theme.of(context).primaryColorDark,
          );
        },
      ),
    );
  }

  Widget _shuffleControl() {
    return IconPressingAnimation(
      onPress: () {
        _isShuffleEnabled.value = !_isShuffleEnabled.value;

        if (_isShuffleEnabled.value) {
          _shuffle();
        } else {
          _unShuffle();
        }
      },
      child: ValueListenableBuilder<bool>(
        valueListenable: _isShuffleEnabled,
        builder: (context, value, child) {
          return Icon(
            CupertinoIcons.shuffle,
            size: 20,
            color: value
                ? Theme.of(context).primaryColor
                : Theme.of(context).primaryColorDark,
          );
        },
      ),
    );
  }

  Widget _skipToNext() {
    return IconPressingAnimation(
      onPress: () {
        _handler.skipToNext();
      },
      child: const Icon(
        CupertinoIcons.forward_fill,
        size: 35,
        color: Colors.white,
      ),
    );
  }

  Widget _skipToPreviousControl() {
    return IconPressingAnimation(
      onPress: () {
        _handler.skipToPrevious();
      },
      child: const Icon(
        CupertinoIcons.backward_fill,
        size: 35,
        color: Colors.white,
      ),
    );
  }

  Widget _playButtonControl(Orientation orientation) {
    return IconPressingAnimation(
      onPress: () {
        _videoController!.value.isPlaying ? _handler.pause() : _handler.play();
      },
      child: orientation == Orientation.landscape
          ? Icon(
              !_videoController!.value.isPlaying
                  ? CupertinoIcons.play_arrow_solid
                  : CupertinoIcons.pause_fill,
              size: 35,
              color: Colors.white,
            )
          : Icon(
              _videoController!.value.isPlaying
                  ? CupertinoIcons.pause_circle_fill
                  : CupertinoIcons.play_circle_fill,
              size: 50,
              color: Colors.white,
            ),
    );
  }
}
