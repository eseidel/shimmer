// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'network.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NetClientInput _$NetClientInputFromJson(Map<String, dynamic> json) =>
    NetClientInput(
      action: $enumDecode(_$NetActionTypeEnumMap, json['action']),
      position: Position.fromJson(json['position'] as Map<String, dynamic>),
      msSinceStart: json['msSinceStart'] as int,
    );

Map<String, dynamic> _$NetClientInputToJson(NetClientInput instance) =>
    <String, dynamic>{
      'action': _$NetActionTypeEnumMap[instance.action],
      'position': instance.position.toJson(),
      'msSinceStart': instance.msSinceStart,
    };

const _$NetActionTypeEnumMap = {
  NetActionType.moveTo: 'moveTo',
};
