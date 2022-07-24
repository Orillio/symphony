import 'dart:async';
import 'dart:io';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart' as pp;
import 'package:symphony/api/i_api_manager.dart';
import 'package:symphony/api/models/i_search_model.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class YtApiManager implements IApiManager {


  YtApiManager({this.hasLogger = true, });

  bool hasLogger;
  final _yt = YoutubeExplode();
  final _logger = Logger();

  final StreamController<double> _progressBroadcastStream = StreamController.broadcast();
  Stream<List<int>>? _downloadBroadcastStream;

  Stream<List<int>>? get downloadBroadcastStream {
    return _downloadBroadcastStream;
  }
  Stream<double> get progressBroadcastStream {
    return _progressBroadcastStream.stream;
  }


  @override
  Future<List<Video>> getVideoList(String query) async {
    var response = await _yt.search.search(query);
    var newResponse = response.where((e) {
      return e.duration != null;
    }).toList();
    return newResponse;
  }

  @override
  Future<Video> getConcreteVideo(String id, {Map<String, dynamic>? queryParameters}) async {
    return await _yt.videos.get(id);
  }
  @override
  Future downloadVideo(Video video, {String? fileName}) async {
    var muxedVideo = (await _yt.videos.streams.getManifest(video.id)).muxed.withHighestBitrate();
    _downloadBroadcastStream = _yt.videos.streams.get(muxedVideo).asBroadcastStream();
    if(_downloadBroadcastStream == null) return;

    var documentsDir = await pp.getApplicationDocumentsDirectory();
    var appDir = Directory('${documentsDir.path}/Symphony');
    if(!await appDir.exists()) {
      await appDir.create();
    }
    var videoTitle = video.title.replaceAll(r'\', '')
      .replaceAll('/', '')
      .replaceAll('*', '')
      .replaceAll('?', '')
      .replaceAll('"', '')
      .replaceAll('<', '')
      .replaceAll('>', '')
      .replaceAll('|', '');

    var newFile = File("${appDir.path}/${fileName ?? videoTitle}.${muxedVideo.container.name}");

    if (newFile.existsSync()) {
      if(hasLogger) _logger.i("The file with this name already exists. Rewriting it...");
      newFile.deleteSync();
    }
    var output = newFile.openWrite();
    var len = muxedVideo.size.totalBytes;
    var count = 0;

    _downloadBroadcastStream!.listen((event) {
      count += event.length;
      _progressBroadcastStream.add(count / len);
    });

    if(hasLogger) _logger.i("Downloading started...");
    try{
      await _downloadBroadcastStream!.pipe(output);
    }
    catch(e) {
      if(hasLogger) _logger.e("Error happened!\n$e");
    }
    _progressBroadcastStream.close();
    output.flush();
    output.close();

    if(hasLogger) {
      _logger.i(
        "Successfully downloaded file with size:"
        " ${muxedVideo.size.totalMegaBytes.toStringAsFixed(2)} MB!"
        " The new file name is ${newFile.path}"
      );
    }
  }
}

