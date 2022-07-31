import 'package:youtube_explode_dart/youtube_explode_dart.dart';


abstract class IApiManager {
  Future<List<Video>> getVideoList(String query);
  Future<Video> getConcreteVideo(String id);
  Future downloadVideo(Video video);
}
