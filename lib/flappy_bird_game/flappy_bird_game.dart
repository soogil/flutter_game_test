import 'dart:async';
import 'dart:ui';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter_game_test/flappy_bird_game/bird.dart';
import 'package:flutter_game_test/flappy_bird_game/bottom.dart';
import 'package:flutter_game_test/flappy_bird_game/config.dart';
import 'package:flutter_game_test/flappy_bird_game/gameover.dart';
import 'package:flutter_game_test/flappy_bird_game/horizon.dart';
import 'package:flutter_game_test/flappy_bird_game/scorer.dart';
import 'package:flutter_game_test/flappy_bird_game/tube.dart';


enum GameStatus { playing, waiting, gameOver }

class FlutterBirdGame extends FlameGame with TapDetector {
  late final Horizon horizon;
  late final Bird bird;
  late final Bottom bottom;
  late final GameOver gameOver;
  late final Tube firstTopTube;
  late final Tube firstBottomTube;
  late final Tube secondTopTube;
  late final Tube secondBottomTube;
  late final Tube thirdTopTube;
  late final Tube thirdBottomTube;
  late final Image _spriteImage;
  late final Scorer _scorer;

  late double _xTubeStart;
  final double _xTubeOffset = 220;

  GameStatus status = GameStatus.waiting;


  @override
  Future<void>? onLoad() async {
    _spriteImage = (await Flame.images.loadAll(['sprite.png'])).first;

    bird = Bird(_spriteImage, size);
    horizon = Horizon(_spriteImage, size);
    bottom = Bottom(_spriteImage, size);
    gameOver = GameOver(_spriteImage, size);
    _scorer = Scorer(_spriteImage, size);

    firstBottomTube = Tube(TubeType.bottom, _spriteImage);
    firstTopTube = Tube(TubeType.top, _spriteImage, firstBottomTube);
    secondBottomTube = Tube(TubeType.bottom, _spriteImage);
    secondTopTube = Tube(TubeType.top, _spriteImage, secondBottomTube);
    thirdBottomTube = Tube(TubeType.bottom, _spriteImage);
    thirdTopTube = Tube(TubeType.top, _spriteImage, thirdBottomTube);

    initPositions(_spriteImage);

    this..add(horizon)
      ..add(bird)
      ..add(firstTopTube)
      ..add(firstBottomTube)
      ..add(secondTopTube)
      ..add(secondBottomTube)
      ..add(thirdTopTube)
      ..add(thirdBottomTube)
      ..add(bottom)
      ..add(gameOver)
      ..add(_scorer);

    super.onLoad();
  }

  void initPositions(Image spriteImage) {
    _xTubeStart = size.x * 1.5;
    bird.setPosition(ComponentPositions.birdX, ComponentPositions.birdY);
    bottom.setPosition(0, size.y - ComponentDimensions.bottomHeight);
    firstBottomTube.setPosition(_xTubeStart, 400);
    firstTopTube.setPosition(_xTubeStart, -550);
    secondBottomTube.setPosition(_xTubeStart + _xTubeOffset, 400);
    secondTopTube.setPosition(_xTubeStart + _xTubeOffset, -250);
    thirdBottomTube.setPosition(_xTubeStart + _xTubeOffset * 2, 400);
    thirdTopTube.setPosition(_xTubeStart + _xTubeOffset * 2, -250);
    gameOver.ground.y = size.y;
  }

  @override
  void update(double dt) {
    if (status == GameStatus.gameOver) {
      return;
    } else if (status == GameStatus.waiting) {
      super.update(0);
      return;
    }

    bottom.update(dt * Speed.gameSpeed);
    firstBottomTube.update(dt * Speed.gameSpeed);
    firstTopTube.update(dt * Speed.gameSpeed);
    secondBottomTube.update(dt * Speed.gameSpeed);
    secondTopTube.update(dt * Speed.gameSpeed);
    thirdBottomTube.update(dt * Speed.gameSpeed);
    thirdTopTube.update(dt * Speed.gameSpeed);

    final Rect birdRect = bird.ground.toRect();

    if (check2ItemsCollision(birdRect, bottom.rect)){
      gameOverAction();
    }

    if (check2ItemsCollision(birdRect, firstBottomTube.ground.toRect())){
      gameOverAction();
    }

    if (check2ItemsCollision(birdRect, firstTopTube.ground.toRect())) {
      gameOverAction();
    }

    if (check2ItemsCollision(birdRect, secondBottomTube.ground.toRect())){
      gameOverAction();
    }

    if (check2ItemsCollision(birdRect, secondTopTube.ground.toRect())){
      gameOverAction();
    }

    if (check2ItemsCollision(birdRect, thirdBottomTube.ground.toRect())){
      gameOverAction();
    }

    if (check2ItemsCollision(birdRect, thirdTopTube.ground.toRect())){
      gameOverAction();
    }

    if (checkIfBirdCrossedTube(firstTopTube) ||
        checkIfBirdCrossedTube(secondTopTube) ||
        checkIfBirdCrossedTube(thirdTopTube)) {
      _scorer.increase();
    }

    super.update(dt);
  }

  void gameOverAction(){
    if (status != GameStatus.gameOver) {
      FlameAudio.play('hit.wav');
      FlameAudio.play('die.wav');
      status = GameStatus.gameOver;
      gameOver.ground.y = (size.y - gameOver.ground.height) / 2;
    }
  }

  bool checkIfBirdCrossedTube(Tube tube) {
    if (!tube.crossedBird) {
      var tubeRect = tube.ground.toRect();
      var xCenterOfTube = tubeRect.left + tubeRect.width / 2;
      var xCenterOfBird = ComponentPositions.birdX + ComponentDimensions.birdWidth / 2;
      if (xCenterOfTube < xCenterOfBird && status == GameStatus.playing) {
        tube.crossedBird = true;
        return true;
      }
    }
    return false;
  }

  @override
  void onTapDown(TapDownInfo info) {
    switch (status) {
      case GameStatus.waiting:
        status = GameStatus.playing;
        bird.jump();
        bottom.move();
        break;
      case GameStatus.gameOver:
        status = GameStatus.waiting;
        initPositions(_spriteImage);
        _scorer.reset();
        break;
      case GameStatus.playing:
        bird.jump();
        break;
      default:
    }
  }

  bool check2ItemsCollision(Rect item1, Rect item2){
    final Rect intersectedRect = item1.intersect(item2);
    return intersectedRect.width > 0 && intersectedRect.height > 0;
  }
}