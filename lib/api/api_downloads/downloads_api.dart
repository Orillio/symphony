import 'dart:io';
import 'package:flutter_video_info/flutter_video_info.dart';
import 'package:path_provider/path_provider.dart';

enum MediaType { video, audio }

class MediaFile {
  String path;
  String title;
  int fileSize;
  double duration;
  MediaType mediaType;
  MediaFile(
      this.path, this.title, this.fileSize, this.duration, this.mediaType);
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

      var mediaType = video.mimetype!.contains("video/")
          ? MediaType.video
          : MediaType.audio;

      video.title = video.title!.replaceAll("_", " ");
      result.add(MediaFile(video.path!, video.title!, video.filesize!,
          video.duration!, mediaType));
    }
    return result;
  }
}
