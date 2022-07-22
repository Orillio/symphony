import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:symphony/api/api_youtube/yt_api_manager.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class SearchItem extends StatefulWidget {
  final bool hasDivider;
  final Video model;

  const SearchItem({
    required this.hasDivider,
    required this.model,
    Key? key,
  }) : super(key: key);

  @override
  State<SearchItem> createState() => _SearchItemState();
}

class _SearchItemState extends State<SearchItem> {
  late YtApiManager _ytApiManager;
  int _videoState = 0;

  @override
  initState() {
    _ytApiManager = YtApiManager();
    _ytApiManager.progressBroadcastStream.listen((event) {},
    onDone: () {
      setState(() {
        _videoState = 1;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: Row(
        children: [
          Flexible(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(2),
              child: Image.network(
                widget.model.thumbnails.lowResUrl,
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
                  Row(
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.4,
                                  child: Text(
                                    widget.model.author,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                                Text(
                                  "${(widget.model.duration!.inSeconds / 60).round()}:"
                                  "${widget.model.duration!.inSeconds % 60}",
                                  maxLines: 1,
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      IndexedStack(
                        index: _videoState,
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                _videoState = 2;
                              });
                              _ytApiManager.downloadVideo(widget.model);
                            },
                            customBorder: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Icon(
                                  CupertinoIcons.arrow_down_to_line,
                                  color: Get.theme.primaryColor,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Icon(
                                CupertinoIcons.checkmark_alt,
                                color: Get.theme.primaryColor,
                              ),
                            ),
                          ),
                          StreamBuilder<double>(
                              stream: _ytApiManager.progressBroadcastStream.asBroadcastStream(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return const SizedBox.shrink();
                                }
                                return Padding(
                                  padding: const EdgeInsets.only(right: 5),
                                  child: CircularPercentIndicator(
                                    radius: 20,
                                    center: Text(
                                      "${(snapshot.data! * 100).toStringAsFixed(0)}%",
                                      style: const TextStyle(
                                        fontSize: 9,
                                        color: Colors.white,
                                      ),
                                    ),
                                    lineWidth: 4,
                                    progressColor: Get.theme.primaryColor,
                                    backgroundColor: Get.theme.primaryColorDark,
                                    percent: snapshot.data!,
                                  ),
                                );
                              },
                            ),
                        ],
                      )
                    ],
                  ),
                  if (widget.hasDivider)
                    const Divider(
                      thickness: 0.15,
                      color: Colors.white,
                    )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
