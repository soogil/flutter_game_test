import 'dart:math';
import 'dart:ui';
import 'package:get/get.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flutter_game_test/flappy_bird_game/config.dart';
import 'package:flutter_game_test/flappy_bird_game/flappy_bird_game.dart';


enum TubeType { top, bottom }

class Tube extends PositionComponent with HasGameRef<FlutterBirdGame> {
  Tube(TubeType type, Image spriteImage, [Tube? bottomTube]) {
    _type = type;
    _bottomTube = bottomTube;
    final Sprite sprite = Sprite(
      spriteImage,
      srcSize: Vector2(SpriteDimensions.tubeWidth, SpriteDimensions.tubeHeight),
      srcPosition: Vector2(SpritesPositions.tubeX, SpritesPositions.tubeY),
    );

    ground = TubeGround(sprite, _type);

    switch (_type) {
      case TubeType.top:
        ground.angle = 3.14159; // radians
        break;
      default:
    }

    add(ground);
  }

  final double _holeRange = 150;
  late final TubeGround ground;
  late final TubeType _type;

  Tube? _bottomTube;
  bool _hasBeenOnScreen = false;
  double get _topTubeOffset => Get.height * 0.15;
  double get _bottomTubeOffset => Get.height * 0.5;

  bool get isOnScreen => 
    ground.x + ComponentDimensions.tubeWidth > 0 &&
    ground.x < Get.width;
  
  bool crossedBird = false;

  @override
  Rect toRect() {
    var baseRect = super.toRect();
    if (_type == TubeType.bottom) {
      return baseRect;
    } else {
      return Rect.fromLTWH(
        baseRect.left - ComponentDimensions.tubeWidth,
        baseRect.top - ComponentDimensions.tubeHeight,
        baseRect.width,
        baseRect.height
      );
    }
  }

  void setPosition(double x, double y) {
    _hasBeenOnScreen = false;
    crossedBird = false;
    ground.x = x + (_type == TubeType.top ? ComponentDimensions.tubeWidth : 0);
    setY();
  }

  @override
  void update(double dt){
      if (!_hasBeenOnScreen && isOnScreen) {
        _hasBeenOnScreen = true;
      }

      if (_hasBeenOnScreen && !isOnScreen) {
        // print("Moved");
        ground.x = Get.width * 1.5;
        setY();
        crossedBird = false;
        _hasBeenOnScreen = false;
      }

      ground.x -= dt * Speed.groundSpeed;
  }

  void setY() {
    var ratio = double.parse(Random().nextDouble().toStringAsFixed(2));
    var length = _bottomTubeOffset - _topTubeOffset;
    var newY = length * ratio + _topTubeOffset;
    ground.y = newY;

    if (_bottomTube != null) {
      _bottomTube!.ground.y = newY + _holeRange;
    }
  }
}

class TubeGround extends SpriteComponent {
  TubeGround(Sprite sprite, TubeType type)
      : super(sprite: sprite,
      size: Vector2(
          ComponentDimensions.tubeWidth, ComponentDimensions.tubeHeight)) {
    _type = type;
  }

  late TubeType _type;

  @override
  Rect toRect() {
    var baseRect = super.toRect();
    if (_type == TubeType.bottom) {
      return baseRect;
    } else {
      return Rect.fromLTWH(
          baseRect.left,
          baseRect.top ,
          baseRect.width,
          baseRect.height
      );
    }
  }
}
