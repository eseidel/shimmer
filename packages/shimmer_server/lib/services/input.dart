import 'package:grpc/grpc.dart';

import 'package:shimmer_server/server.dart';
import 'package:shimmer_shared/entity.dart';
import 'package:shimmer_shared/src/generated/input.pbgrpc.dart';

class InputService extends InputServiceBase {
  @override
  Future<ClientUpdate> sendInput(ServiceCall call, InputRequest request) async {
    var client = sharedServer.net.lookupClient(request.clientId);
    client.fromClient.add(request);
    sharedServer.tickIfNeeded(DateTime.now());
    return ClientUpdate(
      entities: sharedServer.visibleGameObjects(VisionMask.all),
    );
  }
}
