import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:symphony/navigation_scaffold.dart';
import 'package:symphony/themes/themes.dart';


Future main() async {
  runApp(const SymphonyApp());
}

class SymphonyApp extends StatelessWidget {
  const SymphonyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Symphony App',
      themeMode: ThemeMode.dark,
      theme: AppThemes.darkTheme,
      home: const NavigationScaffold(),
    );
  }
}

