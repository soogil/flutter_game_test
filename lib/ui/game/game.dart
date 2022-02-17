import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_game_test/flappy_bird_game/flappy_bird_game.dart';


class GamePage extends StatelessWidget {
  const GamePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GameWidget(
      game: FlutterBirdGame(),
      loadingBuilder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

// class MyGame extends FlameGame {
//   @override
//   Future<void> onLoad() async {
//     await super.onLoad();
//     add(MyCrate());
//   }
// }
//
// class MyCrate extends SpriteComponent {
//   MyCrate() : super(size: Vector2(Get.width, Get.height));
//
//   @override
//   Future<void> onLoad() async {
//     sprite = await Sprite.load('photo.png');
//     anchor = Anchor.center;
//
//     super.onLoad();
//   }
//
//   @override
//   void onGameResize(Vector2 gameSize) {
//     super.onGameResize(gameSize);
//     position = gameSize / 2;
//   }
// }