import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:symphony/components/search_field.dart';
import 'package:symphony/components/search_item.dart';

class YtSearchModel extends ChangeNotifier {
  var textSearchController = TextEditingController();
}

class YtSearchPage extends StatelessWidget {
  const YtSearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => YtSearchModel(),
      child: _YtSearchPage(),
    );
  }
}

class _YtSearchPage extends StatelessWidget {
  const _YtSearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var model = context.watch<YtSearchModel>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SearchField(
          hintText: "Наберите для поиска в Youtube",
          controller: model.textSearchController,
        ),
        const SizedBox(
          height: 10,
        ),
        ListView.builder(
          itemCount: 3,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            if (index == 2) {
              return const SearchItem(
                hasDivider: false,
              );
            }
            return const SearchItem(
              hasDivider: true,
            );
          },
        ),
      ],
    );
  }
}
