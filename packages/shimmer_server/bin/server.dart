import 'package:grpc/grpc.dart';
import 'package:shimmer_shared/src/generated/input.pbgrpc.dart';

import 'package:shimmer_server/server.dart';
import 'package:shimmer_shared/entity.dart';

class InputService extends InputServiceBase {
  @override
  Future<InputReply> sendInput(ServiceCall call, InputRequest input) async {
    var client = sharedServer.net.lookupClient(input.clientId);
    client.fromClient.add(input);
    sharedServer.tickIfNeeded(DateTime.now());
    var objects = sharedServer.visibleGameObjects(VisionMask.all);
    print(objects);
    return InputReply();
  }
}

Future<void> main(List<String> args) async {
  final server = Server(
    [InputService()],
    const <Interceptor>[],
    CodecRegistry(codecs: const [GzipCodec(), IdentityCodec()]),
  );
  await server.serve(port: 50051);
  print('Server listening on port ${server.port}...');
}
