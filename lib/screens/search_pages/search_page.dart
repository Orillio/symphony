import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:symphony/api/models/search_model.dart';
import 'package:symphony/api/search_engines/search_engine.dart';
import 'package:symphony/components/shared/search_field.dart';
import 'package:symphony/components/search_item.dart';

class SearchPageChangeNotifier extends ChangeNotifier {
  bool _searchedBefore = false;

  bool get searchedBefore {
    return _searchedBefore;
  }

  set searchedBefore(bool v) {
    _searchedBefore = v;
    notifyListeners();
  }

  Future<List<SearchModel>>? modelFuture;
  var textSearchController = TextEditingController();
}

class SearchPage extends StatelessWidget {
  const SearchPage({Key? key, required this.engine}) : super(key: key);

  final SearchEngine engine;
 

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => SearchPageChangeNotifier(),
        ),
        Provider(
          create: (_) => engine,
        )
      ],
      child: Builder(builder: (context) {
        var model = context.watch<SearchPageChangeNotifier>();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SearchField(
              onSubmitted: (finalStr) {
                model.searchedBefore = true;
                model.modelFuture = engine.getMediaList(finalStr);
              },
              hintText: "Наберите для поиска в Youtube",
              controller: model.textSearchController,
            ),
            const SizedBox(
              height: 10,
            ),
            if (model.searchedBefore && model.modelFuture != null)
              FutureBuilder<List<SearchModel>>(
                future: model.modelFuture,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Expanded(
                      child: ValueListenableBuilder(
                        valueListenable: model.textSearchController,
                        builder: (context, value, child) {
                          return ListView.builder(
                            itemCount: snapshot.data!.length,
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return SearchItem(
                                key: UniqueKey(),
                                model: snapshot.data![index],
                                hasDivider: index != snapshot.data!.length - 1,
                              );
                            },
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
      }),
    );
  }
}
