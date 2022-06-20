import 'package:shimmer_shared/network.dart';
import 'package:vector_math/vector_math_64.dart';
import 'package:shimmer_shared/src/generated/input.pbgrpc.dart';
// Shouldn't depend on navigation.
import 'navigation.dart';

// Simplifying assumptions
// - no speculative work on client.
// - clients can never be re-wound.
//

// If this is shared between client and server
// does it end up mixed in or composed or does it have notifiers?

enum VisionMask {
  red,
  blue,
  all,
}

class Entity {
  String id;
  // FIXME: need to decide if we're using ints or floats.
  Vector2 position = Vector2.zero();
  // Needed for walking vs. running vs. dashing.
  Vector2 velocity = Vector2.zero();
  double angle = 0.0;

  VisionMask visionMask = VisionMask.all;

  // FIXME: This doesn't belong here.
  late SimpleNavigation navigation;

  Entity(this.id) {
    navigation = SimpleNavigation(this);
  }

  bool visibleTo(VisionMask mask) {
    return visionMask == VisionMask.all || visionMask == mask;
  }

  EntityProto toProto() {
    return EntityProto(
      id: id,
      position: position.toProto(),
      // velocity: velocity.toProto(),
      // angle: angle,
      // visionMask: visionMask.index,
    );
  }

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