import 'package:radiance/steering.dart';
import 'package:flame/components.dart';
import 'package:shimmer_shared/geometry.dart';

class UnitSystem {
  const UnitSystem();

  final double pathToGameMultiplier = 100.0;

  Position fromGameToPathCoords(Vector2 gameCoords) {
    gameCoords /= pathToGameMultiplier;
    return Position(gameCoords.x.floor(), gameCoords.y.floor());
  }
}

const UnitSystem unitSystem = UnitSystem();

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
