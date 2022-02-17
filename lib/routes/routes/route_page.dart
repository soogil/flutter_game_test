import 'package:flutter_library/flutter_library.dart';
import 'package:flutter_game_test/ui/game/game.dart';
import 'package:flutter_game_test/ui/selelct_page.dart';
import 'route_names.dart';
import 'package:get/get.dart';


class RoutePages {
  static final routes = [
    GetPage(
        name: RouteNames.select,
        transition: Transition.fade,
        // binding: BindingsBuilder(() => {
        //   Get.put<MittTrainingWithoutCameraController>(MittTrainingWithoutCameraController()),
        // }),
        page:() => const SelectPage()
    ),
    GetPage(
        name: RouteNames.game,
        transition: Transition.fade,
        // binding: BindingsBuilder(() => {
        //   Get.put<MittTrainingWithoutCameraController>(MittTrainingWithoutCameraController()),
        // }),
        page:() => const GamePage()
    ),
  ];
}