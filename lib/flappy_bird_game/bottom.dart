import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flutter_game_test/flappy_bird_game/config.dart';


enum BottomStatus { waiting, moving }

class Bottom extends PositionComponent {
  Bottom(Image spriteImage, Vector2 screenSize) {
    _screenSize = screenSize;
    Sprite sprite = Sprite(
      spriteImage,
      srcSize: Vector2(SpriteDimensions.bottomWidth, SpriteDimensions.bottomHeight),
      srcPosition: Vector2(SpritesPositions.bottomX, SpritesPositions.bottomY),
    );

    _firstGround = BottomGround(sprite, screenSize);
    _secondGround = BottomGround(sprite, screenSize);
    this..add(_firstGround)..add(_secondGround);
  }

  late final Vector2 _screenSize;
  late final BottomGround _firstGround;
  late final BottomGround _secondGround;
  late Rect _rect;

  BottomStatus status = BottomStatus.waiting;


  void setPosition(double x, double y) {
    _firstGround.x = x;
    _firstGround.y = y;
    _secondGround.x = _firstGround.width;
    _secondGround.y = y;
    _rect = Rect.fromLTWH(x, y, _screenSize.x, ComponentDimensions.bottomHeight);
  }

  @override
  void update(double dt){
    if (status == BottomStatus.moving) {
      _firstGround.x -= dt * Speed.groundSpeed;
      _secondGround.x -= dt * Speed.groundSpeed;

      if (_firstGround.x + _firstGround.width <= 0) {
        _firstGround.x = _secondGround.x + _secondGround.width;
      }

      if (_secondGround.x + _secondGround.width <= 0) {
        _secondGround.x = _firstGround.x + _firstGround.width;
      }
    }
  }

  void move() {
    status = BottomStatus.moving;
  }

  Rect get rect => _rect;
}

class BottomGround extends SpriteComponent {
  BottomGround(Sprite sprite, Vector2 screenSize)
      : super(sprite: sprite,
      size: Vector2(screenSize.x, ComponentDimensions.bottomHeight));
}