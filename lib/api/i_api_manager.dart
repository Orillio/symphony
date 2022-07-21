import 'models/i_search_model.dart';

abstract class IApiManager {
  List<ISearchModel> getVideoList(String query, {dynamic options});
  ISearchModel getConcreteVideo(String id, {dynamic options});
}
