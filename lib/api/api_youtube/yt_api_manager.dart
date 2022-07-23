import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart' as pp;
import 'package:symphony/api/i_api_manager.dart';
import 'package:symphony/api/models/i_search_model.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class YtApiManager implements IApiManager {


  final _dio = Dio();
  final yt = YoutubeExplode();
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
  Future<VideoSearchList> getVideoList(String query) async {
    var response = await yt.search.search(query);
    return response;
  }

  @override
  Future<ISearchModel> getConcreteVideo(String id, {Map<String, dynamic>? queryParameters}) async {
    // TODO: implement getConcreteVideo
    throw UnimplementedError();
  }
  @override
  Future downloadVideo(Video video) async {
    var muxedVideo = (await yt.videos.streams.getManifest(video.id)).muxed.withHighestBitrate();
    _downloadBroadcastStream = yt.videos.streams.get(muxedVideo).asBroadcastStream();
    if(_downloadBroadcastStream == null) return;

    var directory = await pp.getApplicationDocumentsDirectory();
    var downloads = Directory(directory.path);
    var videoTitle = video.title.replaceAll(r'\', '')
      .replaceAll('/', '')
      .replaceAll('*', '')
      .replaceAll('?', '')
      .replaceAll('"', '')
      .replaceAll('<', '')
      .replaceAll('>', '')
      .replaceAll('|', '');
    var newFile = File("${downloads.path}/$videoTitle.${muxedVideo.container.name}");

    if (newFile.existsSync()) {
      _logger.i("The file with this name already exists. Rewriting it...");
      newFile.deleteSync();
    }
    var output = newFile.openWrite();
    var len = muxedVideo.size.totalBytes;
    var count = 0;

    _downloadBroadcastStream!.listen((event) {
      count += event.length;
      _progressBroadcastStream.add(count / len);
    });

    _logger.i("Downloading started...");
    try{
      await _downloadBroadcastStream!.pipe(output);
    }
    catch(e) {
      _logger.e("Error happened!\n$e");
    }
    _progressBroadcastStream.close();
    output.flush();
    output.close();

    _logger.i(
      "Successfully downloaded file with size:"
      " ${muxedVideo.size.totalMegaBytes.toStringAsFixed(2)} MB!"
      " The new file name is ${newFile.path}"
    );
  }
}




// var status = await Permission.storage.status;
// if (status.isRestricted || status.isDenied || status.isLimited) {
//   Map<Permission, PermissionStatus> statuses = await [
//     Permission.storage,
//   ].request();
//   print(statuses[Permission.storage]); // this must show permission granted.
// }
// File file = File('/storage/emulated/0/folder_name/out.mp4');
// final FlutterFFprobe _flutterFFprobe = new FlutterFFprobe();
//
// _flutterFFprobe
//     .getMediaInformation(file.path)
//     .then((info) => print(info));
