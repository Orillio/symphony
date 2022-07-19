import 'package:blur_bottom_bar/blur_bottom_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NavigationModel extends ChangeNotifier {

}

class NavigationScaffold extends StatelessWidget {
  const NavigationScaffold({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
    create: (_) => NavigationModel(),
    child: const _NavigationScaffold(),
  );
}

class _NavigationScaffold extends StatelessWidget {
  const _NavigationScaffold({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      bottomNavigationBar: BlurBottomView(
        backgroundColor: Color(0xFF282828),
        onIndexChange: (index) {

        },
        showSelectedLabels: false,
        showUnselectedLabels: false,
        bottomNavigationBarItems: const [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.double_music_note),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.search),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.arrow_down_to_line_alt),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.info),
            label: "",
          ),
        ],
      ),
    );
  }
}
