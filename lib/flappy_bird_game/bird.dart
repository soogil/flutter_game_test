import 'package:flame/components.dart';
import 'package:flame/image_composition.dart';
import 'package:flame/sprite.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter_game_test/flappy_bird_game/config.dart';


enum BirdStatus { waiting, flying}
enum BirdFlyingStatus { up, down, none }

class Bird extends PositionComponent {
  Bird(Image spriteImage, Vector2 screenSize) {
    _screenSize = screenSize;
    List<Sprite> sprites = [
      Sprite(
          spriteImage,
          srcSize: Vector2(
            SpriteDimensions.birdWidth,
            SpriteDimensions.birdHeight,
          ),
          srcPosition: Vector2(
            SpritesPositions.birdSprite1X,
            SpritesPositions.birdSprite1Y,
          )
      ),
      Sprite(
          spriteImage,
          srcSize: Vector2(
            SpriteDimensions.birdWidth,
            SpriteDimensions.birdHeight,
          ),
          srcPosition: Vector2(
            SpritesPositions.birdSprite2X,
            SpritesPositions.birdSprite2Y,
          )
      ),
      Sprite(
          spriteImage,
          srcSize: Vector2(
            SpriteDimensions.birdWidth,
            SpriteDimensions.birdHeight,
          ),
          srcPosition: Vector2(
            SpritesPositions.birdSprite3X,
            SpritesPositions.birdSprite3Y,
          )
      ),
    ];

    final SpriteAnimation animatedBird = SpriteAnimation.spriteList(sprites, stepTime: 0.15);

    ground = BirdGround(animatedBird);
    add(ground);
  }

  final int _movingUpSteps = 25;

  late final Vector2 _screenSize;
  late final BirdGround ground;

  int _counter = 0;
  double _heightDiff = 0.0;
  double _stepDiff = 0.0;
  BirdStatus status = BirdStatus.waiting;
  BirdFlyingStatus flyingStatus = BirdFlyingStatus.none;

  void setPosition(double x, double y) {
    ground.x = x;
    ground.y = y;
  }

  @override
  void update(double dt) {
    if (status == BirdStatus.flying) {
      _counter++;
      if (_counter <= _movingUpSteps) {
        flyingStatus = BirdFlyingStatus.up;
        ground.showAnimation = true;
        ground.angle -= 0.01;
        ground.y -= dt * 100 * getSpeedRatio(flyingStatus, _counter);
      } else {
        flyingStatus = BirdFlyingStatus.down;
        ground.showAnimation = false;

        if (_heightDiff == 0) {
          _heightDiff = (_screenSize.y - ground.y);
        }
        if (_stepDiff == 0) {
          _stepDiff = ground.angle.abs() / (_heightDiff / 10);
        }
          
        ground.angle += _stepDiff;
        ground.y += dt * 100 * getSpeedRatio(flyingStatus, _counter);
      }
      ground.update(dt);
    }
  }

  double getSpeedRatio(BirdFlyingStatus flyingStatus, int counter){
    if (flyingStatus == BirdFlyingStatus.up) {
      var backwardCounter = _movingUpSteps - counter;
      return backwardCounter / 10.0;
    }
    if (flyingStatus == BirdFlyingStatus.down) {
      var diffCounter = counter - _movingUpSteps;
      return diffCounter / 10.0;
    }
    return 0.0;
  }

  void jump() {
    FlameAudio.play('wing.wav');
    status = BirdStatus.flying;
    _counter = 0;
    ground.angle = 0;
  }
}

class BirdGround extends SpriteAnimationComponent {
  bool showAnimation = true;
  
  BirdGround(SpriteAnimation animation)
    : super(animation: animation,
      size: Vector2(ComponentDimensions.birdWidth, ComponentDimensions.birdHeight)
  );

  @override
  void update(double dt){
    if (showAnimation) {
      super.update(dt);
    }
  }
}