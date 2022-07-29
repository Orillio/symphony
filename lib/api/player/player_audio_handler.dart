import 'package:audio_service/audio_service.dart';

class PlayerAudioHandler extends BaseAudioHandler
    with QueueHandler, SeekHandler {
  static late PlayerAudioHandler instance;

  var defaultPlaybackState = PlaybackState(
    // Which buttons should appear in the notification now
    controls: [
      MediaControl.skipToPrevious,
      MediaControl.pause,
      MediaControl.stop,
      MediaControl.skipToNext,
    ],
    // Which other actions should be enabled in the notification
    systemActions: const {
      MediaAction.seek,
      MediaAction.seekForward,
      MediaAction.seekBackward,
    },
    androidCompactActionIndices: const [0, 1, 3],
    processingState: AudioProcessingState.ready,
    playing: true,
    updatePosition: const Duration(milliseconds: 54321),
    bufferedPosition: const Duration(milliseconds: 65432),
    speed: 1.0,
    queueIndex: 0,
  );

  @override
  Future<void> play() {
    playbackState.add(defaultPlaybackState);
    return super.play();
  }

  @override
  Future<void> pause() async {
    super.pause();
  }

  @override
  Future<void> stop() async {}
  @override
  Future<void> seek(Duration position) async {}
  @override
  Future<void> skipToQueueItem(int i) async {}
}
