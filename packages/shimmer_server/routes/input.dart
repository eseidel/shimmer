import 'package:dart_frog/dart_frog.dart';

import 'package:shimmer_server/server.dart';

Server server = Server();

Future<Response> onRequest(RequestContext context) async {
  // Should this time be the client's time?
  server.tickIfNeeded(DateTime.now());
  var body = await context.request.body();
  print(body);
  return Response(body: server.currentTick.toString());
}
