import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:symphony/api/search_engines/yt_search_engine.dart';
import 'package:symphony/components/dark_segmented_control.dart';
import '../search_pages/search_page.dart';

class SearchScreenModel extends ChangeNotifier {
  int _tabIndex = 0;

  int get tabIndex {
    return _tabIndex;
  }

  set tabIndex(int value) {
    _tabIndex = value;
    notifyListeners();
  }
}

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with AutomaticKeepAliveClientMixin<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ChangeNotifierProvider(
      create: (_) => SearchScreenModel(),
      child: __SearchScreenState(),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class __SearchScreenState extends StatelessWidget {
  __SearchScreenState({Key? key}) : super(key: key);

  final Map<int, Widget> tabNames = {
    0: const Text(
      "Youtube",
      style: TextStyle(
        color: Colors.white,
      ),
    ),
    1: const Text(
      "ВКонтакте",
      style: TextStyle(
        color: Colors.white,
      ),
    ),
  };
  final List<Widget> tabs = [
    SearchPage(
      engine: YtSearchEngine(),
    ),
    SearchPage(
      engine: YtSearchEngine(),
    ),
  ];
  @override
  Widget build(BuildContext context) {
    var model = context.watch<SearchScreenModel>();

    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: DarkSegmentedControl(
              width: 120,
              children: tabNames,
            ),
          ),
        ],
        centerTitle: false,
        title: const Text("Поиск"),
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.only(top: 15),
          child: IndexedStack(
            index: model.tabIndex,
            children: tabs,
          ),
        ),
      ),
    );
  }
}
