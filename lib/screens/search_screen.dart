import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  final String title = "Поиск";

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
  with AutomaticKeepAliveClientMixin<SearchScreen>{
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const Scaffold(
      body: WebView(
        initialUrl: "https://flutter.dev",
      ),
      // body: const Center(
      //   child: Text(
      //     "1 Page",
      //     style: TextStyle(
      //       color: Colors.white,
      //     ),
      //   ),
      // ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

}
