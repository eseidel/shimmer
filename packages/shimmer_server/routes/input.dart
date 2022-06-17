import 'package:dart_frog/dart_frog.dart';

import 'package:shimmer_server/server.dart';

Server server = Server();

Response onRequest(RequestContext context) {
  // Should this time be the client's time?
  server.tickIfNeeded(DateTime.now());
  return Response(body: server.currentTick.toString());
}
