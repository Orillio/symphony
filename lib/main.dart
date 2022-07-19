import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:symphony/navigation_scaffold.dart';
import 'package:symphony/themes/themes.dart';

void main() {
  runApp(const SymphonyApp());
}

class SymphonyApp extends StatelessWidget {
  const SymphonyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Symphony App',
      theme: AppThemes.darkTheme,
      home: const NavigationScaffold(),
    );
  }
}

