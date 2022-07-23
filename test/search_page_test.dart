import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:symphony/components/shared/search_field.dart';
import 'package:symphony/main.dart';
import 'package:symphony/screens/navigation_pages/search_screen.dart';

void main() {
  Widget widgetWrappedInMaterialApp(Widget widget) {
    return MaterialApp(
      home: widget,
    );
  }

  setUp(() {});
  testWidgets("title is displayed", (tester) async {
    var screenKey = GlobalKey();
    await tester.pumpWidget(
      widgetWrappedInMaterialApp(
        SearchScreen(
          key: screenKey,
        ),
      ),
    );
    expect(find.text("Поиск"), findsOneWidget);
  });

  testWidgets("search field works as intended", (tester) async {
    var controller = TextEditingController();
    await tester.pumpWidget(
      widgetWrappedInMaterialApp(
        Material(
          child: SearchField(
            controller: controller,
            hintText: "hintText",
          ),
        ),
      ),
    );
    expect(find.text("hintText"), findsOneWidget);
    await tester.tap(find.byType(TextField));
    await tester.pump();
    expect(tester.allWidgets.whereType<AnimatedContainer>().first.constraints!.maxWidth, isPositive);

    var clearIconFinder = find.byKey(const Key("clear_button"));

    await tester.enterText(find.byType(TextField), "actualText");
    await tester.pump();
    expect(clearIconFinder, findsOneWidget);
    expect(find.text("actualText"), findsOneWidget);
    await tester.pump();
    await tester.tap(clearIconFinder);
    await tester.pump();
    expect(clearIconFinder, findsNothing);
    await tester.tap(find.byType(AnimatedContainer));
    await tester.pump();
    expect(tester.allWidgets.whereType<AnimatedContainer>().first.constraints!.maxWidth, isZero);

  });
}
