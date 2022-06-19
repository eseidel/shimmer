// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'network.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NetMessageHeader _$NetMessageHeaderFromJson(Map<String, dynamic> json) =>
    NetMessageHeader(
      json['clientId'] as String,
    );

Map<String, dynamic> _$NetMessageHeaderToJson(NetMessageHeader instance) =>
    <String, dynamic>{
      'clientId': instance.clientId,
    };

NetClientInput _$NetClientInputFromJson(Map<String, dynamic> json) =>
    NetClientInput(
      header: NetMessageHeader.fromJson(json['header'] as Map<String, dynamic>),
      action: $enumDecode(_$NetActionTypeEnumMap, json['action']),
      position: Position.fromJson(json['position'] as Map<String, dynamic>),
      msSinceStart: json['msSinceStart'] as int,
    );

Map<String, dynamic> _$NetClientInputToJson(NetClientInput instance) =>
    <String, dynamic>{
      'header': instance.header.toJson(),
      'action': _$NetActionTypeEnumMap[instance.action],
      'position': instance.position.toJson(),
      'msSinceStart': instance.msSinceStart,
    };

const _$NetActionTypeEnumMap = {
  NetActionType.moveTo: 'moveTo',
};
