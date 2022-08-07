import 'package:flutter/material.dart';

class InfoScreen extends StatefulWidget {
  const InfoScreen({Key? key}) : super(key: key);

  final String title = "Информация";


  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "1 Page",
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
