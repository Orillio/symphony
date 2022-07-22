import 'models/i_search_model.dart';

abstract class IApiManager {
  Future<List<ISearchModel>> getVideoList(String query, {Map<String, dynamic>? queryParameters});
  Future<ISearchModel> getConcreteVideo(String id, {Map<String, dynamic>? queryParameters});
}
