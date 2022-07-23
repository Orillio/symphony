import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:symphony/api/api_youtube/yt_api_manager.dart';

import 'package:symphony/main.dart';


void main() {

  late YtApiManager sut;

  setUp(() {
    sut = YtApiManager(hasLogger: false);
  });

  group("YT api works fine", () {
    test("getting video info works fine", () async {
      var video = await sut.getConcreteVideo("dQw4w9WgXcQ");
      expect(video.title, "Rick Astley - Never Gonna Give You Up (Official Music Video)");
    });
  });
}
