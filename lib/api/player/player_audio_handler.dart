import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:symphony/screens/player/player_screen.dart';
import 'package:uuid/uuid.dart';

import '../api_downloads/downloads_api.dart';

class PlayerAudioHandler extends BaseAudioHandler
    with QueueHandler, SeekHandler {
  static final PlayerAudioHandler _instance = PlayerAudioHandler._init();

  PlayerAudioHandler._init();

  factory PlayerAudioHandler() {
    return _instance;
  }

  final StreamController<PlaybackState> _playEventController =
      StreamController.broadcast();
  final StreamController<PlaybackState> _pauseEventController =
      StreamController.broadcast();
  final StreamController<PlaybackState> _seekEventController =
      StreamController.broadcast();
  Stream<PlaybackState> get playEvent {
    return _playEventController.stream;
  }

  Stream<PlaybackState> get pauseEvent {
    return _pauseEventController.stream;
  }

  Stream<PlaybackState> get seekEvent {
    return _seekEventController.stream;
  }

  Future<void> init(MediaFile mediaFile, List<MediaFile> queue) async {
    playbackState.add(PlaybackState(
      // Which buttons should appear in the notification now
      controls: [
        MediaControl.skipToPrevious,
        MediaControl.pause,
        MediaControl.play,
        MediaControl.skipToNext,
      ],
      // Which other actions should be enabled in the notification
      systemActions: const {
        MediaAction.prepare,
        MediaAction.seek,
        MediaAction.seekForward,
        MediaAction.seekBackward,
      },
      androidCompactActionIndices: const [0, 1, 3],
      processingState: AudioProcessingState.idle,
      playing: true,
      speed: 1.0,
      queueIndex: 0,
    ));
    mediaItem.add(
      MediaItem(
        id: const Uuid().v4(),
        title: mediaFile.title,
        duration: Duration(milliseconds: mediaFile.duration.round()),
      ),
    );
    this.queue.add(
      queue.map((e) {
        return MediaItem(
          id: const Uuid().v4(),
          title: e.title,
          duration: Duration(milliseconds: e.duration.round()),
        );
      }).toList(),
    );
  }

  @override
  Future<void> play() async {
    var newState = playbackState.value.copyWith(
        playing: true,
        updatePosition: playerKey.currentState!.getCurrentPosition());
    playbackState.add(newState);
    _playEventController.add(newState);
  }

  @override
  Future<void> pause() async {
    var newState = playbackState.value.copyWith(
        playing: false,
        updatePosition: playerKey.currentState!.getCurrentPosition());
    playbackState.add(newState);
    _pauseEventController.add(newState);
  }

  @override
  Future<void> seek(Duration position) async {
    var newState = playbackState.value.copyWith(
      updatePosition: position,
    );
    playbackState.add(newState);
    _seekEventController.add(newState);
  }

  // @override
  // Future<void> skipToQueueItem(int i) async {}
}
