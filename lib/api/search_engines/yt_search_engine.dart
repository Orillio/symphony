import 'dart:async';
import 'dart:io';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart' as pp;
import 'package:symphony/api/models/search_model.dart';
import 'package:symphony/api/search_engines/search_engine.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class YtSearchEngine implements SearchEngine {
  YtSearchEngine({
    hasLogger = true,
  }) {
    progressBroadcastStream = progressBroadcastStreamController.stream;
    if (hasLogger) {
      _logger = Logger();
    }
  }

  final _yt = YoutubeExplode();
  Logger? _logger;

  StreamController<double> progressBroadcastStreamController =
      StreamController.broadcast();

  @override
  late Stream<double> progressBroadcastStream;

  @override
  Future<List<SearchModel>> getMediaList(String query) async {
    var response = await _yt.search.search(query);
    var newResponse = response.where((e) {
      return e.duration != null;
    }).toList();
    return newResponse.map<SearchModel>((e) {
      return SearchModel()
        ..id = e.id.value
        ..title = e.title
        ..author = e.author
        ..thumbnailUrl = e.thumbnails.lowResUrl
        ..duration = e.duration;
    }).toList();
  }

  @override
  Future downloadMedia(SearchModel video, {String? fileName}) async {
    var muxedVideo = (await _yt.videos.streams.getManifest(video.id))
        .muxed
        .withHighestBitrate();
    var downloadBroadcastStream =
        _yt.videos.streams.get(muxedVideo).asBroadcastStream();

    var documentsDir = await pp.getApplicationDocumentsDirectory();
    var appDir = Directory('${documentsDir.path}/Symphony');
    if (!await appDir.exists()) {
      await appDir.create();
    }
    var videoTitle = video.title
        .replaceAll(RegExp('[^a-zA-Z-()& _.0-9]'), '')
        .replaceAll(' ', '_');

    var newFile = File(
        "${appDir.path}/${fileName ?? videoTitle}.${muxedVideo.container.name}");

    if (newFile.existsSync()) {
      _logger?.i("The file with this name already exists. Rewriting it...");
      newFile.deleteSync();
    }
    var output = newFile.openWrite();
    var len = muxedVideo.size.totalBytes;
    var count = 0;

    downloadBroadcastStream.listen((event) {
      count += event.length;
      progressBroadcastStreamController.add(count / len);
    });

    _logger?.i("Downloading started...");
    try {
      await downloadBroadcastStream.pipe(output);
    } catch (e) {
      _logger?.e("Error happened!\n$e");
    }
    progressBroadcastStreamController.close();
    output.flush();
    output.close();

    _logger?.i("Successfully downloaded file with size:"
        " ${muxedVideo.size.totalMegaBytes.toStringAsFixed(2)} MB!"
        " The new file name is ${newFile.path}");
  }
}
