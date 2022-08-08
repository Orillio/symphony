import 'package:symphony/api/models/search_model.dart';

class YtSearchModel implements SearchModel {
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
}
