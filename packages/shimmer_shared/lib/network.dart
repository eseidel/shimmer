import 'geometry.dart';

import 'package:json_annotation/json_annotation.dart';

part 'network.g.dart';

enum NetActionType {
  moveTo,
}

@JsonSerializable(explicitToJson: true)
class NetClientInput {
  const NetClientInput({
    required this.action,
    required this.position,
    required this.msSinceStart,
  });

  // action is probably a string?
  final NetActionType action;
  final Position position;
  final int msSinceStart;

  factory NetClientInput.fromJson(Map<String, dynamic> json) =>
      _$NetClientInputFromJson(json);
  Map<String, dynamic> toJson() => _$NetClientInputToJson(this);
}

class NetAction {
  const NetAction(this.actionType);

  final NetActionType actionType;
}

class NetGameObject {
  const NetGameObject(this.id, this.position, this.action);
  final String id;
  final Position position;
  final NetAction action;
}

class NetGlobalState {
  const NetGlobalState(this.startTime);
  final DateTime startTime;
}

class NetClientState {
  // current ability timeouts?
}

class NetVisibleState {
  const NetVisibleState(this.gameObjects);
  final List<NetGameObject> gameObjects;
}

class NetClientUpdate {
  const NetClientUpdate({
    required this.global,
    required this.visible,
    required this.private,
  });

  // Should this split by visibility?
  // e.g. "global info", "team info", "private info"?

  // Server start time, scoreboard, etc.
  final NetGlobalState global;
  // Team state.
  // Visible objects.
  // Visible actions in progress.
  // Last known information about opponents, etc.
  final NetVisibleState visible;

  // Per client specific state (like active abilies?)
  final NetClientState private;
}
