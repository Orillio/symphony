import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:symphony/api/api_youtube/yt_api_manager.dart';
import 'package:symphony/components/shared/search_field.dart';
import 'package:symphony/components/search_item.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class YtSearchPageModel extends ChangeNotifier {
  bool _searchedBefore = false;

  bool get searchedBefore {
    return _searchedBefore;
  }

  set searchedBefore(bool v) {
    _searchedBefore = v;
    notifyListeners();
  }

  Future<List<Video>>? modelFuture;
  var textSearchController = TextEditingController();

}

class YtSearchPage extends StatelessWidget {
  const YtSearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => YtSearchPageModel(),
      child: const _YtSearchPage(),
    );
  }
}

class _YtSearchPage extends StatelessWidget {
  const _YtSearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var model = context.watch<YtSearchPageModel>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SearchField(
          onSubmitted: (finalStr) {
            model.searchedBefore = true;
            model.modelFuture = YtApiManager().getVideoList(finalStr);
          },
          hintText: "Наберите для поиска в Youtube",
          controller: model.textSearchController,
        ),
        const SizedBox(
          height: 10,
        ),
        if (model.searchedBefore && model.modelFuture != null)
          FutureBuilder<List<Video>>(
            future: model.modelFuture,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          SearchItem(
                            key: UniqueKey(),
                            model: snapshot.data![index],
                            hasDivider: index != snapshot.data!.length - 1,
                          ),
                        ],
                      );
                    },
                  ),
                );
              } else {
                return Padding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.3,
                  ),
                  child: Center(
                    child: CupertinoActivityIndicator(
                      color: Colors.grey[100],
                    ),
                  ),
                );
              }
            },
          ),
      ],
    );
  }
}
