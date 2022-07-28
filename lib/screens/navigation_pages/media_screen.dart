import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_video_info/flutter_video_info.dart';
import 'package:provider/provider.dart';
import 'package:symphony/api/api_downloads/downloads_api.dart';
import 'package:symphony/components/media_item.dart';
import 'package:symphony/components/shared/search_field.dart';

import '../../components/shared/action_button.dart';

GlobalKey mediaScreenKey = GlobalKey();

class MediaScreenChangeNotifier extends ChangeNotifier {
  var searchFieldController = TextEditingController();
  Future<List<VideoData>>? mediaFuture;
}

class MediaScreen extends StatelessWidget {
  const MediaScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      ChangeNotifierProvider(
        create: (_) => MediaScreenChangeNotifier(),
        child: _MediaScreen(key: mediaScreenKey),
      );
}


class _MediaScreen extends StatefulWidget {

  const _MediaScreen({Key? key}) : super(key: key);

  @override
  State<_MediaScreen> createState() => __MediaScreenState();
}

class __MediaScreenState extends State<_MediaScreen>
  with AutomaticKeepAliveClientMixin<_MediaScreen>{
  final String title = "Медиатека";

  final downloads = DownloadsApi();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var model = context.watch<MediaScreenChangeNotifier>();
    model.mediaFuture = downloads.getVideosInDocumentsFolder();
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
            FutureBuilder<List<VideoData>>(
              future: model.mediaFuture,
              builder: (context, snapshot) {
                if(snapshot.hasData) {
                  return Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return MediaItem(
                          key: UniqueKey(),
                          model: snapshot.data![index],
                          hasDivider: index != snapshot.data!.length - 1,
                        );
                      },
                    ),
                  );
                }
                else {
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
            )
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
