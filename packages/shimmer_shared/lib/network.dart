import 'geometry.dart';

import 'package:vector_math/vector_math_64.dart';
import 'package:shimmer_shared/src/generated/input.pbgrpc.dart';

enum ActionType {
  moveTo,
}

extension Vector2Proto on Vector2 {
  PositionProto toProto() => PositionProto(x: x.toInt(), y: y.toInt());
}

extension PostionProtoExtension on Position {
  PositionProto toProto() => PositionProto(x: x, y: y);
}

// @JsonSerializable(explicitToJson: true)
// class NetConnectClient {
//   final String userId;

//   const NetConnectClient(this.userId);

//   factory NetConnectClient.fromJson(Map<String, dynamic> json) =>
//       _$NetConnectClientFromJson(json);
//   Map<String, dynamic> toJson() => _$NetConnectClientToJson(this);
// }

// @JsonSerializable(explicitToJson: true)
// class NetEnvelope {
//   const NetEnvelope(this.clientId, this.content);
//   final String clientId;
//   final NetMessageContent content;

//   factory NetEnvelope.fromJson(Map<String, dynamic> json) =>
//       _$NetEnvelopeFromJson(json);
//   Map<String, dynamic> toJson() => _$NetEnvelopeToJson(this);
// }

// @JsonSerializable(explicitToJson: true)
// class NetMessageContent {
//   const NetMessageContent();

//   // factory NetMessageContent.fromJson(Map<String, dynamic> json) =>
//   //     _$NetMessageContentFromJson(json);
//   // Map<String, dynamic> toJson() => _$NetMessageContentToJson(this);
// }

// @JsonSerializable(explicitToJson: true)
// class NetMessageHeader {
//   const NetMessageHeader(this.clientId);

//   final String clientId;

//   factory NetMessageHeader.fromJson(Map<String, dynamic> json) =>
//       _$NetMessageHeaderFromJson(json);
//   Map<String, dynamic> toJson() => _$NetMessageHeaderToJson(this);
// }

// @JsonSerializable(explicitToJson: true)
// class NetClientInput {
//   const NetClientInput({
//     required this.header,
//     required this.action,
//     required this.position,
//     required this.msSinceStart,
//   }) : super();

//   final NetMessageHeader header;

//   // action is probably a string?
//   final NetActionType action;
//   final Position position;
//   final int msSinceStart;

//   factory NetClientInput.fromJson(Map<String, dynamic> json) =>
//       _$NetClientInputFromJson(json);
//   Map<String, dynamic> toJson() => _$NetClientInputToJson(this);
// }

// class NetAction {
//   const NetAction(this.actionType);

//   final NetActionType actionType;
// }

// class NetGameObject {
//   const NetGameObject(this.id, this.position, this.angle);

//   final String id;
//   final Position position;
//   final double angle;
//   // final NetAction action;
// }

// class NetGlobalState {
//   const NetGlobalState(this.startTime);
//   final DateTime startTime;
// }

// class NetClientState {
//   // current ability timeouts?
// }

// class NetVisibleState {
//   const NetVisibleState(this.gameObjects);
//   final List<NetGameObject> gameObjects;
// }

// class NetClientUpdate {
//   const NetClientUpdate({
//     required this.global,
//     required this.visible,
//     required this.private,
//   });

//   // Should this split by visibility?
//   // e.g. "global info", "team info", "private info"?

//   // Server start time, scoreboard, etc.
//   final NetGlobalState global;
//   // Team state.
//   // Visible objects.
//   // Visible actions in progress.
//   // Last known information about opponents, etc.
//   final NetVisibleState visible;

//   // Per client specific state (like active abilies?)
//   final NetClientState private;
// }
