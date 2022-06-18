import 'dart:ui' as ui;

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;

import 'package:shimmer_shared/geometry.dart';
import 'package:shimmer_shared/grid.dart';
import 'player.dart';
import 'package:shimmer_shared/steerable.dart';

class UnitSystem {
  const UnitSystem();

  final double pathToGameMultiplier = 100.0;

  Position fromGameToPathCoords(Vector2 gameCoords) {
    gameCoords /= pathToGameMultiplier;
    return Position(gameCoords.x.floor(), gameCoords.y.floor());
  }

  Position fromGameToNetCoords(Vector2 gameCoords) {
    return Position(gameCoords.x.toInt(), gameCoords.y.toInt());
  }

  Vector2 fromNetToGame(Position netCoords) {
    return Vector2(netCoords.x.toDouble(), netCoords.y.toDouble());
  }
}

const UnitSystem unitSystem = UnitSystem();

class PlayerRenderer extends PositionComponent {
  static final _paint = Paint()..color = Colors.green;

  PlayerRenderer({required double size, super.position})
      : super(size: Vector2(size, size), anchor: Anchor.center);

  @override
  Future<void>? onLoad() {
    add(RectangleComponent.square(
      size: width,
      paint: _paint,
      position: size / 2,
      anchor: Anchor.center,
    ));
    return super.onLoad();
  }
}

class ServerComponent extends PositionComponent with ServerUpdatable {
  ServerComponent({super.position, super.size, super.anchor});

  @override
  void serverPositionChanged(Position serverPosition) {
    position = unitSystem.fromNetToGame(serverPosition);
  }

  @override
  void serverRemoved() {
    // Could play animation depending on what's being removed.
    // e.g. missles just disappear, but enemies might fade out.
    removeFromParent();
  }
}

class PlayerComponent extends ServerComponent {
  late NavigationComponent nav;

  PlayerComponent({super.position, required double size})
      : super(size: Vector2(size, size), anchor: Anchor.center);

  @override
  Future<void>? onLoad() {
    add(nav = NavigationComponent());
    add(PlayerRenderer(size: width, position: size / 2)); // Renderer
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

  // Path should be a list of points
  // We move towards the next point, until we hit an obstacle
  // If it's a movable obstacle, we try avoidance behaviors.
  // If it's a non-moving obstacle (should never happen), we re-path.
  // If after some timeout we have not avoided the obstacle, we repath.

  void pathTo(Vector2 target) {
    // Convert from game coordinates to pathing coordinates.
    // Update path.
    // tell seek to seek to next coordinate.
  }

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
  late PlayerComponent playerComponent;

  @override
  Future<void> onLoad() async {
    add(await loadMap());
    add(playerComponent = PlayerComponent(size: 50, position: size / 2));
    var client = await connectToServer(Uri.parse("http://localhost:8080"));
    player = Player(client, playerComponent);
    camera.followComponent(playerComponent);
  }

  Future<Client> connectToServer(Uri endpoint) async {
    return Client(endpoint);
  }

  Future<NewMap> loadMap() async {
    var data = await rootBundle.load('assets/images/obstacle.png');
    final buffer = data.buffer;
    var ints = buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    var mapImage = img.decodeImage(ints)!;
    var obstacleGrid = NewMap.obstacleGridFromImage(mapImage);
    var obstacleImage = await ImageExtension.fromPixels(
        mapImage.getBytes(), mapImage.width, mapImage.height);
    return NewMap(obstacleGrid, obstacleImage);
  }

  @override
  void onTapUp(TapUpInfo info) {
    add(TapIndicator(position: info.eventPosition.game));
    player.moveTo(info.eventPosition.game);
    super.onTapUp(info);
  }
}

class NewMap extends Component {
  Grid<bool> obstacleGrid;
  late Rect bounds;
  ui.Image obstacleImage;

  static Grid<bool> obstacleGridFromImage(img.Image image) {
    return Grid.filled(ISize(image.height, image.height),
        (GridPosition position) {
      var color = image.getPixel(position.x, position.y);
      // Treat darker pixels as obstacles, lighter as empty.
      return img.getLuminance(color) < 128;
    });
  }

  static final Paint _paintBorder = Paint()
    ..color = Colors.white12
    ..strokeWidth = 10
    ..style = PaintingStyle.stroke;
  static final Paint _paintBg = Paint()..color = const Color(0xFF333333);
  static final Paint _paintImage = Paint()
    ..color = const Color.fromRGBO(0, 0, 0, 0.5);

  NewMap(this.obstacleGrid, this.obstacleImage) : super(priority: 0) {
    bounds = Rect.fromLTWH(
      0,
      0,
      obstacleGrid.width * unitSystem.pathToGameMultiplier,
      obstacleGrid.height * unitSystem.pathToGameMultiplier,
    );
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(bounds, _paintBg);
    canvas.drawRect(bounds, _paintBorder);
    canvas.drawImageRect(
        obstacleImage,
        Rect.fromLTWH(0, 0, obstacleImage.width.toDouble(),
            obstacleImage.height.toDouble()),
        bounds,
        _paintImage);
  }
}

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
