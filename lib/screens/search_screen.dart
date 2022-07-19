import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:symphony/components/dark_segmented_control.dart';

class SearchScreenModel extends ChangeNotifier {}

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  final String title = "Поиск";

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

  final Map<int, Widget> children = {
    1: Container(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: const Text(
        "ВКонтакте",
        style: TextStyle(
            color: Colors.white
        ),
      ),
    ),
    2: Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: const Text(
        "Youtube",
        style: TextStyle(
            color: Colors.white
        ),
      ),
    ),
  };

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.only(top: 15),
        child: DarkSegmentedControl(
          children: children,
          onValueChanged: (smt) {
            print("changed");
          },
        ),
      ),
    );
  }
}
