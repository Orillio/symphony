import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:symphony/components/search_field.dart';

import '../../components/action_button.dart';

class MediaScreenChangeNotifier extends ChangeNotifier {
   var searchFieldController = TextEditingController();
}

class MediaScreen extends StatelessWidget {
  const MediaScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
    create: (_) => MediaScreenChangeNotifier(),
    child: const _MediaScreen(),
  );
}


class _MediaScreen extends StatelessWidget {

  final String title = "Медиатека";
  const _MediaScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var model = context.watch<MediaScreenChangeNotifier>();

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text("Медиатека"),
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
          ],
        ),
      ),
    );
  }
}
