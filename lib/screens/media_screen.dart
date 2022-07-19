import 'package:flutter/material.dart';

class MediaScreen extends StatefulWidget {
  const MediaScreen({Key? key}) : super(key: key);

  final String title = "Медиатека";

  @override
  State<MediaScreen> createState() => _MediaScreenState();
}

class _MediaScreenState extends State<MediaScreen> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "1 Page",
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }
}
