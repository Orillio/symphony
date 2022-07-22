import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:symphony/api/i_api_manager.dart';
import 'package:symphony/api/models/i_search_model.dart';
import 'package:symphony/screens/search_pages/yt_search_page.dart';

import '../models/yt_search_model.dart';

class YtApiManager implements IApiManager {

  final String _ytApiBaseUrl = "https://www.googleapis.com/youtube/v3";
  final _dio = Dio();
  late final String _apiKey;

  YtApiManager({String? apiKey}) {
    if(apiKey == null){
      _apiKey = dotenv.env["GOOGLE_API_KEY"]!;
    }
    else {
      _apiKey = apiKey;
    }
  }

  @override
  Future<List<ISearchModel>> getVideoList(String query, {Map<String, dynamic>? queryParameters}) async {
    queryParameters ??= <String, dynamic> {
      "part": "snippet",
      "maxResults": 25,
      "q": query,
      "key": _apiKey,
      "type": "video"
    };
    if(!queryParameters.containsKey("key")) {
      queryParameters.addAll({
        "key": _apiKey,
      });
    }
    Response<dynamic> response;
    try{
      response = await _dio.get(
        "$_ytApiBaseUrl/search",
        queryParameters: queryParameters,
      );

    }
    on DioError catch(e) {
      print(e.message);
      rethrow;
    }
    var items = response.data["items"] as List<dynamic>;
    return items.map((e) {
      return YtSearchModel.fromMap({
        "videoId": e["id"]["videoId"],
        "thumbnailUrl": e["snippet"]["thumbnails"]["default"]["url"],
        "title": e["snippet"]["title"],
        "author": e["snippet"]["channelTitle"],
      });
    }).toList();
  }

  @override
  Future<ISearchModel> getConcreteVideo(String id, {Map<String, dynamic>? queryParameters}) async {
    // TODO: implement getConcreteVideo
    throw UnimplementedError();
  }

}