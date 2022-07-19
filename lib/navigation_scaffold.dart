import 'package:blur_bottom_bar/blur_bottom_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:symphony/screens/downloads_screen.dart';
import 'package:symphony/screens/info_screen.dart';
import 'package:symphony/screens/media_screen.dart';
import 'package:symphony/screens/search_screen.dart';


class NavigationModel extends ChangeNotifier {

  String _appBarTitle = "Медиатека";
  var _currentIndex = 0;

  PageController controller = PageController(
    initialPage: 0
  );

  var pages = <dynamic>[
    const MediaScreen(),
    const SearchScreen(),
    const DownloadsScreen(),
    const InfoScreen()
  ];

  set appBarTitle(String value) {
    _appBarTitle = value;
    notifyListeners();
  }

  String get appBarTitle {
    return _appBarTitle;
  }

  set currentIndex(int value) {
    _currentIndex = value;
    notifyListeners();
  }

  int get currentIndex {
    return _currentIndex;
  }
}

class NavigationScaffold extends StatelessWidget {
  const NavigationScaffold({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (_) => NavigationModel(),
        child: _NavigationScaffold(),
      );
}

class _NavigationScaffold extends StatelessWidget {
  _NavigationScaffold({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var model = context.watch<NavigationModel>();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          model.appBarTitle,
        ),
        centerTitle: false,
      ),
      body: Stack(
        children: [
          PageView(
            onPageChanged: (index) {
              model.currentIndex = index;
              model.appBarTitle = model.pages[index].title;
            },
            physics: const BouncingScrollPhysics(),
            controller: model.controller,
            children: model.pages.map((e) => e as Widget).toList(),
          ),
          BlurBottomView(
            opacity: 0.98,
            onIndexChange: (index) {
              model.controller.animateToPage(
                index,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
              );
              model.currentIndex = index;
            },
            currentIndex: model.currentIndex,
            backgroundColor: Get.theme.bottomNavigationBarTheme.backgroundColor!,
            selectedItemColor:
            Get.theme.bottomNavigationBarTheme.selectedItemColor!,
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
        ],
      ),
    );
  }
}
