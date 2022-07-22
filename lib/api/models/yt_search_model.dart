import 'package:symphony/api/models/i_search_model.dart';

class YtSearchModel implements ISearchModel {
  @override
  late String id;
  @override
  String? thumbnailUrl;
  @override
  late String title;
  @override
  late String author;
  @override
  Duration? duration;

  YtSearchModel.fromMap(Map<String, dynamic> map) {
    id = map["videoId"];
    thumbnailUrl = map["thumbnailUrl"];
    title = map["title"];
    author = map["author"];
    duration = map["duration"];
  }


}