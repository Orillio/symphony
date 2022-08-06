import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:symphony/api/api_downloads/directory_manager.dart';
import 'package:symphony/components/shared/item_pressing_animation.dart';
import 'package:symphony/screens/player/player_screen.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../navigation_scaffold.dart';

class MediaListItem extends StatefulWidget {
  final MediaFile model;
  final bool hasDivider;

  const MediaListItem({required this.model, required this.hasDivider, Key? key})
      : super(key: key);

  @override
  State<MediaListItem> createState() => _MediaItemState();
}

class _MediaItemState extends State<MediaListItem> {
  Future<Uint8List?>? thumbnailData;
  late DateTime changedDate;
  @override
  void initState() {
    super.initState();
    changedDate = FileStat.statSync(widget.model.path).changed;
    if (widget.model.mediaType == MediaType.video) {
      thumbnailData =
          VideoThumbnail.thumbnailData(video: widget.model.path, timeMs: 20000);
    }
  }

  String durationToMinutes(Duration duration) {
    var minutes = duration.inMinutes;
    return minutes < 10 ? "0$minutes" : "$minutes";
  }

  String durationToRemainderSeconds(Duration duration) {
    int result = duration.inSeconds % 60;
    return result < 10 ? "0$result" : "$result";
  }

  String appendZero(int item) {
    return item < 10 ? "0$item" : "$item";
  }

  @override
  Widget build(BuildContext context) {
    var videoChangeNotifier = context.read<VideoPlayerChangeNotifier>();
    var mediaChangeNotifier = context.read<MediaScreenChangeNotifier>();

    return ItemPressingAnimation(
      onPress: () async {
        await Future.delayed(const Duration(milliseconds: 300));
        await playerKey.currentState
            ?.prepare(widget.model, await mediaChangeNotifier.media.value!);
        videoChangeNotifier.openBottomSheet();
      },
      child: Padding(
          padding: const EdgeInsets.all(0),
          child: Row(
            children: [
              Flexible(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(2),
                  child: thumbnailData != null
                      ? FutureBuilder<Uint8List?>(
                          future: thumbnailData,
                          builder: (context, sn) {
                            if (sn.hasData) {
                              return Image.memory(
                                sn.data!,
                                width: 60,
                                height: 50,
                              );
                            } else {
                              return const SizedBox(
                                width: 60,
                                height: 50,
                              );
                            }
                          },
                        )
                      : const SizedBox(
                          width: 60,
                          height: 50,
                        ),
                ),
              ),
              Flexible(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SafeArea(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.6,
                              height: 52,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    widget.model.title,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "${durationToMinutes(widget.model.duration)}:"
                                        "${durationToRemainderSeconds(widget.model.duration)} | "
                                        "${(widget.model.fileSize / (1024 * 1024)).toStringAsFixed(1)} MB",
                                        maxLines: 1,
                                        style:
                                            const TextStyle(color: Colors.grey),
                                      ),
                                      Text(
                                        "${appendZero(changedDate.day)}.${appendZero(changedDate.month)}.${changedDate.year}",
                                        maxLines: 1,
                                        style:
                                            const TextStyle(color: Colors.grey),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Logger().i("icon click");
                              },
                              customBorder: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: Icon(
                                    CupertinoIcons.ellipsis_vertical,
                                    color: Get.theme.primaryColor,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      if (widget.hasDivider)
                        const Divider(
                          height: 0,
                          thickness: 0.15,
                          color: Colors.white,
                        )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
    );
  }
}
