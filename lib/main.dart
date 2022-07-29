import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:symphony/navigation_scaffold.dart';
import 'package:symphony/api/player/player_audio_handler.dart';
import 'package:symphony/themes/themes.dart';



Future main() async {
  PlayerAudioHandler.instance = await AudioService.init(
    builder: () => PlayerAudioHandler(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.mycompany.myapp.channel.audio',
      androidNotificationChannelName: 'Music playback',
    ),
  );
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

