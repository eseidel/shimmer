import 'package:dart_frog/dart_frog.dart';

import 'package:shimmer_server/server.dart';
import 'package:shimmer_shared/network.dart';
import 'package:shimmer_shared/entity.dart';

import 'dart:convert';

Future<Response> onRequest(RequestContext context) async {
  // Should this time be the client's time?
  var input = NetClientInput.fromJson(await context.request.json());
  var client = sharedServer.net.lookupClient(input.header.clientId);
  client.fromClient.add(input);
  sharedServer.tickIfNeeded(DateTime.now());
  var objects = sharedServer.visibleGameObjects(VisionMask.all);
  print(objects);
  return Response(body: jsonEncode(objects));
}
