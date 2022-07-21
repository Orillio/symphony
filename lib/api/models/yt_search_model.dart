import 'package:symphony/api/models/i_search_model.dart';

class YtSearchModel implements ISearchModel {
  @override
  late String id;
  @override
  late String url;
  @override
  String? thumbnailUrl;
  @override
  late String title;
  @override
  String? description;
  @override
  late String length;
}