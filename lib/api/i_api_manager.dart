import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import 'models/i_search_model.dart';

abstract class IApiManager {
  Future<VideoSearchList> getVideoList(String query);
  Future<ISearchModel> getConcreteVideo(String id);
  Future downloadVideo(Video video);
}
