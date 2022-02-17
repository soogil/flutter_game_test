import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flutter_game_test/flappy_bird_game/config.dart';


class Horizon extends PositionComponent {
  Horizon(Image spriteImage, Vector2 screenSize) {
    final Sprite sprite = Sprite(
      spriteImage,
      srcSize: Vector2(SpriteDimensions.horizontalWidth, SpriteDimensions.horizontalHeight),
      srcPosition: Vector2(0.0, 0.0),
    );

    ground = HorizonGround(sprite, screenSize);
    add(ground);
  }

  late HorizonGround ground;
}


class HorizonGround extends SpriteComponent {
  HorizonGround(Sprite sprite, Vector2 screenSize)
      : super(sprite: sprite, size: screenSize);
}