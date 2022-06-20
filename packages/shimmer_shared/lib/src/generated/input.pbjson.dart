///
//  Generated code. Do not modify.
//  source: input.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,deprecated_member_use_from_same_package,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use positionProtoDescriptor instead')
const PositionProto$json = const {
  '1': 'PositionProto',
  '2': const [
    const {'1': 'x', '3': 1, '4': 1, '5': 5, '10': 'x'},
    const {'1': 'y', '3': 2, '4': 1, '5': 5, '10': 'y'},
  ],
};

/// Descriptor for `PositionProto`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List positionProtoDescriptor = $convert.base64Decode('Cg1Qb3NpdGlvblByb3RvEgwKAXgYASABKAVSAXgSDAoBeRgCIAEoBVIBeQ==');
@$core.Deprecated('Use entityProtoDescriptor instead')
const EntityProto$json = const {
  '1': 'EntityProto',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    const {'1': 'position', '3': 2, '4': 1, '5': 11, '6': '.input.PositionProto', '10': 'position'},
  ],
};

/// Descriptor for `EntityProto`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List entityProtoDescriptor = $convert.base64Decode('CgtFbnRpdHlQcm90bxIOCgJpZBgBIAEoCVICaWQSMAoIcG9zaXRpb24YAiABKAsyFC5pbnB1dC5Qb3NpdGlvblByb3RvUghwb3NpdGlvbg==');
@$core.Deprecated('Use inputRequestDescriptor instead')
const InputRequest$json = const {
  '1': 'InputRequest',
  '2': const [
    const {'1': 'clientId', '3': 1, '4': 1, '5': 9, '10': 'clientId'},
    const {'1': 'action', '3': 2, '4': 1, '5': 9, '10': 'action'},
    const {'1': 'position', '3': 3, '4': 1, '5': 11, '6': '.input.PositionProto', '10': 'position'},
    const {'1': 'msSinceStart', '3': 4, '4': 1, '5': 5, '10': 'msSinceStart'},
  ],
};

/// Descriptor for `InputRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List inputRequestDescriptor = $convert.base64Decode('CgxJbnB1dFJlcXVlc3QSGgoIY2xpZW50SWQYASABKAlSCGNsaWVudElkEhYKBmFjdGlvbhgCIAEoCVIGYWN0aW9uEjAKCHBvc2l0aW9uGAMgASgLMhQuaW5wdXQuUG9zaXRpb25Qcm90b1IIcG9zaXRpb24SIgoMbXNTaW5jZVN0YXJ0GAQgASgFUgxtc1NpbmNlU3RhcnQ=');
@$core.Deprecated('Use clientUpdateDescriptor instead')
const ClientUpdate$json = const {
  '1': 'ClientUpdate',
  '2': const [
    const {'1': 'entities', '3': 1, '4': 3, '5': 11, '6': '.input.EntityProto', '10': 'entities'},
  ],
};

/// Descriptor for `ClientUpdate`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List clientUpdateDescriptor = $convert.base64Decode('CgxDbGllbnRVcGRhdGUSLgoIZW50aXRpZXMYASADKAsyEi5pbnB1dC5FbnRpdHlQcm90b1IIZW50aXRpZXM=');
