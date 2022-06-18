import 'package:vector_math/vector_math_64.dart';
// import 'steerable.dart';

// Simplifying assumptions
// - no speculative work on client.
// - clients can never be re-wound.
//

// If this is shared between client and server
// does it end up mixed in or composed or does it have notifiers?

class Entity {
  Vector2 position = Vector2.zero();
  // Needed for walking vs. running vs. dashing.
  Vector2 velocity = Vector2.zero();

  // Collision system?
  // Event system?

  // Buffs
  // Current Action
  // Current effects? (stunned, knocked up, etc.)

  // How does this notify of changes?  Streams?

  // Should this use ticks instead of time?
  void update(double dt) {}
}

// Creates projectiles
// Applies effects to Entities within a range.
// Client: Creates visuals
class Action {}

// Stationary object (structures)
// - Does not need navigation
// Moving object (Minions, Monsters, Players)
// - Needs navigation but is separate per type?
// Projectile (part of an "action", defined by type, source, target, and start?)
// Effect

// class Navigation with Steerable {
//   @override
//   Vector2 get position => positionParent?.position ?? Vector2.zero();
//   @override
//   Vector2 velocity = Vector2.zero();
//   @override
//   double get angle => positionParent?.angle ?? 0;
//   @override
//   double angularVelocity = 0;
//   @override
//   Kinematics kinematics = LightKinematics(100);

//   @override
//   set angle(double value) => positionParent!.angle = value;

//   Behavior? behavior;

//   // Path should be a list of points
//   // We move towards the next point, until we hit an obstacle
//   // If it's a movable obstacle, we try avoidance behaviors.
//   // If it's a non-moving obstacle (should never happen), we re-path.
//   // If after some timeout we have not avoided the obstacle, we repath.

//   void pathTo(Vector2 target) {
//     // Convert from game coordinates to pathing coordinates.
//     // Update path.
//     // tell seek to seek to next coordinate.
//   }

//   void moveTo(Vector2 target) {
//     behavior = kinematics.seek(target);
//   }

//   @override
//   void onMount() {
//     kinematics.handleAttach(this);
//     super.onMount();
//   }

//   @override
//   void update(double dt) {
//     if (parent == null || behavior == null) {
//       return;
//     }
//     behavior!.update(dt);
//     if (velocity.isZero()) {
//       // Seek stopped, so clear it.
//       behavior = null;
//     } else {
//       positionParent!.position += velocity.scaled(dt);
//     }

//     super.update(dt);
//   }
// }
