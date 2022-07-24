import 'dart:io';

import 'package:flutter_video_info/flutter_video_info.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

class DownloadsApi {
  final _videoInfo = FlutterVideoInfo();

  Future<List<VideoData>> getVideosInDocumentsFolder() async{
    var documents = Directory("${(await getApplicationDocumentsDirectory()).path}/Symphony");
    List<VideoData> result = [];

    var entities = await documents.list().toList();
    for (var entity in entities) {
      var video = await _videoInfo.getVideoInfo(entity.path);
      // todo: make check for mp3
      if(video == null || video.mimetype == null || !video.mimetype!.contains("video/")) continue;
      result.add(video);
    }
    return result;
  }
}