import 'dart:async';

import '../models/search_model.dart';

abstract class SearchEngine {
  Future<List<SearchModel>> getMediaList(String query);
  Future downloadMedia(SearchModel video);
  late Stream<double> progressBroadcastStream;
}
