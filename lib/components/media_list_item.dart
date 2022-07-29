import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:symphony/api/api_downloads/downloads_api.dart';
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
  var _containerColor = Colors.transparent;

  @override
  void initState() {
    super.initState();
    changedDate = FileStat.statSync(widget.model.path).changed;
    if (widget.model.mimetype.contains("video")) {
      thumbnailData = VideoThumbnail.thumbnailData(
          video: widget.model.path, timeMs: 20000);
    }
  }

  String durationToMinutes(double duration) {
    int result = (duration / (1000 * 60)).floor();
    return result < 10 ? "0$result" : "$result";
  }

  String durationToRemainderSeconds(double duration) {
    int result = ((duration / 1000) % 60).round();
    return result < 10 ? "0$result" : "$result";
  }

  String appendZero(int item) {
    return item < 10 ? "0$item" : "$item";
  }

  @override
  Widget build(BuildContext context) {
    var model = context.read<VideoPlayerChangeNotifier>();
    return GestureDetector(
      onTap: () async {
        await Future.delayed(const Duration(milliseconds: 300));
        playerKey.currentState?.model = widget.model;
        model.openBottomSheet();
      },
      onTapUp: (_) async {
        await Future.delayed(const Duration(milliseconds: 300));
        setState(() {
          _containerColor = Colors.transparent;
        });
      },
      onTapDown: (_) async {
        setState(() {
          _containerColor = Colors.grey.shade900;
        });
      },
      child: AnimatedContainer(
        color: _containerColor,
        duration: const Duration(milliseconds: 180),
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
      ),
    );
  }
}
