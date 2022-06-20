///
//  Generated code. Do not modify.
//  source: input.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,deprecated_member_use_from_same_package,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use inputRequestDescriptor instead')
const InputRequest$json = const {
  '1': 'InputRequest',
  '2': const [
    const {'1': 'clientId', '3': 1, '4': 1, '5': 9, '10': 'clientId'},
    const {'1': 'action', '3': 2, '4': 1, '5': 9, '10': 'action'},
    const {'1': 'position', '3': 3, '4': 1, '5': 11, '6': '.input.InputRequest.Position', '10': 'position'},
    const {'1': 'msSinceStart', '3': 4, '4': 1, '5': 5, '10': 'msSinceStart'},
  ],
  '3': const [InputRequest_Position$json],
};

@$core.Deprecated('Use inputRequestDescriptor instead')
const InputRequest_Position$json = const {
  '1': 'Position',
  '2': const [
    const {'1': 'x', '3': 1, '4': 1, '5': 5, '10': 'x'},
    const {'1': 'y', '3': 2, '4': 1, '5': 5, '10': 'y'},
  ],
};

/// Descriptor for `InputRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List inputRequestDescriptor = $convert.base64Decode('CgxJbnB1dFJlcXVlc3QSGgoIY2xpZW50SWQYASABKAlSCGNsaWVudElkEhYKBmFjdGlvbhgCIAEoCVIGYWN0aW9uEjgKCHBvc2l0aW9uGAMgASgLMhwuaW5wdXQuSW5wdXRSZXF1ZXN0LlBvc2l0aW9uUghwb3NpdGlvbhIiCgxtc1NpbmNlU3RhcnQYBCABKAVSDG1zU2luY2VTdGFydBomCghQb3NpdGlvbhIMCgF4GAEgASgFUgF4EgwKAXkYAiABKAVSAXk=');
@$core.Deprecated('Use inputReplyDescriptor instead')
const InputReply$json = const {
  '1': 'InputReply',
};

/// Descriptor for `InputReply`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List inputReplyDescriptor = $convert.base64Decode('CgpJbnB1dFJlcGx5');
