import 'package:blur_bottom_bar/blur_bottom_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:symphony/screens/navigation_pages/downloads_screen.dart';
import 'package:symphony/screens/navigation_pages/info_screen.dart';
import 'package:symphony/screens/navigation_pages/media_screen.dart';
import 'package:symphony/screens/navigation_pages/search_screen.dart';
import 'screens/player/video_player_sheet.dart';

class VideoPlayerChangeNotifier extends ChangeNotifier {
  late final AnimationController bottomSheetAnimationController;
  final Duration defaultDuration = const Duration(milliseconds: 300);

  openBottomSheet() {
    bottomSheetAnimationController.duration = defaultDuration;
    bottomSheetAnimationController.reverse();
  }
  closeBottomSheet() {
    bottomSheetAnimationController.forward();
  }
}

class NavigationModel extends ChangeNotifier {
  var _currentIndex = 0;

  PageController controller = PageController(initialPage: 0);

  var pages = <dynamic>[
    const MediaScreen(),
    const SearchScreen(),
    const DownloadsScreen(),
    const InfoScreen()
  ];

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
        child: const _NavigationScaffold(),
      );
}

class _NavigationScaffold extends StatelessWidget {
  const _NavigationScaffold({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var model = context.watch<NavigationModel>();
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: ChangeNotifierProvider(
          create: (_) => VideoPlayerChangeNotifier(),
          child: Stack(
            children: [
              Consumer<VideoPlayerChangeNotifier>(
                child: PageView(
                  onPageChanged: (index) {
                    model.currentIndex = index;
                  },
                  physics: const BouncingScrollPhysics(),
                  controller: model.controller,
                  children: model.pages.map((e) => e as Widget).toList(),
                ),
                builder: (context, vp, child) {
                  return child!;
                },
              ),
              BlurBottomView(
                opacity: 0.80,
                onIndexChange: (index) {
                  model.controller.animateToPage(
                    index,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  );
                  model.currentIndex = index;
                },
                currentIndex: model.currentIndex,
                backgroundColor:
                    Get.theme.bottomNavigationBarTheme.backgroundColor!,
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
              const VideoPlayerSheet(),
            ],
          ),
        ),
      ),
    );
  }
}
