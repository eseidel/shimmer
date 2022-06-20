///
//  Generated code. Do not modify.
//  source: input.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:async' as $async;

import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'input.pb.dart' as $0;
export 'input.pb.dart';

class InputServiceClient extends $grpc.Client {
  static final _$sendInput =
      $grpc.ClientMethod<$0.InputRequest, $0.ClientUpdate>(
          '/input.InputService/SendInput',
          ($0.InputRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => $0.ClientUpdate.fromBuffer(value));

  InputServiceClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options, interceptors: interceptors);

  $grpc.ResponseFuture<$0.ClientUpdate> sendInput($0.InputRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$sendInput, request, options: options);
  }
}

abstract class InputServiceBase extends $grpc.Service {
  $core.String get $name => 'input.InputService';

  InputServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.InputRequest, $0.ClientUpdate>(
        'SendInput',
        sendInput_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.InputRequest.fromBuffer(value),
        ($0.ClientUpdate value) => value.writeToBuffer()));
  }

  $async.Future<$0.ClientUpdate> sendInput_Pre(
      $grpc.ServiceCall call, $async.Future<$0.InputRequest> request) async {
    return sendInput(call, await request);
  }

  $async.Future<$0.ClientUpdate> sendInput(
      $grpc.ServiceCall call, $0.InputRequest request);
}
