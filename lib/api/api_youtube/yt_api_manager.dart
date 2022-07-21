import 'package:symphony/api/i_api_manager.dart';
import 'package:symphony/api/models/i_search_model.dart';

class YtApiManager implements IApiManager {

  @override
  ISearchModel getConcreteVideo(String id, {options}) {
    // TODO: implement getConcrete
    throw UnimplementedError();
  }

  @override
  List<ISearchModel> getVideoList(String query, {options}) {
    // TODO: implement getList
    throw UnimplementedError();
  }

}