import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:tomato_record/screens/input/category_input_screen.dart';
import 'package:tomato_record/screens/item/item_detail_screen.dart';
import 'package:tomato_record/states/category_notifier.dart';
import 'package:tomato_record/states/select_image_notifier.dart';
import '../screens/home_screen.dart';
import '../screens/input/input_screen.dart';
import 'package:provider/provider.dart';

const LOCATION_HOME = 'home';
const LOCATION_INPUT = 'input';
const LOCATION_ITEM = 'item';
const LOCATION_ITEM_ID = 'item_id';
const LOCATION_CATEGORY_INPUT = 'category_input';

class HomeLocation extends BeamLocation {
  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    return [BeamPage(child: HomeScreen(), key: ValueKey(LOCATION_HOME))];
  }

  @override
  List get pathBlueprints => ['/'];
}

class InputLocation extends BeamLocation {
  @override
  Widget builder(BuildContext context, Widget navigator) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: categoryNotifier),
        ChangeNotifierProvider(create: (context) => SelectImageNotifier()),
      ],
      child: super.builder(context, navigator),
    );
  }

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    return [
      ...HomeLocation().buildPages(context, state),
      if (state.pathBlueprintSegments.contains(LOCATION_INPUT))
        BeamPage(
          key: ValueKey(LOCATION_INPUT),
          child: MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (context) => SelectImageNotifier(),
              ),
              ChangeNotifierProvider.value(value: categoryNotifier),
            ],
            child: InputScreen(),
          ),
        ),
      // BeamPage(
      //   key: ValueKey('input'),
      //   child: InputScreen(),
      // ), 에러가 나던 예전 코드
      /* beamback을 하였을때 Could not find the correct Provider<CategoryNotifier> 
        above this Consumer<CategoryNotifier> Widget라는 오류가 발생 */

      if (state.pathBlueprintSegments.contains(LOCATION_CATEGORY_INPUT))
        BeamPage(
          key: ValueKey(LOCATION_CATEGORY_INPUT),
          child: ChangeNotifierProvider.value(
            value: categoryNotifier,
            child: CategoryInputScreen(),
          ),
        ),
      // BeamPage(
      //   key: ValueKey('category_input'),
      //   child: CategoryInputScreen(),
      // ),에러가 나던 예전 코드
      /* beamback을 하였을때 Could not find the correct Provider<CategoryNotifier> 
        above this Consumer<CategoryNotifier> Widget라는 오류가 발생 */
    ];
  }

  @override
  List get pathBlueprints =>
      ['/$LOCATION_INPUT', '/$LOCATION_INPUT/$LOCATION_CATEGORY_INPUT'];
}

class ItemLocation extends BeamLocation {
  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    return [
      ...HomeLocation().buildPages(context, state),
      if (state.pathParameters.containsKey(LOCATION_ITEM_ID))
        BeamPage(
          key: ValueKey(LOCATION_ITEM_ID),
          child: ItemDetailScreen(state.pathParameters[LOCATION_ITEM_ID] ?? ""),
        ),
    ];
  }

  @override
  List get pathBlueprints => ['/$LOCATION_ITEM/:$LOCATION_ITEM_ID'];
}
