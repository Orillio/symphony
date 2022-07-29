import 'dart:io';
import 'package:flutter_video_info/flutter_video_info.dart';
import 'package:path_provider/path_provider.dart';

class MediaFile {
  String path;
  String title;
  int fileSize;
  double duration;
  String mimetype;
  MediaFile(this.path, this.title, this.fileSize, this.duration, this.mimetype);
}

class DownloadsApi {
  final _videoInfo = FlutterVideoInfo();

  Future<List<MediaFile>> getVideosInDocumentsFolder() async {
    var documents = Directory(
        "${(await getApplicationDocumentsDirectory()).path}/Symphony");
    List<MediaFile> result = [];

    var entities = await documents.list().toList();
    for (var entity in entities) {
      var video = await _videoInfo.getVideoInfo(entity.path);
      // todo: make check for mp3
      if (video == null ||
          video.mimetype == null ||
          (!video.mimetype!.contains("video/") &&
              !video.mimetype!.contains("audio/"))) continue;
      video.title = video.title!.replaceAll("_", " ");
      result.add(MediaFile(video.path!, video.title!, video.filesize!,
          video.duration!, video.mimetype!));
    }
    return result;
  }
}
