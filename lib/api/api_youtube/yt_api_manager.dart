import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart' as pp;
import 'package:symphony/api/i_api_manager.dart';
import 'package:symphony/api/models/i_search_model.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class YtApiManager implements IApiManager {

  final _dio = Dio();
  final yt = YoutubeExplode();

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
    var stream = yt.videos.streams.get(muxedVideo);
    var directory = await pp.getApplicationDocumentsDirectory();
    var downloads = Directory("${directory.path}");
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
      newFile.deleteSync();
    }
    var output = newFile.openWrite();
    var len = muxedVideo.size.totalBytes;
    var count = 0;
    print(newFile);

    // stream.listen((event) {
    //   output.add(event);
    //   count += event.length;
    //   print(count / len);
    // });
    await stream.pipe(output);
    output.flush();
    output.close();
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
