import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VkSearchModel extends ChangeNotifier {

}

class VkSearchPage extends StatelessWidget {
  const VkSearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => VkSearchModel(),
      child: const _VkSearchPage(),
    );
  }
}


class _VkSearchPage extends StatelessWidget {
  const _VkSearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "VK hey",
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }
}
