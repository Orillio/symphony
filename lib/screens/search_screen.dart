import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
}
