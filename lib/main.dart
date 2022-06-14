import 'package:flutter/services.dart';
import 'package:shimmer/geometry.dart';
import 'package:image/image.dart' as img;

import 'grid.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/extensions.dart';
import 'package:flame/effects.dart';
import 'package:radiance/steering.dart';
import 'package:flutter/material.dart';

class SpinningSquare extends PositionComponent {
  static final _paint = Paint()..color = Colors.green;

  SpinningSquare({required double size, super.position})
      : super(size: Vector2(size, size), anchor: Anchor.center);

  @override
  Future<void>? onLoad() {
    add(RectangleComponent.square(
      size: width,
      paint: _paint,
      position: size / 2,
      anchor: Anchor.center,
    )
        // ..add(
        //     RotateEffect.by(
        //       2 * pi,
        //       EffectController(duration: 3, infinite: true),
        //     ),
        //   ),
        );
    return super.onLoad();
  }
}

class NavigationComponent extends Component with Steerable {
  @override
  Vector2 get position => positionParent?.position ?? Vector2.zero();
  @override
  Vector2 velocity = Vector2.zero();
  @override
  double get angle => positionParent?.angle ?? 0;
  @override
  double angularVelocity = 0;
  @override
  Kinematics kinematics = LightKinematics(100);

  PositionComponent? get positionParent => parent as PositionComponent;

  @override
  set angle(double value) => positionParent!.angle = value;

  Behavior? behavior;

  void moveTo(Vector2 target) {
    behavior = kinematics.seek(target);
  }

  @override
  void onMount() {
    kinematics.handleAttach(this);
    super.onMount();
  }

  @override
  void update(double dt) {
    if (parent == null || behavior == null) {
      return;
    }
    behavior!.update(dt);
    if (velocity.isZero()) {
      // Seek stopped, so clear it.
      behavior = null;
    } else {
      positionParent!.position += velocity.scaled(dt);
    }

    super.update(dt);
  }
}

class Player extends PositionComponent {
  late NavigationComponent nav;

  Player({super.position, required double size})
      : super(size: Vector2(size, size), anchor: Anchor.center);

  @override
  Future<void>? onLoad() {
    add(nav = NavigationComponent());
    add(SpinningSquare(size: width, position: size / 2)); // Renderer
    return super.onLoad();
  }
}

class TapIndicator extends PositionComponent {
  static final _paint = Paint()..color = Colors.blue;

  TapIndicator({super.position});

  @override
  void onMount() {
    super.onMount();
    add(CircleComponent(
      radius: 10,
      paint: _paint,
      anchor: Anchor.center,
    ));
    add(
      SequenceEffect([
        ScaleEffect.to(Vector2.zero(), EffectController(duration: 0.2)),
        RemoveEffect(),
      ]),
    );
  }
}

class ShimmerGame extends FlameGame with TapDetector {
  late Player player;

  Future<Grid<bool>> obstacleGridFromImage(img.Image image) async {
    return Future.value(
        Grid.filled(ISize(image.height, image.height), (GridPosition position) {
      var color = image.getPixel(position.x, position.y);
      // Treat darker pixels as obstacles, lighter as empty.
      return img.getLuminance(color) < 128;
    }));
  }

  @override
  Future<void> onLoad() async {
    var data = await rootBundle.load('assets/images/checker-4x4.png');
    final buffer = data.buffer;
    var ints = buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    var mapImage = img.decodeImage(ints)!;
    final obstacleGrid = await obstacleGridFromImage(mapImage);
    var map = NewMap(obstacleGrid);
    add(map);
    add(player = Player(size: 50, position: size / 2));
    camera.followComponent(player, worldBounds: map.bounds);
  }

  @override
  void onTapUp(TapUpInfo info) {
    add(TapIndicator(position: info.eventPosition.game));
    player.nav.moveTo(info.eventPosition.game);
    super.onTapUp(info);
  }
}

class NewMap extends Component {
  static const double multiplier = 100;
  Grid<bool> obstacleGrid;
  Rect bounds;

  static final Paint _paintObstacle = Paint()
    ..color = Colors.orange
    ..style = PaintingStyle.fill;

  static final Paint _paintBorder = Paint()
    ..color = Colors.white12
    ..strokeWidth = 10
    ..style = PaintingStyle.stroke;
  static final Paint _paintBg = Paint()..color = const Color(0xFF333333);

  late final List<Rect> _rectPool;

  NewMap(this.obstacleGrid)
      : bounds = Rect.fromLTWH(0, 0, (obstacleGrid.width + 1) * multiplier,
            (obstacleGrid.height + 1) * multiplier),
        super(priority: 0) {
    _rectPool = [];
    for (var position in obstacleGrid.allPositions) {
      if (obstacleGrid.get(position) == true) {
        _rectPool.add(Rect.fromLTWH(multiplier * position.x,
            multiplier * position.y, multiplier, multiplier));
      }
    }
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(bounds, _paintBg);
    canvas.drawRect(bounds, _paintBorder);
    for (var rect in _rectPool) {
      canvas.drawRect(rect, _paintObstacle);
    }
  }
}

// class Map extends Component {
//   static const double size = 1500;
//   static const Rect bounds = Rect.fromLTWH(-size, -size, 2 * size, 2 * size);

//   static final Paint _paintBorder = Paint()
//     ..color = Colors.white12
//     ..strokeWidth = 10
//     ..style = PaintingStyle.stroke;
//   static final Paint _paintBg = Paint()..color = const Color(0xFF333333);

//   static final _rng = Random();

//   late final List<Paint> _paintPool;
//   late final List<Rect> _rectPool;

//   Map() : super(priority: 0) {
//     _paintPool = List<Paint>.generate(
//       (size / 50).ceil(),
//       (_) => PaintExtension.random(rng: _rng)
//         ..style = PaintingStyle.stroke
//         ..strokeWidth = 2,
//       growable: false,
//     );
//     _rectPool = List<Rect>.generate(
//       (size / 50).ceil(),
//       (i) => Rect.fromCircle(center: Offset.zero, radius: size - i * 50),
//       growable: false,
//     );
//   }

//   @override
//   void render(Canvas canvas) {
//     canvas.drawRect(bounds, _paintBg);
//     canvas.drawRect(bounds, _paintBorder);
//     for (var i = 0; i < (size / 50).ceil(); i++) {
//       canvas.drawCircle(Offset.zero, size - i * 50, _paintPool[i]);
//       canvas.drawRect(_rectPool[i], _paintBorder);
//     }
//   }

//   static double genCoord() {
//     return -size + _rng.nextDouble() * (2 * size);
//   }
// }

class MyGame extends StatelessWidget {
  const MyGame({super.key});

  @override
  Widget build(BuildContext context) {
    return GameWidget(game: ShimmerGame());
  }
}

void main() {
  runApp(const MyGame());
}
