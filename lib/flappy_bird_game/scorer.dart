import 'dart:collection';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flame_audio/flame_audio.dart';
import 'config.dart';


class Scorer extends PositionComponent {
  Scorer(Image spriteImage, Vector2 screenSize) {
    _screenSize = screenSize;
    _initSprites(spriteImage);
    _renderDefaultView();
  }

  late final ScorerGround _oneDigitGround;
  late final ScorerGround _twoDigitGround;
  late final ScorerGround _threeDigitGround;
  late final Vector2 _screenSize;
  late final HashMap<String, Sprite> _digits;
  int _score = 0;

  void increase() {
    _score++;
    _render();
    FlameAudio.play('point.wav');
  }

  void reset() {
    _score = 0;
    _render();
  }

  void _render(){
    // Adds leading zeroes to 3 digits
    var scoreStr = _score.toString().padLeft(3, '0');
    _oneDigitGround.sprite = _digits[scoreStr[2]];
    _twoDigitGround.sprite = _digits[scoreStr[1]];
    _threeDigitGround.sprite = _digits[scoreStr[0]];
  }

  void _initSprites(Image spriteImage){
    final Vector2 srcSize = Vector2(SpriteDimensions.numberWidth, SpriteDimensions.numberHeight);
    _digits = HashMap.from({
      "0": Sprite(
        spriteImage,
        srcSize: srcSize,
        srcPosition: Vector2(SpritesPositions.zeroNumberX, SpritesPositions.zeroNumberY),
      ),
      "1": Sprite(
        spriteImage,
        srcSize: srcSize,
        srcPosition: Vector2(SpritesPositions.firstNumberX, SpritesPositions.firstNumberY),
      ),
      "2": Sprite(
        spriteImage,
        srcSize: srcSize,
        srcPosition: Vector2(SpritesPositions.secondNumberX, SpritesPositions.secondNumberY),
      ),
      "3": Sprite(
        spriteImage,
        srcSize: srcSize,
        srcPosition: Vector2(SpritesPositions.thirdNumberX, SpritesPositions.thirdNumberY),
      ),
      "4": Sprite(
        spriteImage,
        srcSize: srcSize,
        srcPosition: Vector2(SpritesPositions.fourthNumberX, SpritesPositions.fourthNumberY),
      ),
      "5": Sprite(
        spriteImage,
        srcSize: srcSize,
        srcPosition: Vector2(SpritesPositions.fifthNumberX, SpritesPositions.fifthNumberY),
      ),
      "6": Sprite(
        spriteImage,
        srcSize: srcSize,
        srcPosition: Vector2(SpritesPositions.sixthNumberX, SpritesPositions.sixthNumberY),
      ),
      "7": Sprite(
        spriteImage,
        srcSize: srcSize,
        srcPosition: Vector2(SpritesPositions.seventhNumberX, SpritesPositions.seventhNumberY),
      ),
      "8": Sprite(
        spriteImage,
        srcSize: srcSize,
        srcPosition: Vector2(SpritesPositions.eighthNumberX, SpritesPositions.eighthNumberY),
      ),
      "9": Sprite(
        spriteImage,
        srcSize: srcSize,
        srcPosition: Vector2(SpritesPositions.ninthNumberX, SpritesPositions.ninthNumberY),
      )
    });
  }

  void _renderDefaultView() {
    const double defaultY = 80;
    final double twoGroundX = (_screenSize.x - ComponentDimensions.numberWidth) / 2;
    _twoDigitGround = ScorerGround(_digits["0"]!);
    _twoDigitGround.x = twoGroundX;
    _twoDigitGround.y = defaultY;
    _oneDigitGround = ScorerGround(_digits["0"]!);
    _oneDigitGround.x = _twoDigitGround.toRect().right + 5;
    _oneDigitGround.y = defaultY;
    _threeDigitGround = ScorerGround(_digits["0"]!);
    _threeDigitGround.x = twoGroundX - ComponentDimensions.numberWidth - 5;
    _threeDigitGround.y = defaultY;

    this..add(_oneDigitGround)
      ..add(_twoDigitGround)
      ..add(_threeDigitGround);
  }
}

class ScorerGround extends SpriteComponent {
  ScorerGround(Sprite sprite, [int multiplier = 1])
      : super(sprite: sprite,
      size: Vector2(ComponentDimensions.numberWidth * multiplier,
          ComponentDimensions.numberHeight * multiplier));
}