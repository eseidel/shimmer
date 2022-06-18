// MIT License

// Copyright (c) 2022 Blue Fire

// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:

// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import 'dart:math';
import 'package:vector_math/vector_math_64.dart';
import 'package:meta/meta.dart';

abstract class Steerable {
  Vector2 get position;
  Vector2 get velocity;
  double get angle;
  double get angularVelocity;
  Kinematics get kinematics;

  set angle(double value);
  set angularVelocity(double value);
}

class LightKinematics extends BasicKinematics {
  LightKinematics(this._maxSpeed)
      : assert(_maxSpeed > 0, 'maxSpeed must be positive');

  /// Maximum speed with which this agent can move.
  ///
  /// This speed cannot be negative or zero. Reducing the `maxSpeed` will also
  /// reduce the current agent's velocity, if it's greater than the new speed
  /// limit.
  double get maxSpeed => _maxSpeed;
  double _maxSpeed;
  set maxSpeed(double value) {
    assert(value > 0, 'maxSpeed must be positive');
    _maxSpeed = value;
    setVelocitySafe(owner.velocity);
  }

  void stop() {
    owner.velocity.setZero();
  }

  void setVelocity(Vector2 value) {
    assert(
      value.length2 <= maxSpeed * maxSpeed * (1 + 1e-8),
      'Trying to set velocity=$value larger than maxSpeed=$maxSpeed',
    );
    owner.velocity.setFrom(value);
    owner.angle = vectorToAngle(owner.velocity);
  }

  void setVelocitySafe(Vector2 value) {
    final speed = value.length;
    owner.velocity.setFrom(value);
    owner.angle = vectorToAngle(owner.velocity);
    if (speed > maxSpeed) {
      owner.velocity.scale(maxSpeed / speed);
    }
  }

  @override
  Seek seek(Vector2 target) => SeekLight(owner: owner, point: target);
}

class BasicKinematics extends Kinematics {
  @override
  void update(double dt) {
    owner.position.x += owner.velocity.x * dt;
    owner.position.y += owner.velocity.y * dt;
    owner.angle += owner.angularVelocity * dt;
  }
}

/// [Kinematics] class describes laws of motion and constraints on the movements
/// of a [Steerable].
///
/// Usually, this class will contain one or more *control variables* describing
/// the desired steering at any given moment in time, and the logic to apply
/// those steering controls to affect the motion of the owner.
///
/// The main method of this class -- `update()` -- must be invoked by the user
/// periodically, as time progresses, in order to confer motion to the [owner]
/// steerable. For better results, this method should be invoked as frequently
/// as possible.
///
/// The method `handleAttach()` must be called by the user when the kinematics
/// object is attached to a concrete [Steerable].
abstract class Kinematics {
  /// Reference to the object being steered.
  ///
  /// This variable will be set within the `handleAttach()` method, and will
  /// always satisfy the constraint that `own.kinematics == this`.
  late Steerable owner;

  /// This method must be invoked by the [parent] once, when this object is
  /// attached to the parent.
  @mustCallSuper
  void handleAttach(Steerable parent) => owner = parent;

  /// Invoked by the user to signal that time [dt] (in seconds) has passed
  /// within the system.
  ///
  /// Here [dt] may either represent the real or simulated time, but either way
  /// the time intervals [dt] should be sufficiently small to ensure accurate
  /// simulation.
  ///
  /// Within this method the implementation must advance the state of the object
  /// and of the [owner] steerable forward by [dt] seconds. The implementation
  /// may ignore any numeric effects that are `o(dt)`.
  void update(double dt);

  Seek seek(Vector2 target) {
    throw UnsupportedError('Seek behavior is not available for $runtimeType');
  }
}

abstract class Seek extends Behavior {
  factory Seek({required Steerable owner, required Vector2 point}) {
    return owner.kinematics.seek(point);
  }

  Seek._(Steerable owner, this.target) : super(owner);

  /// The point that the behavior is seeking towards.
  final Vector2 target;
}

/// [Seek] behavior for objects that have [LightKinematics].
class SeekLight extends Seek {
  SeekLight({required Steerable owner, required Vector2 point})
      : assert(owner.kinematics is LightKinematics),
        super._(owner, point);

  @override
  void update(double dt) {
    final kinematics = own.kinematics as LightKinematics;
    final offset = target - own.position;
    final distance = offset.normalize();
    var maxSpeed = kinematics.maxSpeed;
    if (maxSpeed * dt > distance) {
      maxSpeed = distance / dt;
    }
    if (maxSpeed == 0) {
      kinematics.stop();
    } else {
      kinematics.setVelocity(offset..scale(maxSpeed));
    }
  }
}

/// Method to convert an orientation angle into a unit vector facing in that
/// direction.
///
/// Every `Steerable` object has property `angle` that describes its
/// orientation in the 2D world. However, this property is somewhat ambiguous
/// in that it doesn't describe which direction corresponds to angle `0`.
/// This method removes such ambiguity. The default implementation corresponds
/// to angle 0 pointing rightwards, and angles growing in the counterclockwise
/// direction.
Vector2 Function(double angle) angleToVector = _defaultAngleToVector;

/// Method to compute the orientation angle of a non-zero vector.
///
/// This method must be the inverse of [angleToVector], modulo τ.
double Function(Vector2 vector) vectorToAngle = _defaultVectorToAngle;

Vector2 _defaultAngleToVector(double angle) {
  return Vector2(cos(angle), -sin(angle));
}

double _defaultVectorToAngle(Vector2 vector) {
  return atan2(-vector.y, vector.x);
}

abstract class Behavior {
  Behavior(this.own);

  final Steerable own;

  void update(double dt);
}
