import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flutter_game_test/flappy_bird_game/config.dart';


class GameOver extends PositionComponent {
  GameOver(Image spriteImage, Vector2 screenSize){
    final Sprite sprite = Sprite(
      spriteImage,
      srcSize: Vector2(SpriteDimensions.gameOverWidth, SpriteDimensions.gameOverHeight),
      srcPosition: Vector2(SpritesPositions.gameOverX, SpritesPositions.gameOverY),
    );
    
    ground = GameOverGround(sprite);
    ground.x = (screenSize.x - ComponentDimensions.gameOverWidth) / 2;
    ground.y = (screenSize.y - ComponentDimensions.gameOverHeight) / 2;
    add(ground);
  }

  late final GameOverGround ground;
}

class GameOverGround extends SpriteComponent {
  GameOverGround(Sprite sprite)
      : super(sprite: sprite,
            size: Vector2(ComponentDimensions.gameOverWidth, ComponentDimensions.gameOverHeight));
}