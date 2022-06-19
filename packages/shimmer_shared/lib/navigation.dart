import 'package:vector_math/vector_math_64.dart';
import 'steerable.dart';
import 'extensions/vector2.dart';
import 'entity.dart';

class SimpleNavigation with Steerable {
  @override
  Vector2 get position => parent.position;
  @override
  Vector2 velocity = Vector2.zero();
  @override
  double get angle => parent.angle;
  @override
  double angularVelocity = 0;
  @override
  Kinematics kinematics = LightKinematics(100);

  @override
  set angle(double value) => parent.angle = value;

  Entity parent;
  Behavior? behavior;

  SimpleNavigation(this.parent) {
    kinematics.owner = this;
  }

  // Path should be a list of points
  // We move towards the next point, until we hit an obstacle
  // If it's a movable obstacle, we try avoidance behaviors.
  // If it's a non-moving obstacle (should never happen), we re-path.
  // If after some timeout we have not avoided the obstacle, we repath.

  // void pathTo(Vector2 target) {
  //   // Convert from game coordinates to pathing coordinates.
  //   // Update path.
  //   // tell seek to seek to next coordinate.
  // }

  void moveTo(Vector2 target) {
    behavior = kinematics.seek(target);
  }

  void update(double dt) {
    if (behavior == null) {
      return;
    }
    behavior!.update(dt);
    if (velocity.isZero()) {
      // Seek stopped, so clear it.
      behavior = null;
    } else {
      parent.position += velocity.scaled(dt);
    }
  }
}
