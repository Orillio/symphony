import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:symphony/api/api_downloads/directory_manager.dart';
import 'package:symphony/components/media_list_item.dart';
import 'package:symphony/components/shared/search_field.dart';

import '../../components/shared/action_button.dart';
import '../../navigation_scaffold.dart';

class MediaScreen extends StatefulWidget {
  const MediaScreen({Key? key}) : super(key: key);

  @override
  State<MediaScreen> createState() => _MediaScreenState();
}

class _MediaScreenState extends State<MediaScreen>
    with AutomaticKeepAliveClientMixin<MediaScreen> {
  final String title = "Медиатека";

  final downloads = DirectoryManager.instance;

  bool _match(String value, String matcher) =>
      matcher.toLowerCase().contains(value.toLowerCase());

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var model = context.watch<MediaScreenChangeNotifier>();
    model.fetchMediaData();
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text("Медиатека"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: ActionButton(
              text: const Text(
                "Править",
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 15, right: 3, left: 3),
              child: SearchField(
                controller: model.searchFieldController,
                hintText: "Искать в медиатеке",
              ),
            ),
            ValueListenableBuilder<Future<List<MediaFile>>?>(
              valueListenable: model.media,
              builder: (context, mediaFuture, _) {
                return FutureBuilder<List<MediaFile>>(
                  future: mediaFuture,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Expanded(
                        child: ValueListenableBuilder<TextEditingValue>(
                          valueListenable: model.searchFieldController,
                          builder: (context, value, child) {
                            return Column(
                              children: [
                                ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: (context, index) {
                                    if (_match(value.text,
                                        snapshot.data![index].title)) {
                                      return MediaListItem(
                                        model: snapshot.data![index],
                                        hasDivider:
                                            index != snapshot.data!.length - 1,
                                      );
                                    }
                                    return const SizedBox.shrink();
                                  },
                                ),
                                const SizedBox(
                                  height: 100,
                                )
                              ],
                            );
                          },
                        ),
                      );
                    } else {
                      return Padding(
                        padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.3,
                        ),
                        child: Center(
                          child: CupertinoActivityIndicator(
                            color: Colors.grey[100],
                          ),
                        ),
                      );
                    }
                  },
                );
              },
            )
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
