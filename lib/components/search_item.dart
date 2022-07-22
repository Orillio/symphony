import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
                    crossAxisAlignment: CrossAxisAlignment.end,
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
                            Text(
                              widget.model.author,
                              maxLines: 1,
                              style: TextStyle(color: Colors.grey),
                            )
                          ],
                        ),
                      ),
                      IconButton(
                        padding: const EdgeInsets.all(0),
                        icon: const Icon(CupertinoIcons.arrow_down_to_line),
                        color: Get.theme.primaryColor,
                        onPressed: () {
                          YtApiManager().downloadVideo(widget.model);
                        },
                      ),
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
