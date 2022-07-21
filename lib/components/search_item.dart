import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchItem extends StatefulWidget {
  final bool hasDivider;

  const SearchItem({required this.hasDivider, Key? key}) : super(key: key);

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
                "https://i.ytimg.com/vi/YPRaA6KhyXc/default.jpg",
                width: 60,
                height: 50,
              ),
            ),
          ),
          Flexible(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.6,
                        height: 45,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: const [
                            Text(
                              "Flutter video about widgets and widgets and more",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: Colors.white),
                            ),
                            Text(
                              "FlutterDevelopers | 21:06",
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
                        onPressed: () {},
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
