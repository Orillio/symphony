import 'package:flutter/material.dart';

class DownloadsScreenChangeNotifier extends ChangeNotifier {}

class DownloadsScreen extends StatefulWidget {
  const DownloadsScreen({Key? key}) : super(key: key);

  final String title = "Загрузки";

  @override
  State<DownloadsScreen> createState() => _DownloadsScreenState();
}

class _DownloadsScreenState extends State<DownloadsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text("Загрузки"),
        
      ),
    );
  }
}
